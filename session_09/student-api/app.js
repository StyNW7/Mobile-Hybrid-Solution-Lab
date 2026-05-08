const express = require('express');
const path = require('path');
const cors = require('cors');

const indexRouter = require('./routes/index');
const studentsRouter = require('./routes/students');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use('/', indexRouter);
app.use('/api/students', studentsRouter);

app.use((req, res) => {
  res.status(404).json({
    message: 'Endpoint not found',
  });
});

app.use((err, req, res, next) => {
  res.status(500).json({
    message: 'Internal server error',
    error: err.message,
  });
});

module.exports = app;