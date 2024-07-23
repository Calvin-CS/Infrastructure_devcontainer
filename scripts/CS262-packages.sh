#!/bin/bash

# Google Cloud SDK
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# NodeJS 
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt update -y && \
    apt install -y nodejs && \
    /usr/bin/npm install -g npm && \
    /usr/bin/npm install -g express-generator && \
    /usr/bin/npm install -g express && \
    /usr/bin/npm install -g hot-server && \
    /usr/bin/npm install -g jslint && \
    /usr/bin/npm install -g stylus && \
    /usr/bin/npm install -g expo-cli && \
    /usr/bin/npm install -g expo/ngrok && \
    /usr/bin/npm install -g expo-dev-menu && \
    /usr/bin/npm install -g typescript && \
    /usr/bin/npm install -g @angular/cli && \
    rm -rf /var/lib/apt/lists/*

# PostgreSQL client
apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    postgresql-client \
    postgresql-client-common \
    && rm -rf /var/lib/apt/lists/*

# Azure CLI
curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash - && \
    apt update -y && \
    rm -rf /var/lib/apt/lists/*