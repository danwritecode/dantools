#!/bin/bash

# Read servers from file
SERVER_FILE="./servers.txt"

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

# Extract user@host from the line
USER_HOST=$(echo "$SELECTED" | awk '{print $2}')

# Optional: Name tmux session after server
SESSION_NAME=$(echo "$SELECTED" | awk '{print $1}')

# SSH and start/attach tmux session
ssh "$USER_HOST" "tmux new -As $SESSION_NAME"
