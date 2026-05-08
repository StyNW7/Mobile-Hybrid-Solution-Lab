const express = require('express');
const path = require('path');
const cors = require('cors');

const indexRouter = require('./routes/index');
const studentsRouter = require('./routes/students');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Static folder untuk akses uploaded image
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/', indexRouter);
app.use('/api/students', studentsRouter);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    message: 'Endpoint not found',
  });
});

// Error Handler
app.use((err, req, res, next) => {
  res.status(500).json({
    message: 'Internal server error',
    error: err.message,
  });
});

module.exports = app;