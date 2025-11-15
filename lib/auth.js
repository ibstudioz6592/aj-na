import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

const JWT_SECRET = process.env.JWT_SECRET || 'your-super-secret-jwt-key-change-in-production';
const API_KEYS = new Map(); // In production, use Redis or database

// Mock user database - replace with real database
const users = new Map();
const apiKeys = new Map();

// Rate limiting storage - replace with Redis in production
const rateLimitStore = new Map();

export class AuthService {
  static generateApiKey() {
    return `ak-${uuidv4().replace(/-/g, '')}`;
  }

  static async hashPassword(password) {
    return await bcrypt.hash(password, 12);
  }

  static async verifyPassword(password, hash) {
    return await bcrypt.compare(password, hash);
  }

  static generateJWT(payload) {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: '24h' });
  }

  static verifyJWT(token) {
    try {
      return jwt.verify(token, JWT_SECRET);
    } catch (error) {
      return null;
    }
  }

  static async createUser(email, password, plan = 'free') {
    const userId = uuidv4();
    const hashedPassword = await this.hashPassword(password);
    const apiKey = this.generateApiKey();
    
    const user = {
      id: userId,
      email,
      password: hashedPassword,
      plan,
      created_at: new Date().toISOString(),
      api_key: apiKey,
      usage: {
        requests_this_month: 0,
        tokens_this_month: 0,
        last_reset: new Date().toISOString()
      },
      limits: this.getPlanLimits(plan)
    };

    users.set(userId, user);
    apiKeys.set(apiKey, userId);
    
    return { user: this.sanitizeUser(user), apiKey };
  }

  static getPlanLimits(plan) {
    const limits = {
      free: { requests_per_minute: 20, requests_per_month: 1000, tokens_per_month: 50000 },
      pro: { requests_per_minute: 100, requests_per_month: 10000, tokens_per_month: 500000 },
      enterprise: { requests_per_minute: 500, requests_per_month: 100000, tokens_per_month: 5000000 }
    };
    return limits[plan] || limits.free;
  }

  static sanitizeUser(user) {
    const { password, ...sanitized } = user;
    return sanitized;
  }

  static async authenticateUser(email, password) {
    const user = Array.from(users.values()).find(u => u.email === email);
    if (!user) return null;

    const isValid = await this.verifyPassword(password, user.password);
    return isValid ? this.sanitizeUser(user) : null;
  }

  static getUserByApiKey(apiKey) {
    const userId = apiKeys.get(apiKey);
    return userId ? users.get(userId) : null;
  }

  static updateUsage(userId, tokensUsed) {
    const user = users.get(userId);
    if (!user) return false;

    const now = new Date();
    const lastReset = new Date(user.usage.last_reset);
    
    // Reset monthly counters if needed
    if (now.getMonth() !== lastReset.getMonth() || now.getFullYear() !== lastReset.getFullYear()) {
      user.usage.requests_this_month = 0;
      user.usage.tokens_this_month = 0;
      user.usage.last_reset = now.toISOString();
    }

    user.usage.requests_this_month += 1;
    user.usage.tokens_this_month += tokensUsed;
    
    return true;
  }
}

export const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  const apiKey = req.headers['x-api-key'];

  if (apiKey) {
    // API Key authentication
    const user = AuthService.getUserByApiKey(apiKey);
    if (!user) {
      return res.status(401).json({
        error: {
          type: 'authentication_error',
          code: 'invalid_api_key',
          message: 'Invalid API key provided'
        }
      });
    }
    req.user = user;
    return next();
  }

  if (authHeader && authHeader.startsWith('Bearer ')) {
    // JWT authentication
    const token = authHeader.slice(7);
    const decoded = AuthService.verifyJWT(token);
    
    if (!decoded) {
      return res.status(401).json({
        error: {
          type: 'authentication_error',
          code: 'invalid_token',
          message: 'Invalid or expired token'
        }
      });
    }

    const user = users.get(decoded.userId);
    if (!user) {
      return res.status(401).json({
        error: {
          type: 'authentication_error',
          code: 'user_not_found',
          message: 'User not found'
        }
      });
    }

    req.user = user;
    return next();
  }

  return res.status(401).json({
    error: {
      type: 'authentication_error',
      code: 'missing_authentication',
      message: 'Authentication required. Provide API key via X-API-Key header or Bearer token via Authorization header'
    }
  });
};

export const rateLimitMiddleware = (req, res, next) => {
  if (!req.user) return next();

  const userId = req.user.id;
  const now = Date.now();
  const windowMs = 60 * 1000; // 1 minute
  const limit = req.user.limits.requests_per_minute;

  if (!rateLimitStore.has(userId)) {
    rateLimitStore.set(userId, { count: 1, resetTime: now + windowMs });
    return next();
  }

  const userLimit = rateLimitStore.get(userId);
  
  if (now > userLimit.resetTime) {
    // Reset window
    rateLimitStore.set(userId, { count: 1, resetTime: now + windowMs });
    return next();
  }

  if (userLimit.count >= limit) {
    return res.status(429).json({
      error: {
        type: 'rate_limit_exceeded',
        code: 'requests_per_minute_exceeded',
        message: `Rate limit exceeded. Maximum ${limit} requests per minute allowed for your plan.`,
        retry_after: Math.ceil((userLimit.resetTime - now) / 1000)
      }
    });
  }

  userLimit.count++;
  return next();
};

export const usageLimitMiddleware = (req, res, next) => {
  if (!req.user) return next();

  const user = req.user;
  
  if (user.usage.requests_this_month >= user.limits.requests_per_month) {
    return res.status(429).json({
      error: {
        type: 'usage_limit_exceeded',
        code: 'monthly_requests_exceeded',
        message: `Monthly request limit exceeded. Upgrade your plan or wait until next month.`,
        current_usage: user.usage.requests_this_month,
        limit: user.limits.requests_per_month
      }
    });
  }

  if (user.usage.tokens_this_month >= user.limits.tokens_per_month) {
    return res.status(429).json({
      error: {
        type: 'usage_limit_exceeded',
        code: 'monthly_tokens_exceeded',
        message: `Monthly token limit exceeded. Upgrade your plan or wait until next month.`,
        current_usage: user.usage.tokens_this_month,
        limit: user.limits.tokens_per_month
      }
    });
  }

  next();
};
