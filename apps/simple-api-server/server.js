const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'simple-api-server'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Simple API Server',
    version: '1.0.0',
    endpoints: [
      'GET /',
      'GET /health',
      'GET /api/info',
      'GET /api/echo',
      'POST /api/echo'
    ]
  });
});

// API info endpoint
app.get('/api/info', (req, res) => {
  res.json({
    name: 'Simple API Server',
    version: '1.0.0',
    hostname: process.env.HOSTNAME || 'unknown',
    environment: process.env.NODE_ENV || 'development',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Echo endpoint (GET and POST)
app.get('/api/echo', (req, res) => {
  res.json({
    method: 'GET',
    query: req.query,
    headers: req.headers,
    timestamp: new Date().toISOString()
  });
});

app.post('/api/echo', (req, res) => {
  res.json({
    method: 'POST',
    body: req.body,
    query: req.query,
    headers: req.headers,
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`Simple API Server listening on port ${port}`);
  console.log(`Health check: http://0.0.0.0:${port}/health`);
});

