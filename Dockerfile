FROM debian:jessie
MAINTAINER Philippe Pepiot <phil@philpep.org>

RUN apt-get -qqy update && apt-get -y install \
    openjdk-7-jre-headless sudo ssh \
    build-essential curl fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    sudo ttf-dejavu wget zlib1g-dev postgresql-9.4 \
    python python-dev python3-dev python3-virtualenv python-tox \
    python-setuptools python3-setuptools
RUN useradd -m -s /bin/bash jenkins && \
    echo jenkins:jenkins | chpasswd

RUN mkdir -p /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
