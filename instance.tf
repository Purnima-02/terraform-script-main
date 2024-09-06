# creating vpcAOA

resource "aws_vpc" "demovpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Demo vpc"
  }
}



# creating 1st web subnet

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.demovpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-1"
  tags = {
    Name = "web subnet 1"
  }
}

# creating 2nd web subnet

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.demovpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "us-east-1"
  tags = {
    Name = "web subnet 2"
  }
}


# creating internet gateway

resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}




# creating public route table

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "route to internet"
  }
}

# associating 1st web route table

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route.id
}

# associating 2nd web route table

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route.id
}




#creating 1st ec2 instance in public subnet

resource "aws_instance" "demoinstance" {
  ami                         = "data.aws_ami.ubuntu.id"
  instance_type               = "t2.midium"
  key_name                    = "ubuntu sai"
  vpc_security_group_ids      = ["${aws_security_group.demosg.id}"]
  subnet_id                   = aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  user_data                   = file("bash.sh")
  tags = {
    Name = "my public instance"
  }
}
# create security group

resource "aws_security_group" "demosg" {
  vpc_id = aws_vpc.demovpc.id

  # inbound rules
  #HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #HTTP access from anywhere
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound rules
  #internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web sg"
  }
}






# creating variable file

# creating vpc
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# creating subnets
# creating cidr block for 1st subnet
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

# creating cidr block for 2nd subnet
variable "subnet1_cidr" {
  default = "10.0.2.0/24"
}
