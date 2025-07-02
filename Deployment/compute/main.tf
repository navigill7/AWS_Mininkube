resource "aws_instance" "minikube_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update and install dependencies
              apt-get update -y
              apt-get upgrade -y
              apt-get install -y curl wget apt-transport-https ca-certificates gnupg lsb-release socat conntrack

              # Install Docker
              apt-get install -y docker.io
              systemctl enable docker
              systemctl start docker

              # Add user to docker group
              usermod -aG docker ubuntu

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              # Install Minikube
              curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
              dpkg -i minikube_latest_amd64.deb

              # Start Minikube with Docker driver
              export CHANGE_MINIKUBE_NONE_USER=true
              minikube start --driver=docker --force

              # Enable addons
              minikube addons enable default-storageclass
              minikube addons enable storage-provisioner

              # Set minikube as default context
              kubectl config use-context minikube
              EOF

  tags = {
    Name = "MiniKubeInstance"
  }
}
