#!/bin/bash

sudo systemctl start mongod
# TODO: REGARDER POURQUOI LE BIND IP ALL NE FONCTIONNE PAS
sudo mongod --bind_ip_all
sudo systemctl enable mongod
