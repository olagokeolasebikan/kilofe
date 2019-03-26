#!/bin/bash

while [ `sudo lsblk -n | grep -c 'xvdh'` -ne 1 ]
do
    echo "Waiting for /dev/xvdh to become available"
    sleep 10
done

if [ `sudo file -s /dev/xvdh | grep -c ext4` == 0 ]
then
    echo "New volume - formatting /dev/xvdh"
    sudo mkfs.xfs /dev/xvdh
fi

echo "Mounting /dev/xvdh as /data"
sudo mkdir /data
sudo mount /dev/xvdh /data

echo "Updating system and installing Docker"
sudo apt-get update
sudo apt-get -y install curl
curl -sSL https://get.docker.com/ | sudo sh

echo "Configuring Docker Daemon (require larger SHM size for Chrome)"
sudo echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --default-shm-size=512M' > /tmp/simple_dockerd.conf
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo mv /tmp/simple_dockerd.conf /etc/systemd/system/docker.service.d/simple_dockerd.conf
sudo usermod -a -G docker $USER
sudo systemctl daemon-reload
sudo systemctl restart docker


echo "Starting Docker with jenkinsci/blueocean image"
sudo docker run -d \
--user root \
--name kilofe-jenkins \
-p 8080:8080 \
-p 50000:50000 \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume /data:/var/jenkins_home \
--shm-size=512M \
jenkinsci/blueocean


echo "Starting php on docker"
sudo docker run -it -d \
--name kilofe-php \
-v "$PWD":/usr/src/myapp \
-w /usr/src/myapp php:7.0-cli php



echo "Starting mysql on docker"
sudo docker run -it \
--name kilofe-mysql \
-e MYSQL_ROOT_PASSWORD=Admin123 \
-d mysql:tag


echo "Starting Grafana Monitoring"
sudo docker run -d --name=kilofe-grafana \
-p 3000:3000 grafana/grafana

# echo "Building nodejs"
# sudo docker build -t kilofe-nodejs -t kilofe-nodejs lib/nodejs/

# echo "Running nodejs"
# docker run -d -p 8500:8500

