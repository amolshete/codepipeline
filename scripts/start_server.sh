#!/bin/bash

# Navigate to the directory where the JAR file is located
cd /home/ubuntu/

# Start the Java application
java -jar app.jar > /var/log/app.log 2>&1 &
