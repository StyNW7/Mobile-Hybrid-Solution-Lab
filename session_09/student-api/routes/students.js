const express = require('express');
const multer = require('multer');
const path = require('path');

const router = express.Router();

// Dummy database
let students = [
  {
    id: 1,
    name: 'Stanley',
    major: 'Computer Science',
    imageUrl: null,
  },
  {
    id: 2,
    name: 'Budi',
    major: 'Information Systems',
    imageUrl: null,
  },
];

// Middleware logger sederhana
const requestLogger = (req, res, next) => {
  console.log(`[${req.method}] ${req.originalUrl}`);
  next();
};

router.use(requestLogger);

// Multer storage config
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },

  filename: (req, file, cb) => {
    const uniqueName = Date.now() + '-' + file.originalname;
    cb(null, uniqueName);
  },
});

// File filter
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

// Simulasi Promise / async process
const getStudentsAsync = () => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(students);
    }, 500);
  });
};

// GET all students
router.get('/', async (req, res) => {
  const data = await getStudentsAsync();

  res.status(200).json({
    message: 'Students fetched successfully',
    data,
  });
});

// GET student by ID
router.get('/:id', (req, res) => {
  const id = Number(req.params.id);
  const student = students.find((item) => item.id === id);

  if (!student) {
    return res.status(404).json({
      message: 'Student not found',
    });
  }

  res.status(200).json({
    message: 'Student fetched successfully',
    data: student,
  });
});

// POST create student
router.post('/', (req, res) => {
  const { name, major } = req.body;

  if (!name || !major) {
    return res.status(400).json({
      message: 'Name and major are required',
    });
  }

  const newStudent = {
    id: students.length + 1,
    name,
    major,
    imageUrl: null,
  };

  students.push(newStudent);

  res.status(201).json({
    message: 'Student created successfully',
    data: newStudent,
  });
});

// POST upload student image
router.post('/:id/upload', upload.single('image'), (req, res) => {
  const id = Number(req.params.id);
  const student = students.find((item) => item.id === id);

  if (!student) {
    return res.status(404).json({
      message: 'Student not found',
    });
  }

  if (!req.file) {
    return res.status(400).json({
      message: 'Image file is required',
    });
  }

  student.imageUrl = `http://localhost:3000/uploads/${req.file.filename}`;

  res.status(200).json({
    message: 'Image uploaded successfully',
    data: student,
  });
});

module.exports = router;