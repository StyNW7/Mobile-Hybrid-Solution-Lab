CREATE DATABASE student_api_db;

USE student_api_db;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  major VARCHAR(100) NOT NULL,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO students (name, major, image_url) VALUES
('Stanley', 'Computer Science', NULL),
('Budi', 'Information Systems', NULL);