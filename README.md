# Terraform lab

This lab work us through how to setup custom VPC and all its components using IAC and the tools is Terraform
## prerequisite
-   AWS active account
-   AWS CLI configured local machine 
-   Terraform configured local machine
-   Access to terraform registry

## procedures
1. Create a folder, inside this folder, create these files: main.tf and provider.tf 
2. Search for provider block in terraform registry [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to create a provider block of code, in this code, define the region where your resources will be deployed and ofcourse, the provider, in this case, AWS 
![](/img/01-provider.png)
3. search for below blocks
    - aws_vpc
    - aws_subnet
    - aws_internet_gateway
    - aws_route_table
    - aws_route_table_association
    - aws_security_group
    - aws_key_pair
    - aws_instance

4. create resources in the 'main.tf' file. I started with creating my vpc
![](/img/02.vpc.png)
5. create 2 subnets that will serve as public subnet
![](/img/03-2pub-sub.png)
6. create another 2 subnets that will serve as private subnets
![](/img/04-2pri-sub.png)
7. create the internet gateway
![](/img/05-igw.png)
8. create the nat-gateway for the private subnets
![](/img/06-natgw.png)
9. create the elastic IP
![](/img/07-eip.png)
10. Now is for the public route table
![](/img/08-pub-rt.png)
11. the public route table association that will make the public subnets public 
![](/img/09-pub-rt-asso.png)
12. Next is the private route table 
![](/img/10-pri-rt.png)
13. Then the private route table association that will make the assumed private subnet private
![](/img/11-pri-rt-asso.png)
14. Create the security group
![](/img/12-sg.png)
15. Create the keypairs as well as the instance. The keypair can be generated using below command and stored in a file to be called by the block of code for the keypair 
    ```bash
    ssh-keygen -t rsa
    ```
    ![](/img/13-key-inst.png)
16. While still in the folder, initialize terraform using the command 
*__terraform init__*
![](/img/14-init.png)
17. Next is *__terraform validate__*, this is to validate the syntax of the block of codes
![](/img/15validate.png)
18. The *__terraform plan__* command is to do a dry run of the resources to be created, modified or destroyed as the case may be.
![](/img/16plan.png)
19. the command that eventually builds the resources is the *__terraform apply__*, after this is entered into the system, it requires validation.
![](/img/17apply-yes.png)
20. the resources being created are shown on the terminal
![](/img/18-starts.png)
21. After all planned resources have been created, you will get a complete message 
![](/img/19completed.png)
22. you can view the resources from the AWS console to verify
![](/img/20-vpc-pri-sub.png)
![](/img/21vpc-pub-sub.png)
23. Log into the instance using ssh client 
![](/img/23sshinto.png)
24. below is the final file configuration and the system generated files 
![](/img/24.png) 