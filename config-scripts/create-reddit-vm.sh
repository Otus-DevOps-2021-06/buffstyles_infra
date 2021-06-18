#!/bin/bash

yc compute instance create \
  --name reddit-full \
  --hostname reddit-full \
  --zone ru-central1-a \
  --memory=4 \
  --create-boot-disk image-folder-id=b1gprlskmuless8prlue,image-family=reddit-full,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
