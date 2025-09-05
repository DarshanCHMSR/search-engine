const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Security middleware
app.use(helmet());

// CORS configuration
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: {
    error: 'Too many requests from this IP, please try again later.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/api/', limiter);

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(cookieParser());

// Logging middleware
app.use(morgan('combined'));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'Golligog Server',
    version: '1.0.0',
    database: 'Not connected (demo mode)'
  });
});

// Demo authentication endpoints (without database)
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  // Demo credentials
  if (email === 'demo@golligog.com' && password === 'demo123') {
    const token = 'demo_jwt_token_123456789';
    res.json({
      success: true,
      message: 'Login successful (demo mode)',
      data: {
        user: {
          id: 'demo-user-id',
          email: 'demo@golligog.com',
          username: 'demo_user',
          firstName: 'Demo',
          lastName: 'User'
        },
        token
      }
    });
  } else {
    res.status(401).json({
      success: false,
      message: 'Invalid credentials. Try demo@golligog.com / demo123'
    });
  }
});

app.post('/api/auth/register', (req, res) => {
  const { firstName, lastName, username, email, password } = req.body;
  
  // Basic validation
  if (!firstName || !lastName || !username || !email || !password) {
    return res.status(400).json({
      success: false,
      message: 'All fields are required'
    });
  }
  
  if (password.length < 6) {
    return res.status(400).json({
      success: false,
      message: 'Password must be at least 6 characters'
    });
  }
  
  const token = 'demo_jwt_token_123456789';
  res.status(201).json({
    success: true,
    message: 'Account created successfully (demo mode)',
    data: {
      user: {
        id: 'new-user-id',
        email,
        username,
        firstName,
        lastName
      },
      token
    }
  });
});

app.post('/api/auth/logout', (req, res) => {
  res.json({
    success: true,
    message: 'Logout successful'
  });
});

app.get('/api/auth/me', (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: 'No token provided'
    });
  }
  
  res.json({
    success: true,
    data: {
      user: {
        id: 'demo-user-id',
        email: 'demo@golligog.com',
        username: 'demo_user',
        firstName: 'Demo',
        lastName: 'User',
        isActive: true,
        isVerified: true
      }
    }
  });
});

// Demo user endpoints
app.get('/api/user/profile', (req, res) => {
  res.json({
    success: true,
    data: {
      user: {
        id: 'demo-user-id',
        email: 'demo@golligog.com',
        username: 'demo_user',
        firstName: 'Demo',
        lastName: 'User',
        profilePicture: null,
        preferences: {
          searchEngine: 'searxng',
          resultsPerPage: 10,
          safeSearch: true,
          theme: 'light'
        }
      }
    }
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error'
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`🚀 Golligog Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⚠️  Running in demo mode (no database connection)`);
  console.log(`🔑 Demo credentials: demo@golligog.com / demo123`);
});

module.exports = app;
