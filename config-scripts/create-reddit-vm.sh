#!/bin/bash

IMAGE_FOLDER_ID=b1gprlskmuless8prlue

yc compute instance create \
  --name reddit-full \
  --hostname reddit-full \
  --zone ru-central1-a \
  --memory=4 \
  --create-boot-disk image-folder-id=$IMAGE_FOLDER_ID,image-family=reddit-full,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
