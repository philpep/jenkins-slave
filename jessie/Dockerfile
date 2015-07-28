FROM debian:jessie
MAINTAINER Philippe Pepiot <phil@philpep.org>

RUN apt-get -qqy update && apt-get -y install \
    apt-transport-https ca-certificates curl lxc iptables \
    openjdk-7-jre-headless sudo ssh locales \
    whois pwgen qemu-kvm gnuplot \
    build-essential fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    ttf-dejavu wget zlib1g-dev \
    python python-dev python3-dev \
    python-pip python3-pip

# Locales
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale && \
    echo "LANGUAGE=en_US:en" >> /etc/default/locale && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    update-locale

# Python
RUN pip install -U 'pip>=7,<8'
RUN pip install -U 'virtualenv>=13,<14' 'tox>=2,<3'

# Docker
ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN apt-get -qqy update && apt-get -y install docker-engine aufs-tools
RUN chmod +x /usr/local/bin/wrapdocker

# PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -qqy update && apt-get -y install \
    postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4
RUN service postgresql start && \
    su - postgres -c 'createuser -s jenkins; createdb -O jenkins jenkins'

# Vagrant
ADD https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb /tmp/
RUN dpkg -i /tmp/vagrant_1.7.4_x86_64.deb

# Jenkins user
RUN useradd -m -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/workspace && \
    chown jenkins:jenkins /home/jenkins/workspace && \
    mkdir -p /var/lib/docker/jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chown jenkins:jenkins /home/jenkins/.ssh && \
    mkdir -p /home/jenkins/.pip && \
    chown jenkins:jenkins /home/jenkins/.pip
RUN echo jenkins:jenkins | chpasswd
RUN adduser jenkins docker && \
    adduser jenkins kvm
RUN echo "jenkins ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
RUN chmod 440 /etc/sudoers.d/jenkins

# Tmpfs we divert because some old docker plugin version have usr/sbin/sshd hard-coded
RUN mkdir -p /var/run/sshd
RUN dpkg-divert --add --rename --divert /usr/sbin/sshd.real /usr/sbin/sshd
ADD wrapsshd /usr/sbin/sshd
RUN chmod +x /usr/sbin/sshd

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/sbin/sshd", "-D"]
