variable "access_key" {
  description = "Access-key-for-AWS"
  default = "no_access_key_value_found"
}
 
variable "secret_key" {
  description = "Secret-key-for-AWS"
  default = "no_secret_key_value_found"
}
 
output "access_key_is" {
  value = var.access_key
}
 
output "secret_key_is" {
  value = var.secret_key
}
 
provider "aws" {
	region = "eu-west-2"
	access_key = var.access_key
	secret_key = var.secret_key
}

resource "aws_instance" "example" {
	ami = "ami-098828924dc89ea4a"
	instance_type = "t2.micro"
    
    iam_instance_profile = "EC2-Access"
	key_name = "Prueba"
    user_data = <<-EOF
	        #!/bin/bash
		    sudo yum update -y
			sudo yum -y install httpd -y
		    sudo service httpd start
		    EOF
				
	tags = {
		Name = "My first EC2 using Terraform"
	}
	vpc_security_group_ids = [ "sg-0bee310192cdd7980","sg-441b3d3c" ]
	
}
resource "aws_security_group" "instance" {
	name = "terraform-tcp-security-group"
 
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_eip_association" "eipassoc-0fd07a7708e3d3811" {
  instance_id   = aws_instance.example.id
  allocation_id = "eipalloc-0554c0f4a5cfa8688"
}