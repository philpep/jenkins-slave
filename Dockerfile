FROM debian:jessie
MAINTAINER Philippe Pepiot <phil@philpep.org>

ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
ADD https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.3_x86_64.deb /tmp/
RUN apt-get -qqy update && apt-get -y install \
    apt-transport-https ca-certificates curl lxc iptables \
    openjdk-7-jre-headless sudo ssh \
    build-essential curl fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    sudo ttf-dejavu wget zlib1g-dev postgresql-9.4 \
    python python-dev python3-dev python3-virtualenv python-tox \
    python-setuptools python3-setuptools
RUN echo "deb https://get.docker.com/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get -qqy update && apt-get -y install sudo lxc-docker aufs-tools

RUN dpkg -i /tmp/vagrant_1.7.3_x86_64.deb
RUN chmod +x /usr/local/bin/wrapdocker
RUN useradd -m -s /bin/bash jenkins
RUN echo jenkins:jenkins | chpasswd
RUN adduser jenkins docker
RUN mkdir -p /var/run/sshd

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/sbin/sshd", "-D"]
