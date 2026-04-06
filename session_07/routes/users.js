const express = require('express');
const router = express.Router();

/// Dummy database (array)
let users = [
  { id: 1, name: "Stanley", age: 20 },
  { id: 2, name: "Budi", age: 22 }
];

/// ================= GET =================
/// Get all users
router.get('/', (req, res) => {
  res.json({
    message: "Get all users",
    data: users
  });
});

/// Get user by ID
router.get('/:id', (req, res) => {
  const id = parseInt(req.params.id);

  const user = users.find(u => u.id === id);

  if (!user) {
    return res.status(404).json({
      message: "User not found"
    });
  }

  res.json({
    message: "Get user by ID",
    data: user
  });
});

/// ================= POST =================
/// Add new user
router.post('/', (req, res) => {
  const { name, age } = req.body;

  if (!name || !age) {
    return res.status(400).json({
      message: "Name and age are required"
    });
  }

  const newUser = {
    id: users.length + 1,
    name,
    age
  };

  users.push(newUser);

  res.status(201).json({
    message: "User created successfully",
    data: newUser
  });
});

module.exports = router;