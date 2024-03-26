# Provision resources for Fortunes App

resource "aws_vpc" "default_latest" {
    cidr_block = "172.31.0.0/16"

    tags = {
        Name = "default_latest"
    }
}

resource "aws_subnet" "public_az_a" {
    vpc_id = aws_vpc.default_latest.id
    cidr_block = "172.31.0.0/20"
    availability_zone = "us-east-1a"

    tags = {
        Name = "1a"
    }
}

resource "aws_subnet" "public_az_b" {
    vpc_id = aws_vpc.default_latest.id
    cidr_block = "172.31.16.0/20"
    availability_zone = "us-east-1b"

    tags = {
        Name = "1b"
    }
}

resource "aws_internet_gateway" "igw_terraform" {
    vpc_id = aws_vpc.default_latest.id
}

resource "aws_default_route_table" "main_rt" {
  default_route_table_id = aws_vpc.default_latest.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_terraform.id
  }

}

resource "aws_security_group" "sg_fortunes" {
    vpc_id = aws_vpc.default_latest.id
    
    # cidr_ipv4         = "0.0.0.0/0"
    # ip_protocol       = "-1" # semantically equivalent to all ports
    lifecycle {
        create_before_destroy = true
    }

    ingress {
        protocol  = "tcp"
        from_port = 80
        to_port   = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        # Allow all outbound traffic
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sg_fortunes"
    }
}

resource "aws_launch_template" "fortunes_template" {
    name = "fortunes_template"

    image_id = "ami-0a2330e5da1a7ce1e"
    #vpc_security_group_ids = [aws_security_group.sg_fortunes.id]
    instance_type = "t2.micro"

    network_interfaces {
        associate_public_ip_address = true
        security_groups = [aws_security_group.sg_fortunes.id]
    }
}

resource "aws_autoscaling_group" "fortunes_asg_latest" {
    name = "fortunes-asg-latest"
    max_size = 2
    min_size = 1
    desired_capacity = 2
    vpc_zone_identifier = [aws_subnet.public_az_a.id, aws_subnet.public_az_b.id]
    
    launch_template {
        id = aws_launch_template.fortunes_template.id
        version = "$Latest"
    }
}
