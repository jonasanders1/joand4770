#!/bin/bash

# 1 deploy x instances of HTTP servers on different nodes in the cluster
# 2 input parameter specifying the number of servers to deploy
# 3 start the servers on different nodes
# 4 make sure that each server runs on different ports
# 5 return a JSON-formatted list with 'host:port' combos of the running servers

# check to see if the shell sctipt gets the number of servers as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_servers>"
  exit 1
fi

NUM_SERVERS=$1
HOSTS=($(/share/ifi/available-nodes.sh))  # check for available nodes
HOST_PORTS=()  # array declaration to later store the 'host:port combos'

# current working directory (full path)
PROJECT_DIR=$PWD

# loop though all servers and deploy each one
for ((i=0; i<$NUM_SERVERS; i++)); do
  HOST=${HOSTS[$i % ${#HOSTS[@]}]}  
  PORT=$(shuf -i 5000-60000 -n 1)  # get random port between 5000 and 60000

  # SSH into the node:
  # ----> start the server in the background with working directory
  ssh $HOST "nohup python3 $PROJECT_DIR/server.py $PORT > $PROJECT_DIR/server_$HOST_$PORT.log 2>&1 &"

  # Add the host:port combination to the array
  HOST_PORTS+=("$HOST:$PORT")
done

# Output the host:port combinations as a JSON list (array)
echo $(printf '%s\n' "${HOST_PORTS[@]}" | jq -R . | jq -s .)
