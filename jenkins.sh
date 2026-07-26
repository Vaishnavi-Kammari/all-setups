#!/bin/bash

# Update packages
sudo apt update -y

# Install Java (Jenkins requirement)
sudo apt install -y fontconfig openjdk-21-jre

# Verify Java installation
java -version

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Download the latest Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add the Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins

# Check Jenkins status
sudo systemctl status jenkins --no-pager

# Display initial admin password
echo ""
echo "=============================="
echo "Initial Jenkins Admin Password"
echo "=============================="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

