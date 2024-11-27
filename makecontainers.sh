#!/bin/bash
# This script creates Docker containers to simulate servers.

count=2
prefix="server"
fresh=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --count) count="$2"; shift ;;
        --prefix) prefix="$2"; shift ;;
        --fresh) fresh=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

for i in $(seq 1 "$count"); do
    container_name="${prefix}${i}-mgmt"
    if [ "$fresh" = true ]; then
        docker rm -f "$container_name" 2>/dev/null
    fi
    docker run -dit --name "$container_name" --hostname "$container_name" ubuntu:20.04
    docker exec "$container_name" apt update
    docker exec "$container_name" apt install -y openssh-server
    docker exec "$container_name" service ssh start
done

echo "Created $count containers with prefix '$prefix'."
docker ps
