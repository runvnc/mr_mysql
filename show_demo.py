#!/usr/bin/env python3

import mysql.connector
from rich.console import Console
from rich.table import Table
from rich import box
from datetime import datetime

# Initialize Rich console
console = Console()

# Database connection
db_config = {
    'user': 'root',
    'password': 'your_password',
    'host': 'localhost',
    'database': 'event_management'
}

def create_connection():
    try:
        return mysql.connector.connect(**db_config)
    except mysql.connector.Error as err:
        console.print(f"[red]Error connecting to database: {err}[/red]")
        exit(1)

def show_upcoming_events(conn):
    table = Table(title="Upcoming Events", box=box.ROUNDED)
    table.add_column("Event Name", style="cyan", no_wrap=True)
    table.add_column("Start Date", style="green")
    table.add_column("End Date", style="green")
    table.add_column("Status", style="yellow")
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            event_name,
            DATE_FORMAT(start_date, '%b %d, %Y'),
            DATE_FORMAT(end_date, '%b %d, %Y'),
            status
        FROM events
        WHERE end_date >= CURDATE()
        ORDER BY start_date
    """)
    
    for row in cursor:
        table.add_row(*[str(x) for x in row])
    
    console.print(table)
    console.print()

def show_popular_sessions(conn):
    table = Table(title="Most Popular Sessions", box=box.ROUNDED)
    table.add_column("Session Name", style="cyan")
    table.add_column("Event", style="blue")
    table.add_column("Registrations", style="green", justify="right")
    table.add_column("Capacity", style="yellow", justify="right")
    table.add_column("Speaker", style="magenta")
    
    cursor = conn.cursor()
    cursor.execute("""
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
        LIMIT 5
    """)
    
    for row in cursor:
        table.add_row(*[str(x) for x in row])
    
    console.print(table)
    console.print()

def show_speaker_stats(conn):
    table = Table(title="Speaker Statistics", box=box.ROUNDED)
    table.add_column("Speaker", style="cyan")
    table.add_column("Company", style="blue")
    table.add_column("Sessions", style="green", justify="right")
    table.add_column("Total Registrations", style="yellow", justify="right")
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            CONCAT(sp.first_name, ' ', sp.last_name) as speaker,
            sp.company,
            COUNT(DISTINCT s.session_id) as sessions,
            COUNT(DISTINCT r.registration_id) as total_registrations
        FROM speakers sp
        LEFT JOIN sessions s ON sp.speaker_id = s.speaker_id
        LEFT JOIN registrations r ON s.session_id = r.session_id
        GROUP BY sp.speaker_id
        ORDER BY total_registrations DESC
    """)
    
    for row in cursor:
        table.add_row(*[str(x) for x in row])
    
    console.print(table)
    console.print()

def show_room_utilization(conn):
    table = Table(title="Room Utilization", box=box.ROUNDED)
    table.add_column("Room", style="cyan")
    table.add_column("Capacity", style="yellow", justify="right")
    table.add_column("Scheduled Sessions", style="green", justify="right")
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            r.room_name,
            r.capacity,
            COUNT(DISTINCT s.session_id) as scheduled_sessions
        FROM rooms r
        LEFT JOIN sessions s ON r.room_id = s.room_id
        GROUP BY r.room_id
        ORDER BY scheduled_sessions DESC
    """)
    
    for row in cursor:
        table.add_row(*[str(x) for x in row])
    
    console.print(table)
    console.print()

def show_registration_summary(conn):
    table = Table(title="Registration Status Summary", box=box.ROUNDED)
    table.add_column("Status", style="cyan")
    table.add_column("Total Count", style="green", justify="right")
    table.add_column("Unique Attendees", style="yellow", justify="right")
    
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            registration_status,
            COUNT(*) as count,
            COUNT(DISTINCT attendee_id) as unique_attendees
        FROM registrations
        GROUP BY registration_status
    """)
    
    for row in cursor:
        table.add_row(*[str(x) for x in row])
    
    console.print(table)
    console.print()

def main():
    console.print("[bold cyan]Event Management System Demo[/bold cyan]", justify="center")
    console.print("[dim]Generated at: {}[/dim]\n".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S')), justify="center")
    
    conn = create_connection()
    
    show_upcoming_events(conn)
    show_popular_sessions(conn)
    show_speaker_stats(conn)
    show_room_utilization(conn)
    show_registration_summary(conn)
    
    conn.close()

if __name__ == "__main__":
    main()
