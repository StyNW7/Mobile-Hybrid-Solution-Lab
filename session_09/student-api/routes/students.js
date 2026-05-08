const express = require('express');
const multer = require('multer');
const db = require('../db');

const router = express.Router();

const requestLogger = (req, res, next) => {
  console.log(`[${req.method}] ${req.originalUrl}`);
  next();
};

router.use(requestLogger);

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];

  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Only JPG, JPEG, and PNG files are allowed'), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
});

// GET all students
router.get('/', async (req, res, next) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM students ORDER BY id DESC'
    );

    res.status(200).json({
      message: 'Students fetched successfully',
      data: rows,
    });
  } catch (error) {
    next(error);
  }
});

// GET student by ID
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    const [rows] = await db.query(
      'SELECT * FROM students WHERE id = ?',
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: 'Student not found',
      });
    }

    res.status(200).json({
      message: 'Student fetched successfully',
      data: rows[0],
    });
  } catch (error) {
    next(error);
  }
});

// POST create student
router.post('/', async (req, res, next) => {
  try {
    const { name, major } = req.body;

    if (!name || !major) {
      return res.status(400).json({
        message: 'Name and major are required',
      });
    }

    const [result] = await db.query(
      'INSERT INTO students (name, major) VALUES (?, ?)',
      [name, major]
    );

    const [newStudent] = await db.query(
      'SELECT * FROM students WHERE id = ?',
      [result.insertId]
    );

    res.status(201).json({
      message: 'Student created successfully',
      data: newStudent[0],
    });
  } catch (error) {
    next(error);
  }
});

// POST upload image
router.post('/:id/upload', upload.single('image'), async (req, res, next) => {
  try {
    const { id } = req.params;

    const [students] = await db.query(
      'SELECT * FROM students WHERE id = ?',
      [id]
    );

    if (students.length === 0) {
      return res.status(404).json({
        message: 'Student not found',
      });
    }

    if (!req.file) {
      return res.status(400).json({
        message: 'Image file is required',
      });
    }

    const imageUrl = `http://localhost:3000/uploads/${req.file.filename}`;

    await db.query(
      'UPDATE students SET image_url = ? WHERE id = ?',
      [imageUrl, id]
    );

    const [updatedStudent] = await db.query(
      'SELECT * FROM students WHERE id = ?',
      [id]
    );

    res.status(200).json({
      message: 'Image uploaded successfully',
      data: updatedStudent[0],
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;