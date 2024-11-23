#! /bin/bash

sudo apt update
sudo apt install -y wget gnupg2 software-properties-common curl jq

sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt update

latest_lts_java_version=$(curl -s https://api.adoptium.net/v3/info/available_releases | jq -r '.most_recent_lts')
echo "Актуальна версія Java LTS: $latest_lts_java_version"

sudo apt install -y openjdk-$latest_lts_java_version-jdk

jenkins_key_page=$(curl -s https://pkg.jenkins.io/debian-stable/)
jenkins_key_url=$(echo "$jenkins_key_page" | grep -oP 'https://[^"]+jenkins.io-\d{4}.key' | head -1)

curl -fsSL $jenkins_key_url | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins


sudo apt-get -y update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker

sudo usermod -aG docker jenkins
sudo usermod -aG adm jenkins
sudo systemctl  restart jenkins


sudo mkdir /opt/mssql
sudo chmod 777 /opt/mssql/
