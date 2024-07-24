FROM ubuntu:noble
LABEL maintainer="Chris Wieringa <cwieri39@calvin.edu>"

# Set versions and platforms
ARG BUILDDATE=20240724-1
ARG TZ=America/Detroit
ARG USER=ubuntu

ARG TURBOVNC_VERSION=3.1.1
ARG VIRTUALGL_VERSION=3.1.1
ARG LIBJPEG_VERSION=3.0.3
ARG NO_VNC_VERSION=1.2.0
ARG WEBSOCKIFY_VERSION=0.12.0

ARG VNC_ROOT_DIR=/opt/vnc

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
    lsb-release \
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


##################################
## Calvin CS course requirements
##################################
# CS10X
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS10X-packages.sh /scripts/CS10X-packages.sh
RUN /scripts/CS10X-packages.sh

# CS112
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS112-packages.sh /scripts/CS112-packages.sh
RUN /scripts/CS112-packages.sh

# CS212
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS212-packages.sh /scripts/CS212-packages.sh
RUN /scripts/CS212-packages.sh

# CS214
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS214-packages.sh /scripts/CS214-packages.sh
RUN /scripts/CS214-packages.sh

# CS262
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/scripts/CS262-packages.sh /scripts/CS262-packages.sh
RUN /scripts/CS262-packages.sh

##################################
## Container configuration for GUI
##  -- based from https://github.com/coder/enterprise-images/tree/main/deprecated/vnc
##################################

# Start with some extra desktop packages and APT setup
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    supervisor \
    xorg \
    ssh \
    xfce4 \
    xfce4-goodies \
    x11-apps \
    dbus-x11 \
    xterm \
    firefox \
    fonts-lyx \
    libxtst6 \
    libxv1 \
    libglu1-mesa \
    libc6-dev \
    libglu1 \
    libsm6 \
    libxv1 \
    x11-xkb-utils \
    xauth \
    xfonts-base \
    xkb-data \
    && rm -rf /var/lib/apt/lists/*

# Install quality of life packages.
RUN yes | unminimize

# Remove packages which may not behave well in a VNC environment.
RUN apt update -y && \
  DEBIAN_FRONTEND=noninteractive apt remove -y \
  xfce4-battery-plugin \
  xfce4-power-manager-plugins \
  xfce4-pulseaudio-plugin \
  light-locker \
  && rm -rf /var/lib/apt/lists/*

# Install and Configure TurboVNC
ADD --chmod=0644 https://github.com/TurboVNC/turbovnc/releases/download/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb /tmp/turbovnc_${TURBOVNC_VERSION}_amd64.deb
ADD --chmod=0644 https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb /tmp/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb
ADD --chmod=0644 https://github.com/VirtualGL/virtualgl/releases/download/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb /tmp/virtualgl_${VIRTUALGL_VERSION}_amd64.deb

RUN cd /tmp && \
    apt install -y ./turbovnc_${TURBOVNC_VERSION}_amd64.deb ./libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb ./virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

RUN ln -s /opt/TurboVNC/bin/* /opt/VirtualGL/bin/* /usr/local/bin/

# Configure VGL for use in a single user environment.
# This may trigger a warning about display managers needing to be restarted.
# This can be ignored as the VNC server manages this lifecycle.  
RUN vglserver_config -config +s +f +t
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/turbovncserver-security.conf /etc/turbovncserver-security.conf

# Set ENVIRONMENT VARIABLES needed for the next set of files
ENV VNC_SCRIPTS=$VNC_ROOT_DIR/scripts \
  VNC_SETUP_SCRIPTS=$VNC_ROOT_DIR/setup \
  VNC_LOG_DIR=/tmp/.vnc/log \
  VNC_XSTARTUP=$VNC_ROOT_DIR/xstartup \
  VNC_PORT=5990 \
  VNC_DISPLAY_ID=:90 \
  VNC_COL_DEPTH=24 \
  VNC_RESOLUTION=3840x2160 \
  NO_VNC_HOME=$VNC_ROOT_DIR/noVNC \
  NO_VNC_PORT=6081 \
  XFCE_BASE_DIR=$VNC_ROOT_DIR/xfce4 \
  XFCE_DEST_DIR=/home/${USER}/.config/xfce4 \
  SUPERVISORD_USER=${USER} \
  SUPERVISORD_HOME=/home/${USER}

# Add required files
# XFCE4 settings
RUN mkdir -p ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml && \
    chmod 0755 ${XFCE_BASE_DIR} ${XFCE_BASE_DIR}/xfconf ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/helpers.rc ${XFCE_BASE_DIR}/helpers.rc
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/coder-bg.jpg ${XFCE_BASE_DIR}/coder-bg.jpg
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/xfconf/xfce-perchannel-xml/displays.xml ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/displays.xml
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/xfwm4.xml
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/xsettings.xml
RUN sed -i "s+%%BGLOCATION%%+${XFCE_BASE_DIR}+g" ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/displays.xml && \
    sed -i "s+%%BGLOCATION%%+${XFCE_BASE_DIR}+g" ${XFCE_BASE_DIR}/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

# VNC settings
RUN mkdir -p ${VNC_ROOT_DIR}/scripts ${VNC_ROOT_DIR}/setup && \
    chmod 0755 ${VNC_ROOT_DIR} ${VNC_ROOT_DIR}/scripts ${VNC_ROOT_DIR}/setup
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/vnc/index.html ${VNC_ROOT_DIR}/index.html
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/vnc/xstartup ${VNC_ROOT_DIR}/xstartup
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/vnc/scripts/vncserver.sh ${VNC_ROOT_DIR}/scripts/vncserver.sh
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/vnc/setup/set_user_permission.sh ${VNC_ROOT_DIR}/setup/set_user_permission.sh

# Supervisor settings
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/supervisor/conf.d/novnc.conf /etc/supervisor/conf.d/novnc.conf
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/supervisor/conf.d/vncserver.conf /etc/supervisor/conf.d/vncserver.conf

# Install NoVNC and configure
RUN mkdir -p ${NO_VNC_HOME}/utils/websockify && \
    chmod 0755 ${NO_VNC_HOME}/utils/websockify && \
    wget -qO- https://github.com/novnc/noVNC/archive/v${NO_VNC_VERSION}.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME}/ && \
    wget -qO- https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME}/utils/websockify && \
    chmod +x -v ${NO_VNC_HOME}/utils/*.sh && \
    # custom index file
    ln -s ${VNC_ROOT_DIR}/index.html ${NO_VNC_HOME}/index.html

# Set user permissions
RUN ${VNC_SETUP_SCRIPTS}/set_user_permission.sh $VNC_ROOT_DIR

##################################
## Add Coder configuration
##################################
RUN mkdir -p /coder/apps
ADD --chmod=0755 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/coder/configure /coder/configure
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/coder/apps/config.yaml /coder/apps/config.yaml
ADD --chmod=0644 https://raw.githubusercontent.com/Calvin-CS/Infrastructure_devcontainer/main/files/coder/apps/desktop.png /coder/apps/desktop.png

##################################
## Final Container settings
##################################

# Cleanup misc files
RUN rm -f /var/log/*.log && \
    rm -f /var/log/apt/* && \
    rm -f /var/log/faillog

# Locale and Environment configuration
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV TZ=${TZ}

USER ${USER}
WORKDIR /home/${USER}
ENTRYPOINT [ "/usr/bin/bash", "-l" ]

EXPOSE $NO_VNC_PORT