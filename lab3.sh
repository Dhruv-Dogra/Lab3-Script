#!/bin/bash

# Enable verbose mode if -verbose flag is passed
VERBOSE=false
if [[ "$1" == "-verbose" ]]; then
    VERBOSE=true
fi

# Define variables for container details
SERVER1="localhost"
PORT1="2221"
SERVER2="localhost"
PORT2="2222"
REMOTE_DIR="/root/"

# File to copy
LOCAL_FILE="example.txt" # Replace with your actual file
REMOTE_FILE="example.txt"

# Check if SSH is working for both servers
if $VERBOSE; then
    echo "Checking SSH connection to server1 on port $PORT1..."
fi
ssh -p $PORT1 root@$SERVER1 "echo SSH connection to server1 is working." || { echo "Error: Cannot connect to server1."; exit 1; }

if $VERBOSE; then
    echo "Checking SSH connection to server2 on port $PORT2..."
fi
ssh -p $PORT2 root@$SERVER2 "echo SSH connection to server2 is working." || { echo "Error: Cannot connect to server2."; exit 1; }

# Copy file to server1
if $VERBOSE; then
    echo "Copying $LOCAL_FILE to server1:$REMOTE_DIR..."
fi
scp -P $PORT1 $LOCAL_FILE root@$SERVER1:$REMOTE_DIR || { echo "Error: Failed to copy file to server1."; exit 1; }

# Execute the file on server1
if $VERBOSE; then
    echo "Executing $REMOTE_FILE on server1..."
fi
ssh -p $PORT1 root@$SERVER1 "bash $REMOTE_DIR$REMOTE_FILE" || { echo "Error: Failed to execute file on server1."; exit 1; }

# Copy file to server2
if $VERBOSE; then
    echo "Copying $LOCAL_FILE to server2:$REMOTE_DIR..."
fi
scp -P $PORT2 $LOCAL_FILE root@$SERVER2:$REMOTE_DIR || { echo "Error: Failed to copy file to server2."; exit 1; }

# Execute the file on server2
if $VERBOSE; then
    echo "Executing $REMOTE_FILE on server2..."
fi
ssh -p $PORT2 root@$SERVER2 "bash $REMOTE_DIR$REMOTE_FILE" || { echo "Error: Failed to execute file on server2."; exit 1; }

# Final output
echo "All operations completed successfully."
