-- Sample data for Event Management System

-- Insert sample rooms
INSERT INTO rooms (room_name, capacity, building, floor) VALUES
('Grand Ballroom', 500, 'Main Building', 1),
('Conference Room A', 100, 'Main Building', 2),
('Conference Room B', 100, 'Main Building', 2),
('Workshop Room 1', 50, 'East Wing', 1),
('Workshop Room 2', 50, 'East Wing', 1);

-- Insert sample speakers
INSERT INTO speakers (first_name, last_name, bio, email, company, title) VALUES
('John', 'Smith', 'AI researcher with 15 years experience', 'john.smith@example.com', 'Tech Corp', 'Chief AI Scientist'),
('Sarah', 'Johnson', 'Machine Learning expert and author', 'sarah.j@example.com', 'AI Solutions', 'Director of Research'),
('Michael', 'Chen', 'Data Science pioneer', 'mchen@example.com', 'Data Insights', 'Principal Data Scientist'),
('Emily', 'Brown', 'Neural Networks specialist', 'emily.b@example.com', 'Neural Tech', 'Lead Engineer'),
('David', 'Wilson', 'Cloud Computing expert', 'david.w@example.com', 'Cloud Systems', 'Solutions Architect');

-- Insert sample events
INSERT INTO events (event_name, event_description, start_date, end_date, max_capacity, status) VALUES
('AI Summit 2024', 'Annual artificial intelligence conference', '2024-06-15', '2024-06-17', 1000, 'published'),
('Data Science Workshop', 'Hands-on data science training', '2024-07-20', '2024-07-21', 200, 'published'),
('Machine Learning Expo', 'Latest in ML technologies', '2024-08-10', '2024-08-12', 800, 'draft');

-- Insert sample sessions
INSERT INTO sessions (event_id, session_name, session_description, start_time, end_time, room_id, speaker_id, max_capacity) VALUES
(1, 'Future of AI', 'Keynote presentation about AI trends', '2024-06-15 09:00:00', '2024-06-15 10:30:00', 1, 1, 500),
(1, 'Machine Learning Workshop', 'Hands-on ML training', '2024-06-15 11:00:00', '2024-06-15 12:30:00', 2, 2, 100),
(1, 'Neural Networks Deep Dive', 'Technical session on neural networks', '2024-06-15 14:00:00', '2024-06-15 15:30:00', 3, 4, 100),
(2, 'Data Science Fundamentals', 'Introduction to data science', '2024-07-20 09:00:00', '2024-07-20 10:30:00', 4, 3, 50),
(2, 'Advanced Analytics', 'Advanced data analysis techniques', '2024-07-20 11:00:00', '2024-07-20 12:30:00', 5, 5, 50);

-- Insert sample attendees
INSERT INTO attendees (first_name, last_name, email, company, title) VALUES
('Alice', 'Anderson', 'alice.a@company.com', 'Tech Solutions', 'Developer'),
('Bob', 'Baker', 'bob.b@company.com', 'Data Corp', 'Analyst'),
('Carol', 'Carter', 'carol.c@company.com', 'AI Research', 'Researcher'),
('Dan', 'Davis', 'dan.d@company.com', 'ML Systems', 'Engineer'),
('Eve', 'Edwards', 'eve.e@company.com', 'Neural Co', 'Scientist');

-- Insert sample registrations
INSERT INTO registrations (attendee_id, session_id, registration_status, attended) VALUES
(1, 1, 'confirmed', true),
(1, 2, 'confirmed', true),
(2, 1, 'confirmed', true),
(2, 3, 'confirmed', false),
(3, 2, 'confirmed', true),
(3, 3, 'waitlisted', false),
(4, 4, 'confirmed', false),
(5, 4, 'confirmed', false),
(5, 5, 'confirmed', false);
