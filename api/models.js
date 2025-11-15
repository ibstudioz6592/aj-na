// Simplified models endpoint for Vercel

const AVAILABLE_MODELS = [
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
    description: "GLM-4.6 is a powerful conversational AI model with strong general capabilities",
    max_tokens: 8192,
    pricing: {
      input_tokens: 0.001,  // $0.001 per 1K input tokens
      output_tokens: 0.002  // $0.002 per 1K output tokens
    },
    features: ["chat", "completion", "reasoning"],
    languages: ["en", "zh", "multilingual"],
    capabilities: {
      reasoning: "high",
      coding: "high", 
      math: "high",
      creative_writing: "high",
      analysis: "high"
    }
  },
  {
    id: "qwen3",
    object: "model",
    created: 1699564800,
    owned_by: "alibaba-cloud",
    permission: [
      {
        id: "modelperm-qwen3",
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
    description: "Qwen 3 is a fast and efficient language model optimized for chat and reasoning tasks",
    max_tokens: 8192,
    pricing: {
      input_tokens: 0.0002,  // $0.0002 per 1K input tokens
      output_tokens: 0.0006  // $0.0006 per 1K output tokens
    },
    features: ["chat", "completion", "reasoning", "fast-inference"],
    languages: ["en", "zh", "multilingual"],
    capabilities: {
      reasoning: "high",
      coding: "high",
      math: "high",
      creative_writing: "high",
      analysis: "high",
      speed: "very_high"
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
    return res.status(200).json({
      object: "list",
      data: AVAILABLE_MODELS,
      has_more: false,
      total_count: AVAILABLE_MODELS.length,
      metadata: {
        timestamp: new Date().toISOString()
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
