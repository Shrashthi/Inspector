resource "aws_instance" "linuxclient" {
  ami                         = var.AMI_linux
  instance_type               = var.Instancetype
  key_name                    = var.Keyname
  subnet_id                   = var.subnetid
  security_groups             = ["${aws_security_group.linux_sg.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }
  
  tags = {
    Name = var.linuxvalue
  }

  lifecycle {
    ignore_changes = ["ami"]
  }

  connection {
   host = "${aws_instance.linuxclient.public_ip}"
   type = "ssh"
   user = "ec2-user"
   private_key = "${file(var.PATH_TO_PUBLIC_KEY)}"
  }
 provisioner "remote-exec" {
   inline = ["sudo yum -y install awscli"]

}
provisioner "local-exec" {
        command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key /home/ec2-user/awsInspector/inspector.pem -i '${aws_instance.linuxclient.public_ip},' /etc/ansible/inspectoragent.yml"
    }
provisioner "local-exec" {
       command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key /home/ec2-user/awsInspector/inspector.pem -i '${aws_instance.linuxclient.public_ip},' /etc/ansible/patching.yml"
    }
provisioner "local-exec" {
       command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key /home/ec2-user/awsInspector/inspector.pem -i '${aws_instance.linuxclient.public_ip},' /etc/ansible/hardening.yml"
    }

}

resource "aws_security_group" "linux_sg" {
  name   = "Inspectorlinuxsg"
  vpc_id = var.vpcid

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "Linuxip" {
  value = ["${aws_instance.linuxclient.public_ip}"]
}

