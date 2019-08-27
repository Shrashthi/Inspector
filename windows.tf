resource "aws_instance" "windowsclient" {
  ami = var.AMI_windows
  instance_type = var.Instancetype
  key_name = var.Keyname
  vpc_security_group_ids = ["${aws_security_group.windows_sg.id}"]
  user_data = "${file("userdatawin.txt")}"
  tags = {
    Name = var.winvalue
  }

}

resource "aws_security_group" "windows_sg" {
  name   = "Inspectorwindowsg"
  vpc_id = var.vpcid

  ingress {
    protocol    = "tcp"
    from_port   = 3389
    to_port     = 3389
    cidr_blocks = ["202.54.252.201/32"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 5985
    to_port     = 5985
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 5986
    to_port     = 5986
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  }

output "windowsip" {
  value = ["${aws_instance.windowsclient.public_ip}"]
}
