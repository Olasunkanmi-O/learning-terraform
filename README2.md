#  Custom VPC Infrastructure with Terraform

This project demonstrates how to build a **custom VPC architecture** on AWS using **Infrastructure as Code (IaC)** with **Terraform**. It includes key components such as public/private subnets, NAT and Internet gateways, route tables, security groups, and EC2 instances — all provisioned programmatically.

---

##  Objective

To provision a **production-like VPC setup** using Terraform, showcasing understanding of:
- VPC networking fundamentals
- AWS resource orchestration

---

##  Tools & Technologies

- **Terraform**
- **AWS CLI**
- **AWS EC2, VPC, Subnets, Gateways, Security Groups**
- **GitHub** for version control

---

##  Prerequisites

- AWS account with access keys
- AWS CLI configured locally
- Terraform installed
- Git

---

##  Project Structure

project/
├── main.tf
├── provider.tf
├── outputs.tf (optional)
└── .gitignore


---

## Key Components Deployed

| Resource | Description |
|---------|-------------|
| `aws_vpc` | Custom VPC with CIDR block |
| `aws_subnet` | 2 Public and 2 Private Subnets |
| `aws_internet_gateway` | Enables public subnet access |
| `aws_nat_gateway` | Allows outbound internet access from private subnets |
| `aws_route_table` & `associations` | Public and private route table configuration |
| `aws_security_group` | Rules for SSH and application access |
| `aws_key_pair` | SSH access to EC2 |
| `aws_instance` | EC2 instance in public subnet |

---

##  How to Run

```bash
terraform init       # Initialize Terraform
terraform validate   # Validate configuration syntax
terraform plan       # Preview resource changes
terraform apply      # Provision infrastructure
```
### EC2 access
`ssh -i "your-key.pem" ec2-user@<public-ip>`

### Sample screenshots
![](/img/03-2pub-sub.png)
![](/img/10-pri-rt.png)

Screenshots showing resource steps can be found in `/img` folder

## Lessons
- Importance of managing .tfstate and using .gitignore file
- Sequence of AWS resource provisioning
- Using Terraform Registry effectively
- Debugging syntax and validation issues during apply


## Future Improvements
Refactor to modules for better reuse

Add outputs.tf for better observability

Integrate remote backend for state management

CI/CD pipeline for Terraform using GitHub Actions