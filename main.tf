# Create simple VPC.  One subnet with internet gateway

resource "aws_vpc" "nebari_sandbox_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# Create IGW and routes for it
resource "aws_internet_gateway" "nebari_sandbox_igw" {
  vpc_id = aws_vpc.nebari_sandbox_vpc.id
}

resource "aws_route_table" "nebari_sandbox_route_table" {
  vpc_id = aws_vpc.nebari_sandbox_vpc.id
}

resource "aws_route" "nebari_sandbox_route-public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.nebari_sandbox_route_table.id
  gateway_id             = aws_internet_gateway.nebari_sandbox_igw.id
}

# Create subnet and associate public route table
resource "aws_subnet" "nebari_sandbox_subnet" {
  vpc_id     = aws_vpc.nebari_sandbox_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.nebari_sandbox_subnet.id
  route_table_id = aws_route_table.nebari_sandbox_route_table.id
}


# Security group - allow SSH from user's home
resource "aws_security_group" "allow_ssh_home" {
  name        = "allow_ssh_home"
  description = "Allow SSH connections from user home IP"
  vpc_id      = aws_vpc.nebari_sandbox_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_local_ip}/32"]
  }

  tags = {
    Name = "allow_ssh_home"
  }
}


# Security group - allow instance to reach internet
resource "aws_security_group" "allow_egress" {
  name        = "allow_egress"
  description = "Allow outbound requests to internet"
  vpc_id      = aws_vpc.nebari_sandbox_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_egress"
  }
}

# Create EC2 

# TODO - install nebari (this just installs docker) and figure out exposing outside of kind K8S cluster

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "nebari_sandbox_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.nebari_ec2_size

  associate_public_ip_address = true
  key_name                    = var.my_key_pair
  subnet_id                   = aws_subnet.nebari_sandbox_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_home.id, aws_security_group.allow_egress.id]

  tags = {
    Name = "Nebari Local Deployment"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.nebari_disk_size
  }

  # User data - install Docker, clone repos, upgrade dependencies
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get -y install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -a -G docker ubuntu

# clone repos

for REPO in ${var.git_repos}
do
  runuser -l ubuntu -c "git clone $REPO"
done

# Add pip and upgrade dependencies
apt-get -y install python3-pip
pip install pip==23.2
pip install pyopenssl --upgrade
pip install requests --upgrade

EOF
}