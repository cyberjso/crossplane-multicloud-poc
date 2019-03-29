# crossplane-multi-cloud-poc
POC with script to launch an application running on both AWS and GCP cloud providers

## Before start

1. Be aware values suggested here are not recommended for production. This is just a POC.

2. You need to have an working AWS and GCP cloud account. This code is gonna  launch resources on both of them.

3. Have kubectl [propertly installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/) on the computer where you are gonna run this code.

4. Have AWS  command line interface [propertly installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) on the computer where you are gonna run this code.

5. On AWS:
    1. Create an user with the following PolicyName attached: <b> AminstratorAccess</b>
    2. On the <i>Security Credentials</i>, push the button <i>Create Access key</i>. Save access and secret key at <i>~/.aws/credentials</i> as <i>default.</i> profile
    3. Create a [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to attach on EC2 instances that will be launched. Upate the [environment file](aws/env.sh)  with the name of the key pair created.

6. On GCP
    1. Create a project
    2. Enable GKE service to run on it.


## Steps to reproduce this poc

 1. Set the environment variables [here](gcp/env.sh) for the GCP account. These are general values. Like the project name you are gonna use to launch resources, region, zones, etc

 2. Setup crossplane and also prepare GCP account to launch resources by running: ``` ./gcp/provisioning/crossplane.sh```. Run It only once, in case it fails, delete everything and start from scratch.

 3. Launch resources on GCP by running: ``` ./gcp/resources/launch.sh  ```

 4. Look at [validation steps](gcp/resources/validation.sh) for GCP. Run the commands one by one. Check if the resources were properly provisioned. At the end you should be able to access the application  running on GCP.

5. Start the provisioning on the AWS side by running: ```  ./aws/provisioning/start.sh ```. It's gonna take a while to complete...
This is a Cloudformation playbook and is gonna create the basic infrastructure. Run it only once, in case it fails, delete everyting and start from scratch.

6. By running ```aws cloudformation describe-stack-resources --stack-name crossplane-stack ``` you can check the status for every object created. We need to pull values from there and fill the [evironment](aws/resources/env.sh) file. Look for values on the field <i>LogicalResourceId</i> and grap values from <i>PhysicalResourceId</i> on the following way:

    * "LogicalResourceId": "ControlPlaneSecurityGroup" and set EKS_SECURITY_GROUP

    * "LogicalResourceId": "RDSSecurityGroup" and set RDS_SECURITY_GROUP

    *  "LogicalResourceId": "Subnet01", "LogicalResourceId": "Subnet02" and "LogicalResourceId": "Subnet03" and populate a comma separated value to set EKS_SUBNETS.

    * "LogicalResourceId": "VPC" and set EKS_VPC

    * Set ACCOUNT_ID to the account id you are running the POC

7. Launch resources on AWS by running: ``` ./aws/resources/launch.sh ```

8. EKS takes much longer than GKE to provision. Don't move on before EKS is fully provisioned. If you try to provision workloads on EKS while It's being launched you are gonna get inconsistent results. Keep watching EKS cluster until It's fully provisioned.

8. Run ``` kubectl apply -f aws/resources/workload.yaml ```` to provision a workload.

9. Look at [validation steps](aws/resources/validation.sh). Run the commands one by one. Check if the resources were properly provisioned. At the end you should be able to access the application running on AWS.


## Cleaning It up

In order to save your money, remove the provisioned resources after you are done playing with It.

1. On AWS, go to the cloudformation console and delete the EKS cluster Crossplane created.

2. Run ``` ./clean-all.sh ``` 
