#!/bin/bash
sudo sed -i '$s/$/ --insecure-registry=marathon-lb-internal.marathon.mesos:10000/' /etc/systemd/system/docker.service.d/execstart.conf
sudo systemctl daemon-reload
sudo systemctl restart docker