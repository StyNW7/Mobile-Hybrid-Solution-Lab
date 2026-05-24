const express = require('express');
const multer = require('multer');
const pool = require('../config/db');
const logger = require('../middleware/logger');

const router = express.Router();

router.use(logger);

// Vercel serverless tidak cocok untuk menyimpan file lokal permanen.
// Jadi untuk demo lab, kita pakai memoryStorage.
// File diterima oleh Multer, lalu metadata file disimpan ke database.
const upload = multer({
  storage: multer.memoryStorage(),
});

// GET all students
router.get('/', async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT * FROM students ORDER BY id DESC'
    );

    res.status(200).json({
      message: 'Students fetched successfully',
      data: result.rows,
    });
  } catch (error) {
    next(error);
  }
});

// GET student by ID
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'SELECT * FROM students WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Student not found',
      });
    }

    res.status(200).json({
      message: 'Student fetched successfully',
      data: result.rows[0],
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

    const result = await pool.query(
      `INSERT INTO students (name, major)
       VALUES ($1, $2)
       RETURNING *`,
      [name, major]
    );

    res.status(201).json({
      message: 'Student created successfully',
      data: result.rows[0],
    });
  } catch (error) {
    next(error);
  }
});

// POST upload image
router.post('/:id/upload', upload.single('image'), async (req, res, next) => {
  try {
    const { id } = req.params;

    const studentResult = await pool.query(
      'SELECT * FROM students WHERE id = $1',
      [id]
    );

    if (studentResult.rows.length === 0) {
      return res.status(404).json({
        message: 'Student not found',
      });
    }

    if (!req.file) {
      return res.status(400).json({
        message: 'Image file is required',
      });
    }

    // Demo version:
    // Vercel tidak menyimpan file permanen.
    // Jadi image_url diisi metadata nama file.
    // Production ideal: upload ke Supabase Storage / Cloudinary.
    const imageUrl = `Uploaded file: ${req.file.originalname}`;

    const updateResult = await pool.query(
      `UPDATE students
       SET image_url = $1
       WHERE id = $2
       RETURNING *`,
      [imageUrl, id]
    );

    res.status(200).json({
      message: 'Image received successfully',
      file: {
        originalName: req.file.originalname,
        mimeType: req.file.mimetype,
        size: req.file.size,
      },
      data: updateResult.rows[0],
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;