#!/bin/bash

SERVER_FILE="/home/dnelson/bin/dantools/simplessh/servers.txt"
SSH_KEY="$HOME/.ssh/server_key.pem"

# Parse arguments
USE_PASSWORD=0
USE_SFTP=0

for arg in "$@"; do
  case $arg in
    --password) USE_PASSWORD=1 ;;
    --sftp) USE_SFTP=1 ;;
  esac
done

if ! [ -f "$SERVER_FILE" ]; then
  echo "No server list found at $SERVER_FILE"
  exit 1
fi

SELECTED=$(cat "$SERVER_FILE" | fzf --prompt="Select server: ")
if [ -z "$SELECTED" ]; then
  echo "No server selected."
  exit 1
fi

USER_HOST=$(echo "$SELECTED" | awk '{print $2}')
WINDOW_NAME=$(echo "$SELECTED" | awk '{print $1}')

# SFTP STYLE with Midnight Commander
if [[ $USE_SFTP -eq 1 ]]; then
  # Get current directory
  LOCAL_DIR="$(pwd)"
  # Build MC command: left pane local, right pane remote SFTP
  MC_CMD="mc -d \"$LOCAL_DIR\" \"sftp://$USER_HOST/\""
  # Open in new tmux window
  tmux new-window -n "${WINDOW_NAME}-sftp" "$MC_CMD; read -p 'Press enter to close...'"
  exit 0
fi

# SSH STYLE
if [[ $USE_PASSWORD -eq 1 ]]; then
  tmux new-window -n "$WINDOW_NAME" "ssh $USER_HOST || read -p 'Press enter to close...'"
else
  tmux new-window -n "$WINDOW_NAME" "ssh -i $SSH_KEY $USER_HOST || read -p 'Press enter to close...'"
fi
