// Simplified models endpoint for Vercel

const AVAILABLE_MODELS = [
  // 🌐 CLOUD MODELS (Always Online 24/7 via Groq)
  {
    id: "kimi",
    object: "model",
    created: 1699564800,
    owned_by: "Moonshot AI",
    active: true,
    context_window: 262144,
    public_apps: null,
    max_completion_tokens: 16384
  },
  {
    id: "qwen3",
    object: "model",
    created: 1699564800,
    owned_by: "Alibaba Cloud",
    active: true,
    context_window: 131072,
    public_apps: null,
    max_completion_tokens: 40960
  },
  {
    id: "llama-4",
    object: "model",
    created: 1699564800,
    owned_by: "Meta",
    active: true,
    context_window: 131072,
    public_apps: null,
    max_completion_tokens: 8192
  },
  {
    id: "gpt-oss",
    object: "model",
    created: 1699564800,
    owned_by: "OpenAI",
    active: true,
    context_window: 131072,
    public_apps: null,
    max_completion_tokens: 65536
  },
  {
    id: "gpt-oss-120b",
    object: "model",
    created: 1699564800,
    owned_by: "OpenAI",
    active: true,
    context_window: 131072,
    public_apps: null,
    max_completion_tokens: 65536
  },
  {
    id: "glm-4.5-air",
    object: "model",
    created: 1699564800,
    owned_by: "Zhipu AI",
    active: true,
    context_window: 131072,
    public_apps: null,
    max_completion_tokens: 8192
  },
  // 🏠 LOCAL MODELS (Privacy Mode - When Ollama Running)
  {
    id: "qwen3-local",
    object: "model",
    created: 1699564800,
    owned_by: "Alibaba Cloud",
    active: true,
    context_window: 8192,
    public_apps: null,
    max_completion_tokens: 8192
  },
  {
    id: "glm-4.6",
    object: "model",
    created: 1699564800,
    owned_by: "Zhipu AI",
    active: true,
    context_window: 8192,
    public_apps: null,
    max_completion_tokens: 8192
  }
];

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

  // Simple auth check
  const apiKey = req.headers['x-api-key'];
  if (!apiKey) {
    return res.status(401).json({
      error: {
        type: 'authentication_required',
        message: 'API key required'
      }
    });
  }

  try {
    return res.status(200).json({
      object: "list",
      data: AVAILABLE_MODELS
    });

  } catch (error) {
    console.error('Models API Error:', error);
    return res.status(500).json({
      error: {
        type: 'internal_server_error',
        message: 'Failed to retrieve models'
      }
    });
  }
}
