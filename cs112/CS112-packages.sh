#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    ddd \
    valgrind \
    tsgl \
    bridges-cxx \
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
    && rm -rf /var/lib/apt/lists/*

# mpich alternatives
cat >/tmp/mpi-set-selections.txt <<EOL
mpi                            manual   /usr/bin/mpicc.mpich
mpirun                         manual   /usr/bin/mpirun.mpich
mpi-x86_64-linux-gnu           manual   /usr/include/x86_64-linux-gnu/mpich
EOL

/usr/bin/update-alternatives --set-selections < /tmp/mpi-set-selections.txt && \
    /usr/bin/update-alternatives --get-selections | grep mpi | grep -v mono && \
    rm -f /tmp/mpi-set-selections.txt

# openmpi configuration
cat >/etc/openmpi/openmpi-mca-params.conf << EOL
btl_base_warn_component_unused=0
rmaps_base_mapping_policy = node
plm_rsh_agent = rsh : ssh
opal_set_max_sys_limits = 1
rmaps_base_oversubscribe = 1
EOL