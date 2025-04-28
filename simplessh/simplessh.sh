#!/bin/bash

# Update this accordingly
SERVER_FILE="/home/dan/bin/dantools/simplessh/servers.txt"

# Update this accordingly
SSH_KEY="~/.ssh/server_key.pem"

# Check for --password argument
USE_PASSWORD=0
if [[ "$1" == "--password" ]]; then
  USE_PASSWORD=1
fi

if ! [ -f "$SERVER_FILE" ]; then
  echo "No server list found at $SERVER_FILE"
  exit 1
fi

# Use fzf to select a server
SELECTED=$(cat "$SERVER_FILE" | fzf --prompt="Select server: ")

if [ -z "$SELECTED" ]; then
  echo "No server selected."
  exit 1
fi

# Extract user@host and a name for the window
USER_HOST=$(echo "$SELECTED" | awk '{print $2}')
WINDOW_NAME=$(echo "$SELECTED" | awk '{print $1}')

if [[ $USE_PASSWORD -eq 1 ]]; then
  # Password-based SSH
  tmux new-window -n "$WINDOW_NAME" "ssh $USER_HOST || read -p 'Press enter to close...'"
else
  # Key-based SSH (default)
  tmux new-window -n "$WINDOW_NAME" "ssh -i $SSH_KEY $USER_HOST || read -p 'Press enter to close...'"
fi
