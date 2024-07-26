#!/bin/bash

# NetLogo
apt update -y
apt install -y default-jdk netlogo
rm -rf /var/lib/apt/lists/*