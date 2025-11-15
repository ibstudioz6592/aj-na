import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import cors from 'cors';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.static('public'));

// API endpoints - dynamically import from api/ directory
app.use('/api/chat', async (req, res, next) => {
    try {
        const { default: chatHandler } = await import('./api/chat.js');
        await chatHandler(req, res);
    } catch (error) {
        console.error('Chat API error:', error);
        res.status(500).json({ error: { message: 'Internal server error' } });
    }
});

app.use('/api/models', async (req, res, next) => {
    try {
        const { default: modelsHandler } = await import('./api/models.js');
        await modelsHandler(req, res);
    } catch (error) {
        console.error('Models API error:', error);
        res.status(500).json({ error: { message: 'Internal server error' } });
    }
});

// Serve static files
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/chat', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'chatbot.html'));
});

app.get('/chatbot.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'chatbot.html'));
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// Proxy to Ollama for direct API calls
app.use('/ollama', (req, res) => {
    const options = {
        hostname: 'localhost',
        port: 11434,
        path: req.url,
        method: req.method,
        headers: {
            'Content-Type': 'application/json'
        }
    };

    const proxyReq = http.request(options, (proxyRes) => {
        res.writeHead(proxyRes.statusCode, proxyRes.headers);
        proxyRes.pipe(res);
    });

    proxyReq.on('error', (err) => {
        res.status(500).json({ error: err.message });
    });

    if (req.body) {
        proxyReq.write(JSON.stringify(req.body));
    }
    proxyReq.end();
});

const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
    console.log(`🚀 AJ MEOW Server running on port ${PORT}`);
    console.log(`📱 Chatbot: http://localhost:${PORT}/chat`);
    console.log(`🔗 API: http://localhost:${PORT}/api/chat`);
    console.log(`📊 Models: http://localhost:${PORT}/api/models`);
    console.log(`💚 Health: http://localhost:${PORT}/health`);
});
