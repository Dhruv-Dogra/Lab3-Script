#!/bin/bash
# Script to configure a host

VERBOSE=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -verbose) VERBOSE=true ;;
        -name) NAME="$2"; shift ;;
        -ip) IP="$2"; shift ;;
        -hostentry) HOSTNAME="$2"; HOSTIP="$3"; shift 2 ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

log_message() {
    if [ "$VERBOSE" = true ]; then
        echo "$1"
    fi
    logger "$1"
}

if [ -n "$NAME" ]; then
    if [ "$(hostname)" != "$NAME" ]; then
        log_message "Changing hostname to $NAME"
        echo "$NAME" | sudo tee /etc/hostname
        sudo sed -i "s/127.0.1.1.*/127.0.1.1 $NAME/" /etc/hosts
        hostnamectl set-hostname "$NAME"
    else
        log_message "Hostname is already $NAME"
    fi
fi

if [ -n "$IP" ]; then
    CURRENT_IP=$(hostname -I | awk '{print $1}')
    if [ "$CURRENT_IP" != "$IP" ]; then
        log_message "Changing IP address to $IP"
        # Update Netplan or similar configuration here.
    else
        log_message "IP address is already $IP"
    fi
fi

if [ -n "$HOSTNAME" ] && [ -n "$HOSTIP" ]; then
    if ! grep -q "$HOSTIP $HOSTNAME" /etc/hosts; then
        log_message "Adding $HOSTNAME with IP $HOSTIP to /etc/hosts"
        echo "$HOSTIP $HOSTNAME" | sudo tee -a /etc/hosts
    else
        log_message "$HOSTNAME entry already exists in /etc/hosts"
    fi
fi
