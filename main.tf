# creating a custom vpc 
resource "aws_vpc" "dev-vpc" {
    # setting cidr block 
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
    
  }
}

# this block creates public subnet
resource "aws_subnet" "pub-sub-1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-1"
    
  }
}

#this block creates another public subnet 
resource "aws_subnet" "pub-sub-2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public-subnet-2"
    
  }
}

# this block creates private subnet
resource "aws_subnet" "pri-sub-1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private-subnet-1"
    
  }
}

# this block creates another private subnet
resource "aws_subnet" "pri-sub-2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-subnet-2"
    
  }
}

// creating internet gateway for public subnets
resource "aws_internet_gateway" "igw-dev" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "igw-dev"    

  }
}

//Required nat gateway for resources in private subnet 1
resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.lb1.id
  subnet_id     = aws_subnet.pub-sub-1.id
  depends_on = [aws_internet_gateway.igw-dev]

  tags = {
    Name = "nat-gw-1"
  }

}



// creating elastic ip for the nat gateway
resource "aws_eip" "lb1" {
  domain   = "vpc"
}



// this block creates a public route table 
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-dev.id
  }

 
  tags = {
    Name = "pub-rt"
  }
}

//creates a route table association for the public subnet
resource "aws_route_table_association" "pub-rt-ass-1" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pub-rt-ass-2" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.pub-rt.id
}

// this block creates a private route table 
resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-1.id
  }

 
  tags = {
    Name = "pri-rt"
  }
}

//creates a route table association for the private subnet
resource "aws_route_table_association" "pri-rt-ass-1" {
  subnet_id      = aws_subnet.pri-sub-1.id
  route_table_id = aws_route_table.pri-rt.id
}


resource "aws_route_table_association" "pri-rt-ass-2" {
  subnet_id      = aws_subnet.pri-sub-2.id
  route_table_id = aws_route_table.pri-rt.id
}

//This block creates security group
resource "aws_security_group" "dev-vpc-sg" {
  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//creating keypair
resource "aws_key_pair" "deployer" {
  key_name   = "new-key"
  public_key = file("./new-key.pub")
}

// creating an EC2
resource "aws_instance" "web-server" {
  ami           = "ami-0e8d228ad90af673b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.dev-vpc-sg.id ]
  associate_public_ip_address = true
  subnet_id = aws_subnet.pub-sub-1.id
  key_name = aws_key_pair.deployer.id

  tags = {
    Name = "web-server"
  }
}