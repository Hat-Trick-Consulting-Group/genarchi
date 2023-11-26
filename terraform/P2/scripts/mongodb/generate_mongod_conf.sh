#!/bin/bash

# Get the machine's IP address dynamically
machine_ip=$(hostname -I | awk '{print $1}')

cat <<EOF > /etc/mongod.conf
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
storage:
  dbPath: /var/lib/mongodb
processManagement:
  timeZoneInfo: /usr/share/zoneinfo
net:
  port: 27017
  bindIp: localhost,${machine_ip}
replication:
  replSetName: rs0
EOF
