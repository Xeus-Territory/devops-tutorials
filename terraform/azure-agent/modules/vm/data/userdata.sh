#!/bin/bash

apt update && apt upgrade
apt install pass gnupg2 -y
apt install -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --identity
su -c "curl https://vstsagentpackage.azureedge.net/agent/2.214.1/vsts-agent-linux-x64-2.214.1.tar.gz --output /home/${user}/download.tar.gz" ${user}
su -c "cd /home/${user} && tar zxvf download.tar.gz && ./config.sh --unattended --url ${url} --auth ${auth} --token ${token} --pool ${pool} --agent ${agent} && ./run.sh &" ${user}

