FROM debian:jessie
MAINTAINER Philippe Pepiot <phil@philpep.org>

RUN apt-get -qqy update && apt-get -y install \
    apt-transport-https ca-certificates curl lxc iptables \
    openjdk-7-jre-headless sudo ssh \
    build-essential fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    ttf-dejavu wget zlib1g-dev \
    python python-dev python3-dev python3-virtualenv python-tox \
    python-setuptools python3-setuptools \
    python-pip python3-pip


# Docker
ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
RUN echo "deb https://get.docker.com/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get -qqy update && apt-get -y install lxc-docker aufs-tools
RUN chmod +x /usr/local/bin/wrapdocker

# PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main"
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -qqy update && apt-get -y install \
    postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4

# Vagrant
ADD https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.3_x86_64.deb /tmp/
RUN dpkg -i /tmp/vagrant_1.7.3_x86_64.deb

# Jenkins user
RUN useradd -m -s /bin/bash jenkins
RUN echo jenkins:jenkins | chpasswd
RUN adduser jenkins docker
RUN echo "jenkins ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
RUN mkdir -p /var/run/sshd

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/sbin/sshd", "-D"]
