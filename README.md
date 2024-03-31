# codepipeline
This repo is created to demonstrate the AWS codepipeline demo


# AWS DevOps Workflow

## CodeCommit Tools

- CodeCommit repositories cannot be managed with the AWS root user.
- Create an AWS IAM user specifically for CodeCommit management.
- Use the IAM service to create the new user, then log in to the AWS console with the new user's credentials.
- Search for the CodeCommit service in the AWS console and create a new repository.
- Preferably, manage Git repositories using SSH.
- Set up the CodeCommit connection following the documentation provided in the repository page.
- Follow the connection steps to enable pushing and pulling code from the CodeCommit repository.

## CodeBuild

1. Go to AWS Codebuild service and create build project.
2. You need to choose the source code either you can choose github or codecommit its up to you.
3. Create a `buildspec.yml` file for CodeBuild.
4. In the `buildspec.yml`, include the following phases:
   - **Install Phase:** Install all dependencies required for building the application.
   - **Build Phase:** Provide the build command to build the application.
   - **Post Build Phase:** Transfer the artifact to an S3 bucket. Ensure that the CodeBuild role has permissions to access the S3 bucket.
5. Example `buildspec.yml` content:

   ```yaml
   version: 0.2
   phases:
     install:
       commands:
         - sudo apt-get update
         - sudo apt-get install maven -y
         - mvn --version
     build:
       commands:
         - mvn clean install -DskipTests
     post_build:
       commands:
         - echo "Transfer the artifact..."
         - aws s3 cp target/*.jar s3://demo-codebuild-latest-12324/app.jar
   artifacts:
     files:
       - '**/*'

## CodeDeploy

In this project we are going to deploy the app on the EC2 machine.

So for that create the EC2 machine first. Now in real time you might consider to create the EC2 machine with ASG service.

While creating EC2 server keep below userdata which is installing the codedeploy agent which is necessary tool to be running on EC2.
```
#!/bin/bash

exec > /home/ubuntu/userdata_output.txt 2>&1
sudo apt update
sudo apt install ruby-full -y
sudo apt install wget
cd /home/ubuntu
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

systemctl status codedeploy-agent
systemctl start codedeploy-agent
systemctl status codedeploy-agent

```
