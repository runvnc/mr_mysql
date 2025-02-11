#!/bin/bash

echo "=== Event Management System Demo ===
"

echo "1. Upcoming Events:"
echo "----------------"
sudo mysql -u root -p'your_password' event_management -e "
    SELECT 
        event_name, 
        DATE_FORMAT(start_date, '%b %d, %Y') as start_date,
        DATE_FORMAT(end_date, '%b %d, %Y') as end_date,
        status
    FROM events 
    WHERE end_date >= CURDATE()
    ORDER BY start_date;"

echo "
2. Most Popular Sessions (by Registration Count):"
echo "----------------------------------------"
sudo mysql -u root -p'your_password' event_management -e "
    SELECT 
        s.session_name,
        e.event_name,
        COUNT(r.registration_id) as registrations,
        s.max_capacity,
        CONCAT(sp.first_name, ' ', sp.last_name) as speaker
    FROM sessions s
    JOIN events e ON s.event_id = e.event_id
    LEFT JOIN registrations r ON s.session_id = r.session_id
    LEFT JOIN speakers sp ON s.speaker_id = sp.speaker_id
    GROUP BY s.session_id
    ORDER BY registrations DESC
    LIMIT 5;"

echo "
3. Speaker Statistics:"
echo "------------------"
sudo mysql -u root -p'your_password' event_management -e "
    SELECT 
        CONCAT(sp.first_name, ' ', sp.last_name) as speaker,
        sp.company,
        COUNT(DISTINCT s.session_id) as sessions,
        COUNT(DISTINCT r.registration_id) as total_registrations
    FROM speakers sp
    LEFT JOIN sessions s ON sp.speaker_id = s.speaker_id
    LEFT JOIN registrations r ON s.session_id = r.session_id
    GROUP BY sp.speaker_id
    ORDER BY total_registrations DESC;"

echo "
4. Room Utilization:"
echo "-----------------"
sudo mysql -u root -p'your_password' event_management -e "
    SELECT 
        r.room_name,
        r.capacity,
        COUNT(DISTINCT s.session_id) as scheduled_sessions
    FROM rooms r
    LEFT JOIN sessions s ON r.room_id = s.room_id
    GROUP BY r.room_id
    ORDER BY scheduled_sessions DESC;"

echo "
5. Registration Status Summary:"
echo "---------------------------"
sudo mysql -u root -p'your_password' event_management -e "
    SELECT 
        registration_status,
        COUNT(*) as count,
        COUNT(DISTINCT attendee_id) as unique_attendees
    FROM registrations
    GROUP BY registration_status;"
