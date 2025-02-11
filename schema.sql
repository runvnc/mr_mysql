-- Event Management System Schema
-- MySQL version

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(200) NOT NULL,
    event_description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    max_capacity INT,
    status VARCHAR(20) NOT NULL DEFAULT 'draft' 
        CHECK (status IN ('draft', 'published', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    building VARCHAR(100),
    floor INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE speakers (
    speaker_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    bio TEXT,
    email VARCHAR(200) UNIQUE,
    company VARCHAR(200),
    title VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    session_name VARCHAR(200) NOT NULL,
    session_description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    room_id INT,
    speaker_id INT,
    max_capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id)
);

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    company VARCHAR(200),
    title VARCHAR(100),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE registrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    attendee_id INT NOT NULL,
    session_id INT NOT NULL,
    registration_status VARCHAR(20) NOT NULL DEFAULT 'confirmed'
        CHECK (registration_status IN ('confirmed', 'waitlisted', 'cancelled')),
    registration_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    attended BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    UNIQUE KEY unique_registration (attendee_id, session_id)
);

-- Add some indexes to improve query performance
CREATE INDEX idx_events_dates ON events(start_date, end_date);
CREATE INDEX idx_sessions_times ON sessions(start_time, end_time);
CREATE INDEX idx_registrations_status ON registrations(registration_status);
CREATE INDEX idx_sessions_event ON sessions(event_id);
CREATE INDEX idx_registrations_session ON registrations(session_id);
