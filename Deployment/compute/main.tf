resource "aws_instance" "minikube_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = <<EOF
#!/bin/bash
set -e
LOGFILE="/home/admin/docker-setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

trap 'echo "❌ Script failed, cleaning up..."; minikube delete; exit 1' ERR
export HOME=/root

# ✅ System requirements
if [ \$(nproc) -lt 2 ] || [ \$(free -m | awk '/Mem:/ {print \$2}') -lt 2000 ]; then
    echo "❌ Requires at least 2 CPUs and 2GB RAM"
    exit 1
fi

echo "🛠️ Updating system and installing dependencies..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https nginx

echo "🔐 Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "📦 Adding Docker repository..."
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \\
https://download.docker.com/linux/debian \\
\$(lsb_release -cs 2>/dev/null || echo bookworm) stable" > /etc/apt/sources.list.d/docker.list

echo "📥 Installing Docker..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Starting Docker..."
systemctl enable docker
systemctl start docker

echo "📥 Installing Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
install -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "📥 Installing kubectl..."
K_VER=\$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/\${K_VER}/bin/linux/amd64/kubectl"
install -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "📁 Setting up Minikube config dirs..."
mkdir -p \$HOME/.kube \$HOME/.minikube
touch \$HOME/.kube/config
chmod -R 777 \$HOME/.kube \$HOME/.minikube

echo "🚀 Starting Minikube with Docker driver..."
minikube start --driver=docker --force

echo "✅ Minikube is up:"
minikube status
EOF

  tags = {
    Name = "MiniKubeInstance"
  }
}
