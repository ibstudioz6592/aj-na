// Simplified auth endpoint for Vercel demo

// Demo users database
const demoUsers = new Map([
  ['demo@example.com', { id: 'demo-user', email: 'demo@example.com', plan: 'pro', api_key: 'ak-demo123456789' }],
  ['test@example.com', { id: 'test-user', email: 'test@example.com', plan: 'free', api_key: 'ak-test123456789' }]
]);

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  if (req.method !== 'POST') {
    return res.status(405).json({
      error: {
        type: 'method_not_allowed',
        message: 'Only POST method is allowed'
      }
    });
  }

  const { action } = req.query;

  try {
    if (action === 'register') {
      const { email, name, plan = 'free' } = req.body;
      
      if (!email || !name) {
        return res.status(400).json({
          error: {
            type: 'validation_error',
            message: 'Email and name are required'
          }
        });
      }

      // Generate demo API key
      const apiKey = `ak-${Math.random().toString(36).substr(2, 32)}`;
      
      return res.status(201).json({
        user: {
          id: `user_${Date.now()}`,
          email,
          plan,
          created_at: new Date().toISOString(),
          usage: {
            requests_this_month: 0,
            tokens_this_month: 0
          },
          limits: {
            requests_per_minute: plan === 'free' ? 20 : plan === 'pro' ? 100 : 500,
            requests_per_month: plan === 'free' ? 1000 : plan === 'pro' ? 10000 : 100000,
            tokens_per_month: plan === 'free' ? 50000 : plan === 'pro' ? 500000 : 5000000
          }
        },
        api_key: apiKey,
        message: 'Demo account created successfully (Note: This is a demo - keys are temporary)'
      });

    } else if (action === 'login') {
      const { email } = req.body;
      
      if (!email) {
        return res.status(400).json({
          error: {
            type: 'validation_error',
            message: 'Email is required'
          }
        });
      }

      const user = demoUsers.get(email);
      
      if (!user) {
        return res.status(401).json({
          error: {
            type: 'authentication_failed',
            message: 'Demo user not found. Try demo@example.com or test@example.com'
          }
        });
      }
      
      return res.status(200).json({
        user: {
          id: user.id,
          email: user.email,
          plan: user.plan,
          usage: {
            requests_this_month: 847,
            tokens_this_month: 94500
          },
          limits: {
            requests_per_minute: user.plan === 'free' ? 20 : 100,
            requests_per_month: user.plan === 'free' ? 1000 : 10000,
            tokens_per_month: user.plan === 'free' ? 50000 : 500000
          }
        },
        api_key: user.api_key,
        message: 'Demo login successful'
      });

    } else if (action === 'refresh-key') {
      const newApiKey = `ak-${Math.random().toString(36).substr(2, 32)}`;
      
      return res.status(200).json({
        api_key: newApiKey,
        message: 'Demo API key refreshed successfully'
      });

    } else {
      return res.status(400).json({
        error: {
          type: 'invalid_action',
          message: 'Valid actions are: register, login, refresh-key'
        }
      });
    }

  } catch (error) {
    console.error('Auth Error:', error);
    return res.status(500).json({
      error: {
        type: 'internal_server_error',
        message: 'An error occurred processing your request'
      }
    });
  }
}
