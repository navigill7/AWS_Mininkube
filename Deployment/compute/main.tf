resource "aws_instance" "minikube_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<EOF
#!/bin/bash

# Update system
apt update -y && apt upgrade -y

# Install Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Install conntrack (required by Minikube)
apt install -y conntrack

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
install minikube /usr/local/bin/

# Start Minikube using Docker driver
sudo -u ubuntu minikube start --driver=docker
EOF

  tags = {
    Name = "MiniKubeInstance"
  }
}
