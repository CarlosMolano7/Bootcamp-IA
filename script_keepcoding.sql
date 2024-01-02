-- Crear la tabla Student
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20)
);

ALTER TABLE student
ADD CONSTRAINT unique_email UNIQUE (email);

ALTER TABLE student
ALTER COLUMN email SET NOT NULL;

-- Crear la tabla Instructor
CREATE TABLE instructor (
    instructor_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    speciality VARCHAR(255)
);

ALTER TABLE instructor
ADD CONSTRAINT unique_email UNIQUE (email);

-- Crear la tabla Bootcamp
CREATE TABLE bootcamp (
    bootcamp_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    duration_month INT
);

-- Crear la tabla Subject
CREATE TABLE subject (
    subject_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    instructor_id INT,
    bootcamp_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
);

-- Crear la tabla Enrollment
CREATE TABLE enrollment (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    bootcamp_id INT,
    start_date DATE,
    end_date DATE,
    cost DECIMAL(10, 2),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
);

CREATE INDEX idx_start_date ON enrollment (start_date);

-- Crear la tabla Course
CREATE TABLE course (
    course_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    instructor_id INT,
    duration_weeks INT,
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
);

-- Crear la tabla std_course
CREATE TABLE std_course (
    std_course_id SERIAL PRIMARY KEY,
    course_id INT,
    student_id INT,
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    UNIQUE (course_id, student_id)
);


INSERT INTO student (name, surname, email, phone) VALUES
('Lucía', 'Recha', 'lucia.recha@email.com', '922-272393'),
('Carlos', 'Molano', 'carlos.molano@email.com', '964-558696'),
('Sofia', 'Hernández', 'sofia.hernandez@email.com', '937-880969'),
('Pedro', 'Ponce', 'pedro.ponce@email.com', '923-152431');


INSERT INTO instructor (name, surname, email, speciality) VALUES
('Carlos', 'García', 'carlos.garcia@email.com', 'Análisis de Datos'),
('Elena', 'Martínez', 'elena.martinez@email.com', 'Desarrollo web'),
('David', 'López', 'david.lopez@email.com', 'Programación en Python'),
('María', 'Pérez', 'maria.perez@email.com', 'UX/UI');


INSERT INTO bootcamp (name, duration_month, price) VALUES
('Inteligencia Artificial', 9, 7000),
('Big Data, Machine Learning & IA ', 9, 7000),
('Desarrollador Web', 7, 7000),
('Desarrollo de Apps Móviles', 6, 7000);


INSERT INTO subject (name, instructor_id, bootcamp_id) VALUES
('SQL', 1, 2),
('Deep Learning', 3, 1),
('Desarrollo de Páginas Web', 2, 3),
('Interfaz de Usuario', 4, 4);


INSERT INTO enrollment (student_id, bootcamp_id, cost, start_date, end_date) VALUES
(1, 1, 7000, DATE '2024-01-01', DATE '2024-09-30'),
(2, 2, 7000, DATE '2024-01-01', DATE '2024-09-03'),
(3, 3, 7000, DATE '2024-01-01', DATE '2024-07-31'),
(4, 4, 7000, DATE '2024-01-01', DATE '2024-06-30');


INSERT INTO course (name, instructor_id, duration_weeks) VALUES
('Programación Básica', 3, 5),
('Bases de Datos', 1, 6),
('Álgebra', 2, 4),
('Curso de ML', 4, 3);


INSERT INTO std_course (course_id, student_id) VALUES
(1, 4),
(2, 3),
(3, 2),
(4, 1);

