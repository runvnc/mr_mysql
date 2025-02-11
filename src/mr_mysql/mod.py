from lib.providers.commands import command
import mysql.connector
from mysql.connector import Error
import json
import os

class MySQLConnection:
    def __init__(self, database=None):
        self.host = os.getenv('MYSQL_HOST', 'localhost')
        self.user = os.getenv('MYSQL_USER', 'root')
        self.password = os.getenv('MYSQL_PASSWORD', 'your_password')
        if not self.password:
            raise Exception("MYSQL_PASSWORD environment variable must be set")
        self.database = database
        self.connection = None
    
    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database
            )
            if self.connection.is_connected():
                return True
        except Error as e:
            raise Exception(f"Error connecting to MySQL: {e}")
        return False

    def close(self):
        if self.connection and self.connection.is_connected():
            self.connection.close()

@command()
async def query(sql, database=None, context=None):
    """Execute a MySQL query and return the results.
    
    Parameters:
    sql - The SQL query to execute
    database - (Optional) Database name to use
    
    Returns:
    Query results as a list of dictionaries
    
    Example:
    
    { "query": {
        "database": "mydatabase",
        "sql": "SELECT * FROM users LIMIT 5"
      }
    }
    """
    conn = MySQLConnection(database)
    try:
        conn.connect()
        cursor = conn.connection.cursor(dictionary=True)
        cursor.execute(sql)
        
        if sql.strip().upper().startswith('SELECT'):
            results = cursor.fetchall()
            return json.dumps(results, default=str)
        else:
            conn.connection.commit()
            return f"Query executed successfully. Rows affected: {cursor.rowcount}"
            
    except Error as e:
        raise Exception(f"Error executing query: {e}")
    finally:
        if cursor:
            cursor.close()
        conn.close()
