#!/bin/bash

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws s3 cp s3://codebuild-demo-s3-bucket-12345/app.jar /home/ubuntu/app.jar  #make sure to change the bucket name here
