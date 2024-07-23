FROM ubuntu:noble
LABEL maintainer="Chris Wieringa <cwieri39@calvin.edu>"

# Set versions and platforms
ARG BUILDDATE=20240717-1
ARG TZ=America/Detroit

# Do all run commands with bash
SHELL ["/bin/bash", "-c"] 

##################################
## Start with base Ubuntu
##################################

# Start with some base packages and APT setup
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    gpg \
    locales \
    nano \
    software-properties-common \
    tar \
    tofrodos \
    unzip \
    vim \
    vim-nox \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Calvin cpscadmin repo keys
RUN echo "deb [signed-by=/usr/share/keyrings/csrepo.gpg] http://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/ noble main" | tee -a /etc/apt/sources.list.d/cs-ubuntu-software-noble.list && \
    curl https://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/csrepo.asc | tee /tmp/csrepo.asc && \
    gpg --dearmor /tmp/csrepo.asc && \
    mv /tmp/csrepo.asc.gpg /usr/share/keyrings/csrepo.gpg && \
    rm -f /tmp/csrepo.asc

# microsoft vs code cli - only cli install
# RUN curl -fsSL https://code.visualstudio.com/sha/download?build=stable\&os=cli-alpine-x64 | tar zxfv - -C/usr/local/bin && \
#    chmod 0775 /usr/local/bin/code

##################################
## Container configuration
##################################

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone

# Add CalvinAD trusted root certificate
ADD https://raw.githubusercontent.com/Calvin-CS/Infrastructure_configs/main/auth/CalvinCollege-ad-CA.crt /etc/ssl/certs/
RUN chmod 0644 /etc/ssl/certs/CalvinCollege-ad-CA.crt && \
    ln -s -f /etc/ssl/certs/CalvinCollege-ad-CA.crt /etc/ssl/certs/ddbc78f4.0

# Add a /scripts directory for class includes
RUN mkdir -p /scripts

# Locale and Environment configuration
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV TZ=${TZ}

##################################
## Calvin CS course requirements
##################################
# CS112
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS112-packages.sh /scripts/CS112-packages.sh
RUN /scripts/CS112-packages.sh

# Cleanup misc files
RUN rm -f /var/log/*.log && \
    rm -f /var/log/apt/* && \
    rm -f /var/log/faillog

##################################
## Final Container settings
##################################
USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT [ "/usr/bin/bash", "-l" ]