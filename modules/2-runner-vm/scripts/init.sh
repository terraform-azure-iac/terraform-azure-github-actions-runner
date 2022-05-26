#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# GitHub Actions Token passed from root variables.tf
export GITHUB_TOKEN="${github_token}"
# Webhook url pased from root variables.tf
export WEBHOOK_URL="${webhook_url}"

su - runner-admin -c "sudo DEBIAN_FRONTEND=noninteractive apt-get update -y"
su - runner-admin -c "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y"

# install dependencies
su - runner-admin -c "sudo apt-get install -y  \
      curl \
      sudo \
      git \
      tar \
      unzip \
      zip \
      wget \
      apt-transport-https \
      ca-certificates \
      software-properties-common \
      make \
      jq \
      gnupg2 \
      openssh-client"

# docker
su - runner-admin -c "sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release"

su - runner-admin -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"

su - runner-admin -c "echo \
  'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"

su - runner-admin -c "sudo apt-get update"
su - runner-admin -c "sudo apt-get install docker-ce docker-ce-cli containerd.io -y"

su - runner-admin -c "sudo usermod -aG docker runner-admin"  

su - runner-admin -c "sudo systemctl enable docker.service"
su - runner-admin -c "sudo systemctl enable containerd.service"


# Install latest docker-compose from releases
su - runner-admin -c "URL='https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64'"
su - runner-admin -c "sudo curl -L $URL -o /usr/local/bin/docker-compose"
su - runner-admin -c "sudo chmod +x /usr/local/bin/docker-compose"

## node and npm
su - runner-admin -c "curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -"
su - runner-admin -c "sudo apt-get install -y nodejs"

# azure cli                                                       
su - runner-admin -c "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash" 

# powershell
# Update the list of packages
su - runner-admin -c "sudo apt-get update"
# Install pre-requisite packages.
su - runner-admin -c "sudo apt-get install -y wget apt-transport-https software-properties-common"
# Download the Microsoft repository GPG keys
su - runner-admin -c "wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb"
# Register the Microsoft repository GPG keys
su - runner-admin -c "sudo dpkg -i packages-microsoft-prod.deb"
# Update the list of packages after we added packages.microsoft.com
su - runner-admin -c "sudo apt-get update"
# Install PowerShell
su - runner-admin -c "sudo apt-get install -y powershell"

# terraform
su - runner-admin -c "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -"
su - runner-admin -c "sudo apt-add-repository 'deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main'"
su - runner-admin -c "sudo apt install terraform"

# Git Runner
su - runner-admin -c "mkdir actions-runner"
su - runner-admin -c "cd actions-runner"

# Download and install GitHub Actions runner software
su - runner-admin -c "curl -o actions-runner-linux-x64-2.287.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.287.1/actions-runner-linux-x64-2.287.1.tar.gz"
su - runner-admin -c "tar xzf ./actions-runner-linux-x64-2.287.1.tar.gz"
su - runner-admin -c "./config.sh --url https://github.com/secure-and-compliant-iac --token $GITHUB_TOKEN --name pipeline-runner --work _work --runnergroup Default  --unattended --replace"

su - runner-admin -c "sudo ./svc.sh install"
su - runner-admin -c "sudo ./svc.sh start"
su - runner-admin -c "sudo ./svc.sh status"


## Webhook
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"GitHub Actions Runner is up\"}" $WEBHOOK_URL