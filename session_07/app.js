const express = require('express');
const app = express();
const PORT = 3000;

/// Middleware (WAJIB untuk POST JSON)
app.use(express.json());

/// Import routes
const userRoutes = require('./routes/users');

/// Base route
app.get('/', (req, res) => {
  res.send('🚀 Backend is running!');
});

/// Use routes
app.use('/api/users', userRoutes);

/// Run server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});