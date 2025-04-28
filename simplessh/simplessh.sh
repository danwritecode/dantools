#!/bin/bash

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

# Extract user@host and a name for the window
USER_HOST=$(echo "$SELECTED" | awk '{print $2}')
WINDOW_NAME=$(echo "$SELECTED" | awk '{print $1}')

tmux new-window -n "$WINDOW_NAME" "ssh $USER_HOST || read -p 'Press enter to close...'"
