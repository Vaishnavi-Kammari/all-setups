
#!/bin/bash
set -euo pipefail

# Install Java 21 and dependencies
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-21-jre curl gnupg

# Configure Jenkins LTS signing key
sudo install -d -m 0755 /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  | sudo gpg --dearmor --yes \
      -o /etc/apt/keyrings/jenkins-keyring.gpg

sudo chmod 0644 /etc/apt/keyrings/jenkins-keyring.gpg

# Add Jenkins LTS repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Enable and start Jenkins
sudo systemctl enable --now jenkins

# Verify installation
java -version
sudo systemctl --no-pager --full status jenkins
