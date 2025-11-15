// Simplified dashboard for Vercel deployment
const systemMetrics = {
  total_requests: 1250,
  total_tokens: 125000,
  uptime: process.uptime(),
  memory_usage: process.memoryUsage(),
  avg_response_time: 850,
  error_rate: 2.1,
  status: 'healthy'
};

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-API-Key');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  if (req.method !== 'GET') {
    return res.status(405).json({
      error: {
        type: 'method_not_allowed',
        message: 'Only GET method is allowed'
      }
    });
  }

  const { endpoint } = req.query;

  try {
    if (endpoint === 'health') {
      // Public health check - no auth required
      const health = {
        status: systemMetrics.status,
        uptime: systemMetrics.uptime,
        memory_usage: systemMetrics.memory_usage,
        avg_response_time: systemMetrics.avg_response_time,
        error_rate: systemMetrics.error_rate,
        timestamp: new Date().toISOString()
      };
      return res.status(200).json(health);
    }

    // Simplified auth check
    const apiKey = req.headers['x-api-key'];
    if (!apiKey && endpoint !== 'health') {
      return res.status(401).json({
        error: {
          type: 'authentication_required',
          message: 'API key required for this endpoint'
        }
      });
    }
    
    if (endpoint === 'metrics') {
      return res.status(200).json(systemMetrics);
    }

    if (endpoint === 'usage') {
      // Demo user statistics
      const userStats = {
        user_id: 'demo-user',
        plan: 'pro',
        usage: {
          requests_this_month: 847,
          tokens_this_month: 94500
        },
        limits: {
          requests_per_month: 10000,
          tokens_per_month: 500000
        },
        usage_percentage: {
          requests: '8.5',
          tokens: '18.9'
        },
        next_reset: getNextMonthReset()
      };
      return res.status(200).json(userStats);
    }

    if (endpoint === 'billing') {
      const billing = {
        plan: 'pro',
        current_cost: 14.75,
        estimated_monthly: 29.00,
        usage_breakdown: {
          glm_4_6: { requests: 450, cost: 8.50 },
          deepseek_r1: { requests: 397, cost: 6.25 }
        }
      };
      return res.status(200).json(billing);
    }

    return res.status(404).json({
      error: {
        type: 'endpoint_not_found',
        message: 'Available endpoints: health, metrics (admin), usage, billing'
      }
    });

  } catch (error) {
    console.error('Dashboard Error:', error);
    return res.status(500).json({
      error: {
        type: 'internal_server_error',
        message: 'Failed to retrieve dashboard data'
      }
    });
  }
}

function getNextMonthReset() {
  const now = new Date();
  const nextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);
  return nextMonth.toISOString();
}

function calculateBilling(user) {
  const pricing = {
    'glm-4.6': { input: 0.001, output: 0.002 },
    'deepseek-r1': { input: 0.0005, output: 0.0015, reasoning: 0.001 }
  };

  // Simplified billing calculation
  const estimatedCost = user.usage.tokens_this_month * 0.0015; // Average cost per token

  return {
    user_id: user.id,
    plan: user.plan,
    billing_period: {
      start: new Date(user.usage.last_reset).toISOString(),
      end: getNextMonthReset()
    },
    usage: {
      total_requests: user.usage.requests_this_month,
      total_tokens: user.usage.tokens_this_month,
      estimated_cost_usd: parseFloat(estimatedCost.toFixed(4))
    },
    plan_limits: user.limits,
    overage: {
      requests: Math.max(0, user.usage.requests_this_month - user.limits.requests_per_month),
      tokens: Math.max(0, user.usage.tokens_this_month - user.limits.tokens_per_month)
    }
  };
}
