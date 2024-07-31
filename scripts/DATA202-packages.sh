#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 \
    python3-pip \
    python3-tk \
    python3-venv \
    python3-cartopy \
    python3-matplotlib \
    python3-scipy \
    python3-gmplot \
    python3-icecream \
    python3-pil \
    python3-guizero \
    python3-pygame \
    python3-pgzero \
    python3-colorama \
    python3-bs4 \
    python3-pandas \
    python3-pexpect \
    cython3 \
    libtiff5-dev \
    libjpeg8-dev \
    libopenjp2-7-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    tcl8.6-dev \
    tk8.6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    python3-plotly \
    python3-sklearn-pandas \
    && rm -rf /var/lib/apt/lists/*

# install Astral Rye
curl -sSf https://rye.astral.sh/get | RYE_VERSION="latest" RYE_INSTALL_OPTION="--yes" RYE_HOME=/usr/local/rye RYE_TOOLCHAIN=/usr/bin/python3.12 RYE_TOOLCHAIN_VERSION=3.12 bash
cp /usr/local/rye/env /etc/profile.d/rye.sh
chmod 0755 /etc/profile.d/rye.sh