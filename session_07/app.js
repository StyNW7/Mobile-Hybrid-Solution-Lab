const express = require('express');
const app = express();
const PORT = 3000;

/// Middleware (WAJIB untuk POST JSON)
app.use(express.json());

/// Import routes
const userRoutes = require('./routes/users');
const indexRoutes = require('./routes/index');

/// Base route
app.get('/', (req, res) => {
  res.send('🚀 Backend is running!');
});

/// Use routes
app.use('/api/users', userRoutes);
app.use('/api/test', indexRoutes);

/// Run server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});