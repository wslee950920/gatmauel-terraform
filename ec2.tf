resource "aws_instance" "gatmauel" {
  ami = "ami-0078a04747667d409"
  instance_type = "t2.micro"
  key_name = "gatmauel"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_security_group.allow_https.id]

  provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("./gatmauel.pem")
        host = self.public_ip
      } 

      inline=[
          "sudo apt update",
          "sudo apt install -y software-properties-common",
          "sudo apt-add-repository --yes --update ppa:ansible/ansible",
          "sudo apt install -y ansible",
          "sudo ansible-pull -U https://github.com/wslee950920/gatmauel-ansible gatmauel.yaml -i localhost"
      ]
  }
}

