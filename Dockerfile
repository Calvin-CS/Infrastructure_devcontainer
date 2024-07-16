FROM ubuntu:noble
LABEL maintainer="Chris Wieringa <cwieri39@calvin.edu>"

# Set versions and platforms
ARG BUILDDATE=20240716-1
ARG TZ=America/Detroit
ARG NODEJSVERSION=20

# Do all run commands with bash
SHELL ["/bin/bash", "-c"] 

######### Start with base Ubuntu
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
    software-properties-common \
    tar \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install cpscadmin repo keys
RUN echo "deb [signed-by=/usr/share/keyrings/csrepo.gpg] http://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/ noble main" | tee -a /etc/apt/sources.list.d/cs-ubuntu-software-noble.list && \
    curl https://cpscadmin.cs.calvin.edu/repos/cpsc-ubuntu/csrepo.asc | tee /tmp/csrepo.asc && \
    gpg --dearmor /tmp/csrepo.asc && \
    mv /tmp/csrepo.asc.gpg /usr/share/keyrings/csrepo.gpg && \
    rm -f /tmp/csrepo.asc

######### Container configuration
# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone

# add CalvinAD trusted root certificate
ADD https://raw.githubusercontent.com/Calvin-CS/Infrastructure_configs/main/auth/CalvinCollege-ad-CA.crt /etc/ssl/certs/
RUN chmod 0644 /etc/ssl/certs/CalvinCollege-ad-CA.crt && \
    ln -s -f /etc/ssl/certs/CalvinCollege-ad-CA.crt /etc/ssl/certs/ddbc78f4.0

# Locale and Environment configuration --------------------------------------------------------#
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV TZ=${TZ}

######### Calvin CS course requirements
# CS10X
RUN apt update -y && \
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
    # Finish up
    && rm -rf /var/lib/apt/lists/*

# CS112
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    ddd \
    valgrind \
    tsgl \
    bridges-cxx \
    # Finish up
    && rm -rf /var/lib/apt/lists/*

# CS212
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    dotnet-sdk-8.0 \
    dotnet-runtime-8.0 \
    # Finish up
    && rm -rf /var/lib/apt/lists/*

# CS214
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    # - Ada
    gnat-14 \
    # - Clojure
    clojure \
    rlwrap \
    openjfx \
    libcore-async-clojure \
    # - Elisp and emacs
    emacs-el \
    emacs \
    emacs-goodies-el \
    # - Java
    default-jdk-headless \
    # - Ruby
    ruby-full \
    # Finish up
    && rm -rf /var/lib/apt/lists/*

# Other packages and libraries
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    # - Maven
    maven \
    # - C++ libraries
    mpich \
    libmpich-dev \
    libmpich12 \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev \
    rsh-redone-client \
    libgomp1 \
    libomp5 \
    libomp-dev \
    # - Misc Utilities
    tofrodos \
    zip \
    unzip \
    # - Editors
    nano \
    vim \
    vim-nox \
    # Finish up
    && rm -rf /var/lib/apt/lists/*

# clojure misc configuration
COPY --chmod=0755 inc/clojure-classpath.sh /etc/profile.d/clojure-classpath.sh
RUN ln -s /etc/alternatives/clojure /usr/bin/clj 

# Google Cloud SDK
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# microsoft vs code cli - only cli install
RUN curl -fsSL https://code.visualstudio.com/sha/download?build=stable\&os=cli-alpine-x64 | tar zxfv - -C/usr/local/bin && \
   chmod 0775 /usr/local/bin/code

# mpich alternatives
COPY inc/mpi-set-selections.txt /tmp/mpi-set-selections.txt
RUN /usr/bin/update-alternatives --set-selections < /tmp/mpi-set-selections.txt && \
    /usr/bin/update-alternatives --get-selections | grep mpi | grep -v mono && \
    rm -f /tmp/mpi-set-selections.txt

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_${NODEJSVERSION}.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs && \
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

# openmpi configuration
COPY --chmod=0644 inc/openmpi-mca-params.conf /etc/openmpi/openmpi-mca-params.conf

# swi-prolog
RUN apt-add-repository -y ppa:swi-prolog/stable && \
    apt-get update -y && \
    apt-get install -y swi-prolog && \
    rm -rf /var/lib/apt/lists/*

# Cleanup misc files
RUN rm -f /var/log/*.log && \
    rm -f /var/log/faillog

######## Final Container settings
USER ubuntu
WORKDIR /home/ubuntu
CMD '/bin/bash'