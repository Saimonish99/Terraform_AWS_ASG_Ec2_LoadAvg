resource "aws_launch_template" "demo-monish" {
  name_prefix   = "demo-monish-LT"
  description = "LT for demo-monish-ASG"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.demo-monish.key_name
  network_interfaces {
    subnet_id = aws_subnet.demo-monish-public-subnets.*.id[0]
    security_groups = [aws_security_group.demo-monish.id]
  }
  block_device_mappings {
    device_name = "/dev/xvdf"
    ebs {
      volume_size = 20
    }
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.demo-monish.arn
  }
  tags = {
    Name="demo-monish-LT"
    created_by=var.created_by
    created_for=var.created_for
    Terraformed="True"
  }
  user_data = filebase64("cloudwatch_metric.sh")
}

data "aws_ami" "ubuntu" {
most_recent = true
owners = ["099720109477"]
  filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
  filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "tls_private_key" "demo-monish" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo-monish" {
  key_name   = var.key_name
  public_key = tls_private_key.demo-monish.public_key_openssh
}