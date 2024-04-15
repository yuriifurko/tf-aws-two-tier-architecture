#!/bin/bash -xe

echo $name

sudo apt update
sudo apt-get upgrade -y
sudo apt -y install ca-certificates wget net-tools gnupg
sudo apt install nginx -y