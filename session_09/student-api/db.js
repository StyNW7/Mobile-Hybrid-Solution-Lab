const mysql = require('mysql2/promise');

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'student_api_db',
  waitForConnections: true,
  connectionLimit: 10,
});

module.exports = db;