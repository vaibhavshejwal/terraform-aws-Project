# Terraform AWS WITH VPC, EC2, NAT, IGW and Apache Setup

This project demonstrates how to provision a real-world AWS infrastructure using Terraform.
It sets up a secure network architecture with a public-facing web server and a private backend server,
following AWS best practices.

The infrastructure has been successfully deployed and tested on AWS.

---

## 🏗 Architecture Diagram

```mermaid
flowchart TB
    Internet((Internet))
    IGW[Internet Gateway]

    subgraph VPC["VPC (10.0.0.0/16)"]
        subgraph PublicSubnet["Public Subnet (10.0.1.0/24)"]
            WebEC2[Web Server EC2]
            NAT[NAT Gateway]
        end

        subgraph PrivateSubnet["Private Subnet (10.0.2.0/24)"]
            DBEC2[Database EC2]
        end

        PublicRT[Public Route Table]
        PrivateRT[Private Route Table]
    end

    Internet --> IGW
    IGW --> PublicRT
    PublicRT --> WebEC2
    PublicRT --> NAT
    DBEC2 --> PrivateRT
    PrivateRT --> NAT
    NAT --> IGW

    
What This Project Does:

> Networking:
    Creates a custom VPC with CIDR 10.0.0.0/16
    Public subnet for internet-facing resources
    Private subnet for internal resources
    Internet Gateway for inbound and outbound internet access
    NAT Gateway to allow outbound internet access from private subnet
    Separate route tables for public and private traffic

> Compute:

    Web Server EC2:
        Launched in the public subnet
        Runs Amazon Linux
        Apache installed automatically using user data
        Accessible via public IP

    Database EC2
        Launched in the private subnet
        No public IP
        Internet access only through NAT Gateway
        
    Security"
        Security group allowing:
            HTTP (port 80)
            SSH (port 22)
            All outbound traffic
        Private instance is not exposed to the internet

🧰Tools and Technologies Used:
    Terraform
    AWS EC2
    AWS VPC, Subnets, Route Tables
    Internet Gateway and NAT Gateway
    Amazon Linux
    Apache HTTP Server
    Git and GitHub

⚙️How to Deploy:

Make sure AWS credentials are configured locally.

        terraform init
        terraform plan
        terraform apply


After deployment:
    Terraform outputs the public IP of the web server
    Open the IP in a browser to verify Apache is running

🔴Live Deployment Status:
        This infrastructure has been successfully deployed on AWS using Terraform.
        All components were created and validated in a real AWS environment.

📂 Project Structure:
    terraform-aws-vpc-ec2/
    │
    ├── main.tf
    ├── variables.tf
    ├── userdata.sh
    ├── README.md
    ├── .gitignore
    └── .terraform.lock.hcl

Terraform state files are intentionally excluded from version control.

📚Key Learnings:
        Difference between public and private subnets in AWS
        How NAT Gateway enables secure outbound access
        Role of route tables in network traffic flow
        Importance of security groups in controlling access
        Automating EC2 configuration using Terraform user data

🔮Future Improvements:
        Use remote backend with S3 and DynamoDB
        Convert configuration into reusable Terraform modules
        Add Application Load Balancer
        Implement Auto Scaling Group
        Introduce a bastion host for SSH access

👤 Author:
    Vaibhav Shejwal
 