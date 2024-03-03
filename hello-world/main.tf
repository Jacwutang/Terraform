# Hello World
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure provider
provider aws {
    region = "us-west-2"
}

# Create EC2
resource "aws_instance" "hello-world" {
    ami = "ami-08d70e59c07c61a3a"
    instance_type = "t2.micro"

    tags = {
        Name = var.instance_name
    }
}
