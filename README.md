# codepipeline
This repo is created to demonstrate the AWS codepipeline demo


# Codecommit Tools:

Code commit repo cannot be managed with aws root user. We need to create the aws user for the same.

We can create the user from IAM service. Once user creation is done login with the new user in aws console.

Search for the codecommit service and then create new repo.

We generally prefer to handle the git repos with the ssh way.

So that lets setup the codecommit connection with the help of documentation.

You will get the connection step on the same repo page.

Just follow that and you should be able to push and pull code out of codecommit repo.


# CodeBuild

We have to create buildspec.yml 
In builspec file we have to 2 things:-

1. In install phase install all dependecies for building of the application
2. In build phase you have to provide the build command.
3. In post build you will transfer the artifact to s3 bucket. because of this 3rd step you need to provide the s3 bucket permission in codebuild role

below is the example

# cat buildspec.yml
version: 0.2

phases:
  install:
    commands:
       - sudo apt-get update
       - sudo apt-get install maven -y
       - mvn --version
  build:
    commands:
       - mvn clean install -Dskiptests
      # - command
  post_build:
     commands:
        - echo "transfer the artifact..."
        - aws s3 cp target/*.jar s3://demo-codebuild-latest-12324/app.jar
      # - command
artifacts:
  files:
     - '**/*'





# codedeploy

$ cat appspec.yml
version: 0.0
os: linux
files:
  - source: /
    destination: /home/ubuntu/
    overwrite: true
permissions:
  - object: /home/ubuntu/
    pattern: "**"
    owner: root
    group: root
    mode: 755
hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
      runas: root
  AfterInstall:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root

 
 
 
$ cat install_dependencies.sh
#!/bin/bash

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


aws s3 cp s3://demo-codebuild-latest-12324/app.jar /home/ubuntu/app.jar



 
$ cat start_server.sh
#!/bin/bash

# Navigate to the directory where the JAR file is located
cd /home/ubuntu/

# Start the Java application
java -jar app.jar > /var/log/app.log 2>&1 &




https://towardsaws.com/anatomy-of-the-appspec-file-abadf06186ef

https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html
