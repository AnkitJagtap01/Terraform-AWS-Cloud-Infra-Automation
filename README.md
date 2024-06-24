# Terraform AWS Infrastructure Setup

This repository contains Terraform code to set up a basic AWS infrastructure, including a VPC, subnets, an EC2 instance, security groups, and other necessary components. Follow the steps below to understand and deploy the infrastructure.

## Prerequisites

- Terraform installed on your local machine. You can download it from [Terraform's official site](https://www.terraform.io/downloads.html).
- AWS account with appropriate permissions to create resources.
- AWS CLI configured with your credentials.

## Components

### 1. Providers

This block specifies the AWS provider and the required version.

### 2. Configure the AWS Provider

This section configures the AWS provider with your credentials and region.

### 3. VPC

Create a Virtual Private Cloud (VPC) with a CIDR block.

### 4. Internet Gateway

Attach an Internet Gateway to the VPC to allow internet access.

### 5. Custom Route Table

Create a route table for the VPC and associate it with the Internet Gateway.

### 6. Subnet

Create a subnet within the VPC.

### 7. ROute Table Association

Associate the subnet with the route table.

### 8. Security Groups

Create a security group to allow web and SSH traffic.

### 9. Network Interface

Create a network interface within the subnet.

### 10. Elastic IP

Assign an Elastic IP to the network interface.

### 11. EC2 Instace

Launch an EC2 instance and install Apache server on it.

## Usage

### Initialize Terraform: Initialize the Terraform working directory.

terraform init
![Screenshot 2024-06-20 at 8 15 33 PM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/3d1f2375-742c-48d1-be27-286dd60d8c23)


### Plan: Generate and show the execution plan.

terraform plan
![Screenshot 2024-06-20 at 11 45 20 PM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/311fc9ab-20dc-40b7-9c62-e4a73c03657f)


### Apply: Execute the actions proposed in the plan.

terraform apply
![Screenshot 2024-06-20 at 11 46 11 PM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/ece4f2e2-8eae-48ae-be86-06b765faecf9)


### Destroy: Destroy the Terraform-managed infrastructure.

terraform destroy
![Screenshot 2024-06-21 at 12 17 10 AM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/edbac05c-ab80-4f67-b1b8-2e187d7062d4)

### EC2 instance runs after apply the Terraform code

![Screenshot 2024-06-20 at 8 31 02 PM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/3f62b828-848d-4c54-b252-8dca1842c22f)


### To make any update, make the change in the terraform file and apply the changes

Changes the instance name here
![Screenshot 2024-06-20 at 11 46 53 PM](https://github.com/AnkitJagtap01/Terraform-AWS-Cloud-Infra-Automation/assets/91031017/9f89e4da-ff10-41b1-b70b-edd2245185ee)


## Output

- server_public_ip: The public IP address of the server.
- server_private_ip: The private IP address of the server.
- server_id: The ID of the EC2 instance.


This Terraform configuration sets up a basic infrastructure suitable for a web server deployment, including network setup, security groups, and an EC2 instance with an Apache web server.
