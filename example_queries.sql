-- Example queries that demonstrate various complexities

-- 1. Find all sessions that still have available capacity
SELECT 
    s.session_name,
    s.max_capacity,
    COUNT(r.registration_id) as current_registrations,
    s.max_capacity - COUNT(r.registration_id) as spots_remaining
FROM sessions s
LEFT JOIN registrations r ON s.session_id = r.session_id
WHERE r.registration_status = 'confirmed'
GROUP BY s.session_id
HAVING spots_remaining > 0;

-- 2. Find overlapping sessions for a specific room
SELECT 
    a.session_name as session1,
    b.session_name as session2,
    a.start_time,
    a.end_time
FROM sessions a
JOIN sessions b ON 
    a.room_id = b.room_id AND
    a.session_id < b.session_id AND
    a.start_time < b.end_time AND
    a.end_time > b.start_time;

-- 3. Calculate attendance rate per speaker
SELECT 
    CONCAT(sp.first_name, ' ', sp.last_name) as speaker_name,
    COUNT(DISTINCT r.registration_id) as total_registrations,
    SUM(r.attended) as actual_attendees,
    ROUND(SUM(r.attended) / COUNT(DISTINCT r.registration_id) * 100, 2) as attendance_rate
FROM speakers sp
JOIN sessions s ON sp.speaker_id = s.speaker_id
JOIN registrations r ON s.session_id = r.session_id
WHERE r.registration_status = 'confirmed'
GROUP BY sp.speaker_id;

-- 4. Find popular time slots (sessions with waitlist)
SELECT 
    s.session_name,
    s.start_time,
    COUNT(CASE WHEN r.registration_status = 'confirmed' THEN 1 END) as confirmed,
    COUNT(CASE WHEN r.registration_status = 'waitlisted' THEN 1 END) as waitlisted
FROM sessions s
JOIN registrations r ON s.session_id = r.session_id
GROUP BY s.session_id
HAVING waitlisted > 0;

-- 5. Complex attendance report by company
SELECT 
    a.company,
    COUNT(DISTINCT a.attendee_id) as unique_attendees,
    COUNT(DISTINCT r.session_id) as sessions_registered,
    SUM(r.attended) as sessions_attended,
    ROUND(AVG(CASE WHEN r.attended = 1 THEN 1 ELSE 0 END) * 100, 2) as attendance_rate
FROM attendees a
JOIN registrations r ON a.attendee_id = r.attendee_id
WHERE a.company IS NOT NULL
GROUP BY a.company
ORDER BY unique_attendees DESC;

-- 6. Find potential room scheduling conflicts
WITH RoomUtilization AS (
    SELECT 
        r.room_id,
        s.start_time,
        s.end_time,
        COUNT(*) OVER (PARTITION BY r.room_id, s.start_time) as concurrent_sessions
    FROM rooms r
    JOIN sessions s ON r.room_id = s.room_id
)
SELECT 
    r.room_name,
    ru.start_time,
    ru.end_time,
    ru.concurrent_sessions
FROM RoomUtilization ru
JOIN rooms r ON ru.room_id = r.room_id
WHERE ru.concurrent_sessions > 1;

-- 7. Find attendees registered for multiple sessions in same time slot
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) as attendee_name,
    s1.session_name as session1,
    s2.session_name as session2,
    s1.start_time
FROM registrations r1
JOIN registrations r2 ON 
    r1.attendee_id = r2.attendee_id AND
    r1.registration_id < r2.registration_id
JOIN sessions s1 ON r1.session_id = s1.session_id
JOIN sessions s2 ON r2.session_id = s2.session_id
JOIN attendees a ON r1.attendee_id = a.attendee_id
WHERE 
    s1.start_time < s2.end_time AND
    s1.end_time > s2.start_time AND
    r1.registration_status = 'confirmed' AND
    r2.registration_status = 'confirmed';
