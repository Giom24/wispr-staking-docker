FROM ubuntu:18.04

ARG USER="YOUR_USERNAME"
ARG PASS="YOUR_PASSWORD"
ARG HOME="/home/$USER"
ARG BRANCH="0.3.1"

ARG BUILD_PACKAGES="build-essential git autoconf automake autotools-dev pkg-config"
ARG WISPR_PACKAGES="libzmq5-dev libminiupnpc-dev libqrencode-dev libssl1.0-dev libgmp-dev libevent-dev libtool libdb4.8-dev libdb4.8++-dev libboost-all-dev bsdmainutils"
ARG UTILS_PACKAGES="sudo nano wget"

RUN apt-get update -y
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get upgrade -y
RUN apt-get -y install ${BUILD_PACKAGES} ${WISPR_PACKAGES} ${UTILS_PACKAGES}

RUN useradd -G sudo -ms /bin/bash $USER
RUN echo $USER:$PASS | chpasswd

USER $USER
WORKDIR $HOME
RUN git clone https://github.com/WisprProject/core.git
WORKDIR $HOME/core
RUN git checkout $BRANCH
RUN ./autogen.sh && ./configure && make -j $(grep -c "processor" /proc/cpuinfo)

USER root
RUN make install
RUN apt-get -y remove ${BUILD_PACKAGES}

COPY --chown=${USER}:${USER} ./unlock.sh $HOME/
RUN chmod +x $HOME/unlock.sh

USER $USER
RUN mkdir $HOME/.wispr/ && touch $HOME/.wispr/wispr.conf
WORKDIR $HOME/.wispr/
COPY --chown=${USER}:${USER} wallet.dat ./
RUN echo \
    "rpcusername=$(openssl rand -base64 32)\n\
    rpcpassword=$(openssl rand -base64 32)\n\
    maxconnection=16\n\
    daemon=1\n\
    enablezeromint=0"\
    >> wispr.conf;
RUN wget https://wispr.tech/nodes -O - >> wispr.conf;
WORKDIR $HOME
CMD "/usr/local/bin/wisprd"; "bash"