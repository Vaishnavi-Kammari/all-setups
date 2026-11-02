
#!/bin/bash
set -e

# 1. Update packages
sudo apt update -y

# 2. Install Java 21 and required tools
sudo apt install -y fontconfig openjdk-21-jre curl

# 3. Verify Java
java -version

# 4. Configure the Jenkins LTS signing key
sudo install -d -m 0755 /etc/apt/keyrings

sudo curl -fsSL \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /etc/apt/keyrings/jenkins-keyring.asc

sudo chmod 0644 /etc/apt/keyrings/jenkins-keyring.asc

# 5. Add the Jenkins LTS repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 6. Update package lists and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# 7. Start Jenkins and enable it at boot
sudo systemctl enable --now jenkins

# 8. Verify Jenkins service
sudo systemctl --no-pager --full status jenkins

# 9. Display the initial administrator password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
