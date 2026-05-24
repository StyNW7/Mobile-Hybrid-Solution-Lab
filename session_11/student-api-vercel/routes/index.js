const express = require('express');

const router = express.Router();

router.get('/', (req, res) => {
  res.status(200).json({
    message: 'Student API is running on Vercel',
  });
});

module.exports = router;