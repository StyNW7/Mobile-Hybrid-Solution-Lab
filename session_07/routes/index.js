const express = require('express');
const router = express.Router();

/* GET home page. */
// router.get('/', function(req, res, next) {
//   res.render('index', { title: 'Express' });
// });

router.get('/', (req, res) => {
  res.send('Test Page');
});

// router.get('/', (req, res) => {
//   res.json({
//     message: "Get all users",
//     data: [1, 2, 3, 4, 5]
//   });
// });

module.exports = router;