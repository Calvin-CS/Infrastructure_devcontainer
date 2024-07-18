#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    dotnet-sdk-8.0 \
    dotnet-runtime-8.0 \
    && rm -rf /var/lib/apt/lists/*