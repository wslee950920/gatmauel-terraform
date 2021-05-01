resource "aws_instance" "gatmauel" {
  ami = "ami-0078a04747667d409"
  instance_type = "t2.micro"
  key_name = "gatmauel"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_security_group.allow_https.id]
  user_data = <<EOF
#!/bin/bash
apt update
apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible
ansible-pull -U https://github.com/wslee950920/gatmauel-ansible gatmauel.yaml -i localhost
EOF
}