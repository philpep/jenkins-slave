FROM debian:jessie
MAINTAINER Philippe Pepiot <phil@philpep.org>

RUN printf 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";\n' > /etc/apt/apt.conf.d/no-recommands

RUN apt-get -qqy update && apt-get -y install \
    apt-transport-https ca-certificates curl lxc iptables \
    openjdk-7-jre-headless sudo ssh locales \
    whois pwgen qemu-kvm gnuplot rst2pdf pdftk \
    build-essential fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    ttf-dejavu wget zlib1g-dev \
    python python-dev python3-dev \
    python-pip python3-pip \
    texlive-latex-recommended texlive-latex-extra \
    texlive-fonts-recommended texlive-lang-french dvidvi

# Locales
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale && \
    echo "LANGUAGE=en_US:en" >> /etc/default/locale && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    update-locale

# Python
RUN pip install -U 'pip>=7,<8' && \
    pip install -U 'virtualenv>=13,<14' 'tox>=2,<3' && \
    rm -rf /root/.cache/pip

# Docker
ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    apt-get -qqy update && apt-get -y install docker-engine aufs-tools && \
    chmod +x /usr/local/bin/wrapdocker

# PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get -qqy update && apt-get -y install \
    postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4 && \
    service postgresql start && \
    su - postgres -c 'createuser -s jenkins; createdb -O jenkins jenkins'

# Vagrant
RUN wget -q https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb && \
    dpkg -i vagrant_1.7.4_x86_64.deb && \
    rm vagrant_1.7.4_x86_64.deb

# Jenkins user
RUN useradd -m -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/workspace && \
    chown jenkins:jenkins /home/jenkins/workspace && \
    mkdir -p /var/lib/docker/jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chown jenkins:jenkins /home/jenkins/.ssh && \
    mkdir -p /home/jenkins/.pip && \
    chown jenkins:jenkins /home/jenkins/.pip && \
    echo jenkins:jenkins | chpasswd && \
    adduser jenkins docker && \
    adduser jenkins kvm && \
    echo "jenkins ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/jenkins && \
    chmod 440 /etc/sudoers.d/jenkins

# Tmpfs: we divert because some old docker plugin version have /usr/sbin/sshd hard-coded
RUN mkdir -p /var/run/sshd && \
    dpkg-divert --add --rename --divert /usr/sbin/sshd.real /usr/sbin/sshd
ADD wrapsshd /usr/sbin/sshd
RUN chmod +x /usr/sbin/sshd

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/sbin/sshd", "-D"]
