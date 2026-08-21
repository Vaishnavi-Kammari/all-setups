```bash
#!/bin/bash

set -e

# Update packages
apt-get update -y

# Install required packages
apt-get install -y unzip wget openjdk-21-jdk

# Verify Java
java -version

# Create SonarQube user
useradd -r -m -d /opt/sonarqube -s /bin/bash sonar || true

# Download SonarQube Community Build
cd /opt

wget -O sonarqube.zip \
https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.3.0.120487.zip

# Extract
unzip -q sonarqube.zip

mv sonarqube-26.3.0.120487 sonarqube

rm -f sonarqube.zip

# Set ownership
chown -R sonar:sonar /opt/sonarqube

# Configure SonarQube
cat >> /opt/sonarqube/conf/sonar.properties <<EOF

sonar.web.host=0.0.0.0
sonar.web.port=9000

EOF

# Required Linux settings
cat >> /etc/sysctl.conf <<EOF

vm.max_map_count=524288
fs.file-max=131072

EOF

sysctl -p

# SonarQube service
cat > /etc/systemd/system/sonarqube.service <<EOF

[Unit]
Description=SonarQube
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=always

LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target

EOF

# Start SonarQube
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

echo "SonarQube installation completed."
echo "Access: http://<SERVER-IP>:9000"
```
