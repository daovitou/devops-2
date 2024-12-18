resource "aws_security_group" "sg_1" {
  name = "default"

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "vt3_key" {
  key_name   = "vt3-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+gWqQ8v7uXLM2q5CcfLxB1XQ/169vYZg/AwnfL3pAnLGsGjJ5TX1WAg+StVN/kruNhZw8P3f5N/nF15XKTGhYd5L0/N8M8mbJ2/O0Y3AVqM9SLhlSML8JZTV9qQeWSG6X8qJ+LrlJgKEIgxmrCf9pqoziFlcHcUc8+o10/wGfWzulYb1IPnGBIzO3YfUXVEZdgZMGs9XjwsU14J1Te6ouFvVnrfIp0c7gOKbrDUVlVWEAz9s50FVEtaeQSkDSJyAJmA3atxTxAfShlPGWGSzUehZy9zjZ9WWGtt1yKjBqWPUJXZif72ugm0QCvG/XT2iBGwU2a4PFdP72L/l66Geb vitoudao@DESKTOP-5518D97"
}

resource "aws_instance" "server_1" {
  ami  = "ami-df5de72bdb3b"
  instance_type = "t3.micro"
  count = 2
  key_name = aws_key_pair.vt3_key.key_name
  security_groups = [aws_security_group.sg_1.name]
    user_data = <<-EOF
                #!/bin/bash
                apt update
                apt install git -y
                apt install curl -y
                apt install python3 -y

                # Install NVM
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
                . ~/.nvm/nvm.sh

                # Install Node.js 18
                nvm install 18

                # Install PM2
                npm install pm2 -g

                # Clone Node.js repository
                git clone https://github.com/daovitou/devops-2.git /root/devops-2

                # Navigate to the repository and start the app with PM2
                cd /root/devops-2
                npm install
                pm2 start index.js --name node-app -- -p 8000
              EOF
  user_data_replace_on_change = true
}