################################################################
#
#   To build:
#       docker build --progress=plain -t trick-dev-base:0.0.1 .
#

FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

# directories for installation scripts
ARG INSTALL_HOME=/system_admin/install 
ARG SETUP_HOME=/system_admin/setup

# home for all library installs (i.e. trick)
ARG LIBS_HOME=/home/sim_libs 

# specify the environment
ENV PYTHON_VERSION=3
ENV TRICK_HOME=$LIBS_HOME/trick

# configure the user 
ENV USERNAME=trick_user
ENV USERHOME=/home/$USERNAME
COPY setup/user.config $SETUP_HOME/
RUN $SETUP_HOME/user.config

# set main working directory for the build 
WORKDIR $USERHOME

# install dependencies from apt-get 
COPY install/apt-get.install $INSTALL_HOME/
RUN $INSTALL_HOME/apt-get.install

# install trick 
COPY install/trick.install $INSTALL_HOME/
RUN  $INSTALL_HOME/trick.install

COPY setup/image.config $SETUP_HOME/
RUN $SETUP_HOME/image.config

COPY entrypoint /home/$USERNAME/
ENTRYPOINT [ "entrypoint" ]

