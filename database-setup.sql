-- Research Repository Database Setup
-- Execute this script in MySQL to set up the database

-- Create database
CREATE DATABASE IF NOT EXISTS research_repo CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE research_repo;

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS papers;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    user_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'faculty', 'admin') DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- Create papers table
CREATE TABLE papers (
    paper_id INT(11) AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    abstract TEXT,
    file_path VARCHAR(200),
    submitted_by INT(11),
    status ENUM('submitted', 'under review', 'accepted', 'rejected') DEFAULT 'submitted',
    submission_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_status (status),
    INDEX idx_submitted_by (submitted_by),
    INDEX idx_submission_date (submission_date)
);

-- Insert sample users for testing
INSERT INTO users (name, email, password, role) VALUES
('Student Demo', 'student@test.com', 'password', 'student'),
('Faculty Demo', 'faculty@test.com', 'password', 'faculty'),
('Admin User', 'admin@test.com', 'password', 'admin'),
('John Doe', 'john.student@university.edu', 'password123', 'student'),
('Dr. Jane Smith', 'jane.smith@university.edu', 'password123', 'faculty'),
('Dr. Michael Brown', 'michael.brown@university.edu', 'password123', 'faculty'),
('Alice Johnson', 'alice.johnson@university.edu', 'password123', 'student'),
('Bob Wilson', 'bob.wilson@university.edu', 'password123', 'student');

-- Insert sample papers for testing
INSERT INTO papers (title, abstract, file_path, submitted_by, status, submission_date) VALUES
(
    'Machine Learning Applications in Healthcare Data Analysis',
    'This paper presents a comprehensive analysis of machine learning techniques applied to healthcare data. We explore various algorithms including neural networks, decision trees, and ensemble methods for predicting patient outcomes. Our research demonstrates significant improvements in diagnostic accuracy when compared to traditional statistical methods.',
    'uploads/ml_healthcare_2024.pdf',
    1,
    'accepted',
    '2024-01-15'
),
(
    'Blockchain Technology for Secure Data Management',
    'An investigation into the potential of blockchain technology for securing sensitive data in distributed systems. This research evaluates the performance, scalability, and security aspects of various blockchain implementations. We propose a novel consensus mechanism that reduces energy consumption while maintaining security.',
    'uploads/blockchain_security_2024.pdf',
    4,
    'under review',
    '2024-02-20'
),
(
    'Artificial Intelligence Ethics: A Framework for Responsible AI Development',
    'This study addresses the growing concerns about AI ethics and proposes a comprehensive framework for responsible AI development. We analyze current ethical challenges in AI systems and provide guidelines for developers and policymakers to ensure AI technologies benefit society while minimizing potential harms.',
    'uploads/ai_ethics_framework_2024.pdf',
    7,
    'submitted',
    '2024-03-10'
),
(
    'Quantum Computing Algorithms for Optimization Problems',
    'We present novel quantum algorithms for solving complex optimization problems that are computationally intensive for classical computers. Our research includes theoretical analysis and experimental results using quantum simulators. The findings suggest significant speedup for certain classes of optimization problems.',
    'uploads/quantum_optimization_2024.pdf',
    8,
    'submitted',
    '2024-03-22'
),
(
    'Internet of Things (IoT) Security: Challenges and Solutions',
    'This paper examines security vulnerabilities in IoT devices and networks. We conduct a systematic analysis of current security threats and propose a multi-layered security architecture. Our solution includes lightweight encryption protocols suitable for resource-constrained IoT devices.',
    'uploads/iot_security_2024.pdf',
    4,
    'accepted',
    '2024-02-05'
),
(
    'Deep Learning for Natural Language Processing: A Comparative Study',
    'A comprehensive comparison of deep learning architectures for natural language processing tasks. We evaluate transformer models, recurrent neural networks, and convolutional neural networks across various NLP benchmarks. Our results provide insights into the most effective approaches for different types of language tasks.',
    'uploads/deep_learning_nlp_2024.pdf',
    1,
    'rejected',
    '2024-01-28'
);

-- Create indexes for better performance
CREATE INDEX idx_papers_title ON papers(title);
CREATE INDEX idx_papers_created_at ON papers(created_at);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Show created tables
SHOW TABLES;

-- Display sample data
SELECT 'Users Table:' as Table_Info;
SELECT user_id, name, email, role, created_at FROM users;

SELECT 'Papers Table:' as Table_Info;
SELECT paper_id, title, status, submitted_by, submission_date FROM papers;

-- Show table structures
DESCRIBE users;
DESCRIBE papers;

-- Show some statistics
SELECT
    'Database Statistics' as Info,
    (SELECT COUNT(*) FROM users) as Total_Users,
    (SELECT COUNT(*) FROM users WHERE role = 'student') as Students,
    (SELECT COUNT(*) FROM users WHERE role = 'faculty') as Faculty,
    (SELECT COUNT(*) FROM papers) as Total_Papers,
    (SELECT COUNT(*) FROM papers WHERE status = 'submitted') as Submitted_Papers,
    (SELECT COUNT(*) FROM papers WHERE status = 'accepted') as Accepted_Papers;
