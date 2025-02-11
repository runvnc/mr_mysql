#!/bin/bash

# Navigate to the directory
cd /xfiles/plugins_ah/mr_mysql

# Create the database
#sudo mysql -u root -p'your_password' -e "CREATE DATABASE IF NOT EXISTS event_management;"

# Import schema
#sudo mysql -u root -p'your_password' event_management < schema.sql

# Import sample data
sudo mysql -u root -p'your_password' event_management <sample_data.sql

# Verify setup
sudo mysql -u root -p'your_password' -e "USE event_management; SHOW TABLES;"

echo "Database setup complete!"
