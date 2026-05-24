require('dotenv').config();

const express = require('express');
const cors = require('cors');

const indexRouter = require('./routes/index');
const studentsRouter = require('./routes/students');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Routes
app.use('/', indexRouter);
app.use('/api/students', studentsRouter);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    message: 'Endpoint not found',
  });
});

// Error handler
app.use((err, req, res, next) => {
  res.status(500).json({
    message: 'Internal server error',
    error: err.message,
  });
});

module.exports = app;