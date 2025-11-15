import winston from 'winston';
import { v4 as uuidv4 } from 'uuid';

// Production-grade logging configuration
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'ai-api-platform' },
  transports: [
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' })
  ]
});

// Add console logging for development
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.simple()
    )
  }));
}

// Request tracking storage (use Redis in production)
const requestMetrics = {
  total_requests: 0,
  total_tokens: 0,
  requests_by_model: {},
  requests_by_user: {},
  response_times: [],
  errors: []
};

export class MonitoringService {
  static generateRequestId() {
    return uuidv4();
  }

  static logRequest(requestId, userId, model, prompt, response, duration, tokens) {
    const logData = {
      request_id: requestId,
      user_id: userId,
      model,
      prompt_length: prompt.length,
      response_length: response.length,
      duration_ms: duration,
      tokens_used: tokens,
      timestamp: new Date().toISOString()
    };

    logger.info('API Request', logData);
    
    // Update metrics
    requestMetrics.total_requests++;
    requestMetrics.total_tokens += tokens;
    requestMetrics.requests_by_model[model] = (requestMetrics.requests_by_model[model] || 0) + 1;
    requestMetrics.requests_by_user[userId] = (requestMetrics.requests_by_user[userId] || 0) + 1;
    requestMetrics.response_times.push(duration);

    // Keep only last 1000 response times
    if (requestMetrics.response_times.length > 1000) {
      requestMetrics.response_times = requestMetrics.response_times.slice(-1000);
    }
  }

  static logError(requestId, userId, error, context = {}) {
    const errorData = {
      request_id: requestId,
      user_id: userId,
      error: error.message,
      stack: error.stack,
      context,
      timestamp: new Date().toISOString()
    };

    logger.error('API Error', errorData);
    
    requestMetrics.errors.push({
      ...errorData,
      timestamp: Date.now()
    });

    // Keep only last 100 errors
    if (requestMetrics.errors.length > 100) {
      requestMetrics.errors = requestMetrics.errors.slice(-100);
    }
  }

  static getMetrics() {
    const avgResponseTime = requestMetrics.response_times.length > 0
      ? requestMetrics.response_times.reduce((a, b) => a + b, 0) / requestMetrics.response_times.length
      : 0;

    const recentErrors = requestMetrics.errors.filter(
      error => Date.now() - error.timestamp < 24 * 60 * 60 * 1000 // Last 24 hours
    );

    return {
      total_requests: requestMetrics.total_requests,
      total_tokens: requestMetrics.total_tokens,
      avg_response_time_ms: Math.round(avgResponseTime),
      requests_by_model: requestMetrics.requests_by_model,
      top_users: this.getTopUsers(),
      error_rate: requestMetrics.total_requests > 0 
        ? (recentErrors.length / requestMetrics.total_requests * 100).toFixed(2)
        : 0,
      recent_errors: recentErrors.slice(-10),
      uptime: process.uptime(),
      timestamp: new Date().toISOString()
    };
  }

  static getTopUsers(limit = 10) {
    return Object.entries(requestMetrics.requests_by_user)
      .sort(([,a], [,b]) => b - a)
      .slice(0, limit)
      .map(([userId, requests]) => ({ user_id: userId, requests }));
  }

  static getHealthStatus() {
    const metrics = this.getMetrics();
    const isHealthy = metrics.error_rate < 5 && metrics.avg_response_time_ms < 5000;
    
    return {
      status: isHealthy ? 'healthy' : 'unhealthy',
      uptime: process.uptime(),
      memory_usage: process.memoryUsage(),
      avg_response_time: metrics.avg_response_time_ms,
      error_rate: metrics.error_rate,
      total_requests: metrics.total_requests,
      timestamp: new Date().toISOString()
    };
  }
}

export const requestLoggingMiddleware = (req, res, next) => {
  const requestId = MonitoringService.generateRequestId();
  req.requestId = requestId;
  req.startTime = Date.now();

  logger.info('Incoming Request', {
    request_id: requestId,
    method: req.method,
    path: req.path,
    user_agent: req.get('User-Agent'),
    ip: req.ip,
    user_id: req.user?.id
  });

  next();
};

export default logger;
