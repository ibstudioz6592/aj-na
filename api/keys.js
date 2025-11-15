// API Key Generation Endpoint - AJStudioz AI Platform
// Generates API keys with "aj" prefix like OpenAI format

// Simple in-memory storage for demo (use database in production)
const API_KEYS = new Map([
  ['aj-demo123456789abcdef', { id: 'demo-user', email: 'demo@ajstudioz.dev', plan: 'pro', created: Date.now(), usage: { requests_this_month: 0, tokens_this_month: 0 } }],
  ['aj-test987654321fedcba', { id: 'test-user', email: 'test@ajstudioz.dev', plan: 'free', created: Date.now(), usage: { requests_this_month: 0, tokens_this_month: 0 } }]
]);

function generateApiKey() {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).substring(2, 15);
  const random2 = Math.random().toString(36).substring(2, 15);
  return `aj-${timestamp}${random}${random2}`.substring(0, 32);
}

function authenticateRequest(req) {
  const apiKey = req.headers['x-api-key'] || req.headers['authorization']?.replace('Bearer ', '');
  if (!apiKey) return null;
  return API_KEYS.get(apiKey);
}

export default async function handler(req, res) {
  // Detect domain
  const host = req.headers.host || '';
  const isApiDomain = host.startsWith('api.') || host.includes('api.ajstudioz.dev');
  
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-API-Key, Authorization');
  res.setHeader('X-Domain-Type', isApiDomain ? 'api' : 'main');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  const user = authenticateRequest(req);
  
  if (req.method === 'GET') {
    // List API keys for authenticated user
    if (!user) {
      return res.status(401).json({
        error: {
          type: 'authentication_error',
          code: 'invalid_api_key',
          message: 'Authentication required'
        }
      });
    }

    const userKeys = Array.from(API_KEYS.entries())
      .filter(([key, data]) => data.id === user.id)
      .map(([key, data]) => ({
        id: key,
        name: `API Key ${key.substring(0, 8)}...`,
        created: data.created,
        last_used: data.last_used || null,
        scopes: ['api.chat', 'api.models', 'api.completions']
      }));

    return res.status(200).json({
      object: "list",
      data: userKeys,
      has_more: false,
      total_count: userKeys.length
    });
  }

  if (req.method === 'POST') {
    // Generate new API key
    const { name = 'Unnamed API Key', scopes = ['api.chat', 'api.models'] } = req.body;
    
    // For demo, allow anonymous key generation with email
    const { email, plan = 'free' } = req.body;
    
    if (!email) {
      return res.status(400).json({
        error: {
          type: 'invalid_request_error',
          code: 'missing_required_parameter',
          message: 'Email is required for API key generation'
        }
      });
    }

    const newApiKey = generateApiKey();
    const userId = `user_${Date.now().toString(36)}`;
    
    const keyData = {
      id: userId,
      email: email,
      plan: plan,
      created: Date.now(),
      last_used: null,
      usage: {
        requests_this_month: 0,
        tokens_this_month: 0
      },
      scopes: scopes,
      name: name
    };
    
    API_KEYS.set(newApiKey, keyData);
    
    return res.status(201).json({
      id: newApiKey,
      name: name,
      api_key: newApiKey,
      created: keyData.created,
      scopes: scopes,
      plan: plan,
      usage_limits: {
        requests_per_month: plan === 'pro' ? 100000 : 1000,
        tokens_per_month: plan === 'pro' ? 1000000 : 10000
      },
      message: "API key generated successfully. Store it securely - you won't be able to view it again.",
      warning: "Keep your API key secret. Do not share it with others or expose it in client-side code."
    });
  }

  if (req.method === 'DELETE') {
    // Delete API key
    if (!user) {
      return res.status(401).json({
        error: {
          type: 'authentication_error',
          code: 'invalid_api_key',
          message: 'Authentication required'
        }
      });
    }

    const { key_id } = req.query;
    
    if (!key_id || !API_KEYS.has(key_id)) {
      return res.status(404).json({
        error: {
          type: 'invalid_request_error',
          code: 'resource_not_found',
          message: 'API key not found'
        }
      });
    }

    const keyData = API_KEYS.get(key_id);
    if (keyData.id !== user.id) {
      return res.status(403).json({
        error: {
          type: 'permission_error',
          code: 'insufficient_permissions',
          message: 'You can only delete your own API keys'
        }
      });
    }

    API_KEYS.delete(key_id);
    
    return res.status(200).json({
      deleted: true,
      id: key_id,
      message: 'API key deleted successfully'
    });
  }

  return res.status(405).json({
    error: {
      type: 'invalid_request_error',
      code: 'method_not_allowed',
      message: 'Method not allowed'
    }
  });
}
