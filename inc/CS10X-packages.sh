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
    && rm -rf /var/lib/apt/lists/*