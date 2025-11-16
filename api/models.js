// Simplified models endpoint for Vercel

const AVAILABLE_MODELS = [
  // 🌐 CLOUD MODELS (Always Online 24/7 via Groq)
  {
    id: "kimi",
    object: "model",
    created: 1699564800,
    owned_by: "moonshot-ai",
    permission: [
      {
        id: "modelperm-kimi",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "kimi",
    parent: null,
    description: "Kimi K2 Instruct - Advanced conversational AI with superior instruction following (moonshotai/kimi-k2-instruct-0905)",
    max_tokens: 8192,
    deployment: "cloud",
    always_online: true,
    provider: "groq",
    groq_model: "moonshotai/kimi-k2-instruct-0905",
    pricing: {
      input_tokens: 0.0005,
      output_tokens: 0.001
    },
    features: ["chat", "completion", "instruction-following", "multilingual"],
    languages: ["en", "zh", "ja", "multilingual"],
    capabilities: {
      reasoning: "very_high",
      coding: "high", 
      math: "high",
      creative_writing: "very_high",
      analysis: "very_high",
      instruction_following: "excellent"
    }
  },
  {
    id: "qwen3",
    object: "model",
    created: 1699564800,
    owned_by: "alibaba-cloud",
    permission: [
      {
        id: "modelperm-qwen3-32b",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "qwen3",
    parent: null,
    description: "Qwen 3 32B - Powerful 32-billion parameter model for advanced reasoning and problem solving (qwen/qwen3-32b)",
    max_tokens: 8192,
    deployment: "cloud",
    always_online: true,
    provider: "groq",
    groq_model: "qwen/qwen3-32b",
    pricing: {
      input_tokens: 0.0003,
      output_tokens: 0.0008
    },
    features: ["chat", "completion", "reasoning", "problem-solving"],
    languages: ["en", "zh", "multilingual"],
    capabilities: {
      reasoning: "excellent",
      coding: "excellent",
      math: "excellent",
      creative_writing: "high",
      analysis: "excellent",
      speed: "high"
    }
  },
  {
    id: "llama-4",
    object: "model",
    created: 1699564800,
    owned_by: "meta",
    permission: [
      {
        id: "modelperm-llama4",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "llama-4",
    parent: null,
    description: "Llama 4 Maverick 17B - Advanced model with 128K context window for long-form content (meta-llama/llama-4-maverick-17b-128e-instruct)",
    max_tokens: 128000,
    deployment: "cloud",
    always_online: true,
    provider: "groq",
    groq_model: "meta-llama/llama-4-maverick-17b-128e-instruct",
    pricing: {
      input_tokens: 0.0004,
      output_tokens: 0.001
    },
    features: ["chat", "completion", "long-context", "instruction-following"],
    languages: ["en", "multilingual"],
    capabilities: {
      reasoning: "excellent",
      coding: "very_high",
      math: "very_high",
      creative_writing: "excellent",
      analysis: "excellent",
      long_context: "excellent"
    }
  },
  {
    id: "gpt-oss",
    object: "model",
    created: 1699564800,
    owned_by: "openai-oss",
    permission: [
      {
        id: "modelperm-gptoss",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "gpt-oss",
    parent: null,
    description: "GPT OSS 20B - Open-source optimized model with 20 billion parameters (openai/gpt-oss-20b)",
    max_tokens: 8192,
    deployment: "cloud",
    always_online: true,
    provider: "groq",
    groq_model: "openai/gpt-oss-20b",
    pricing: {
      input_tokens: 0.0002,
      output_tokens: 0.0005
    },
    features: ["chat", "completion", "open-source", "optimized"],
    languages: ["en", "multilingual"],
    capabilities: {
      reasoning: "high",
      coding: "high",
      math: "high",
      creative_writing: "high",
      analysis: "high",
      optimization: "excellent"
    }
  },
  // 🏠 LOCAL MODELS (Privacy Mode - When Ollama Running)
  {
    id: "qwen3-local",
    object: "model",
    created: 1699564800,
    owned_by: "alibaba-cloud",
    permission: [
      {
        id: "modelperm-qwen3local",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "qwen3-local",
    parent: null,
    description: "Qwen 3:1.7B - Fast local model for privacy-focused chat and reasoning (qwen3:1.7b)",
    max_tokens: 8192,
    deployment: "local",
    always_online: false,
    provider: "ollama",
    ollama_model: "qwen3:1.7b",
    pricing: {
      input_tokens: 0,
      output_tokens: 0
    },
    features: ["chat", "completion", "reasoning", "privacy", "fast-inference"],
    languages: ["en", "zh", "multilingual"],
    capabilities: {
      reasoning: "high",
      coding: "high",
      math: "high",
      creative_writing: "high",
      analysis: "high",
      speed: "very_high",
      privacy: "maximum"
    }
  },
  {
    id: "glm-4.6",
    object: "model",
    created: 1699564800,
    owned_by: "zhipu-ai",
    permission: [
      {
        id: "modelperm-glm46",
        object: "model_permission",
        created: 1699564800,
        allow_create_engine: false,
        allow_sampling: true,
        allow_logprobs: false,
        allow_search_indices: false,
        allow_view: true,
        allow_fine_tuning: false,
        organization: "*",
        group: null,
        is_blocking: false
      }
    ],
    root: "glm-4.6",
    parent: null,
    description: "GLM-4.6:Cloud - Powerful local conversational AI model with strong general capabilities (glm-4.6:cloud)",
    max_tokens: 8192,
    deployment: "local",
    always_online: false,
    provider: "ollama",
    ollama_model: "glm-4.6:cloud",
    pricing: {
      input_tokens: 0,
      output_tokens: 0
    },
    features: ["chat", "completion", "reasoning", "privacy"],
    languages: ["en", "zh", "multilingual"],
    capabilities: {
      reasoning: "very_high",
      coding: "very_high", 
      math: "very_high",
      creative_writing: "very_high",
      analysis: "very_high",
      privacy: "maximum"
    }
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
    const cloudModels = AVAILABLE_MODELS.filter(m => m.deployment === 'cloud');
    const localModels = AVAILABLE_MODELS.filter(m => m.deployment === 'local');
    
    return res.status(200).json({
      object: "list",
      data: AVAILABLE_MODELS,
      has_more: false,
      total_count: AVAILABLE_MODELS.length,
      metadata: {
        timestamp: new Date().toISOString(),
        deployment_info: {
          cloud_models: {
            count: cloudModels.length,
            always_online: true,
            provider: "groq",
            endpoint: "api.ajstudioz.dev",
            models: cloudModels.map(m => ({ id: m.id, groq_model: m.groq_model }))
          },
          local_models: {
            count: localModels.length,
            always_online: false,
            provider: "ollama",
            endpoint: "local-api.ajstudioz.dev",
            models: localModels.map(m => ({ id: m.id, ollama_model: m.ollama_model }))
          },
          multi_key_protection: true,
          groq_keys_available: 5,
          enterprise_features: ["rate_limiting", "usage_analytics", "multi_key_rotation", "global_edge_deployment"]
        }
      }
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
