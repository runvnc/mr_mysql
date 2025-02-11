# Event Management System Demo Database

This is a demonstration database designed to showcase natural language to SQL capabilities with error correction. The schema models a conference/event management system with multiple interconnected entities that create various querying challenges.

## Schema Overview

The database consists of 6 main tables:

1. **events** - Main events/conferences
2. **sessions** - Individual sessions within events
3. **rooms** - Physical locations where sessions occur
4. **speakers** - People presenting at sessions
5. **attendees** - People attending the events
6. **registrations** - Links attendees to sessions they're registered for

## Why This Schema is Good for NL->SQL Testing

### Complex Relationships
- Many-to-many relationships between attendees and sessions
- Hierarchical structure (events contain sessions)
- Multiple foreign key relationships
- Capacity constraints across different entities

### Temporal Complexities
- Date/time handling
- Overlapping sessions
- Historical vs future events
- Registration timestamps

### Natural Language Ambiguities
Example queries that demonstrate complexity:

1. "How many people attended the AI Summit?"
   - Could mean unique attendees vs total session attendance
   - Could mean registered vs actually attended
   - Temporal ambiguity (which AI Summit?)

2. "Which rooms are available tomorrow afternoon?"
   - Requires time-based logic
   - Must consider capacity
   - Must handle overlapping sessions

3. "Who is our most popular speaker?"
   - Multiple possible metrics (registration count, attendance rate, waitlist size)
   - Could be overall or per event
   - Might need to account for room capacity differences

### Business Intelligence Opportunities
- Attendance patterns
- Room utilization
- Popular topics/speakers
- Registration trends
- Capacity planning

## Files Included

1. `schema.sql` - Complete MySQL schema definition
2. `sample_data.sql` - Sample data insert statements
3. `example_queries.sql` - Collection of complex queries demonstrating various scenarios

## Common Error Cases

1. **Capacity Violations**
   - Room capacity exceeded
   - Session capacity exceeded
   - Waitlist handling

2. **Temporal Conflicts**
   - Double-booked rooms
   - Overlapping session registrations
   - Invalid date ranges

3. **Status Transitions**
   - Event status changes
   - Registration status changes
   - Attendance tracking

4. **Data Integrity**
   - Duplicate registrations
   - Missing required relationships
   - Invalid status values

## Using This Database for Testing

This database is particularly useful for testing natural language query systems because:

1. It's complex enough to require multi-table joins and subqueries
2. It contains temporal data that often needs special handling
3. It models real-world constraints that must be considered
4. It provides opportunities for ambiguous queries that need clarification
5. It includes enough sample data to make aggregate queries meaningful

## Example Natural Language Queries

1. "Show me all sessions that still have space available"
2. "Which speakers have the highest attendance rates?"
3. "Are there any scheduling conflicts in Room A next week?"
4. "How many people from Tech Corp are attending the AI Summit?"
5. "What's the most popular time slot for workshops?"
6. "Who is registered for multiple sessions at the same time?"
7. "Which events have the longest waitlists?"

Each of these queries requires multiple joins, careful handling of temporal data, and consideration of business rules - making them excellent test cases for natural language to SQL systems.
