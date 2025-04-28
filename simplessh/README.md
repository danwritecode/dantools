## How to Use
1. Create a file in the same directory as the shell script with the below syntax: 
```
server1 user1@host1.example.com
server2 user2@host2.example.com
server3 user3@host3.example.com
```
2. Update `SERVER_FILE` and `SSH_KEY` paths to be wherever they are
3. `chmod +x simplessh.sh`
4. `./simplessh.sh`
5. Optional: add an alias to .bashrc or whatever

### Options
Pass the `--password` flag to use password instead of SSH key

### Preqrequisites
1. You have tmux installed