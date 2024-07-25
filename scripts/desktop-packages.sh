#!/bin/bash

#### firefox
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla 
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y firefox
rm -rf /var/lib/apt/lists/*

#### google chrome
curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-chrome.list > /dev/null
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y google-chrome-stable
rm -rf /var/lib/apt/lists/*

# deal with chrome password store
sed -i 's+exec -a+exec -a "$0" "$HERE/chrome" "--password-store=basic" "$@"+g' /usr/bin/google-chrome-stable

#### VS Code
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoftprod.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoftprod.gpg] https://packages.microsoft.com/repos/code/ stable main" | tee -a /etc/apt/sources.list.d/vscode.list > /dev/null
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y code seahorse
rm -rf /var/lib/apt/lists/*