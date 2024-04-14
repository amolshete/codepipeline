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
         - aws s3 cp target/*.jar s3://demo-codebuild-latest-12324/app.jar #change your bucket name 
   artifacts:
     files:
       - '**/*'
   
6. Provide the S3 bucket permission to codebuild service IAM role.
7. Start the build you should be able to see app.jar artifact in the s3 bucket which you have mentioned.

   
## CodeDeploy

1. Create the IAM role for the EC2 machine which will have the permission to access the Codedeploy service and s3 bucket.
2. In this project we are going to deploy the app on the EC2 machine.

So for that create the EC2 machine first. Now in real time you might consider to create the EC2 machine with ASG service.

While creating EC2 server keep below userdata which is installing the codedeploy agent which is necessary tool to be running on EC2.
Please note I am creating ubuntu instance and userdata script data is written for that.
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
Also make sure to attached the IAM role you have created in first first step.

3. Create an IAM role for codedeploy service. CodeDeploy service will require permissions of S3 bucket, EC2 and codedeploy.
4. Create the application and deployment group in the codedeploy service.
5. Now here we need to talk about the appspec.yaml file. In codedeploy service appspec.yaml is the file where we mentioned about how to do deployment.

```
### appspec.yaml

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
```
6. You can see In above appspec.yaml we have mentioned 2 scripts under hooks. So those scripts we need to create under scripts directory to have all depedencies and to run the application.

```
$ cat install_dependencies.sh
#!/bin/bash

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws s3 cp s3://demo-codebuild-latest-12324/app.jar /home/ubuntu/app.jar  #make sure to change the bucket name here

$ cat start_server.sh
#!/bin/bash

# Navigate to the directory where the JAR file is located
cd /home/ubuntu/

# Start the Java application
java -jar app.jar > /var/log/app.log 2>&1 &

```
...
