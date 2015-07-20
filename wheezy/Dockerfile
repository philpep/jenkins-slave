FROM debian:wheezy
MAINTAINER Philippe Pepiot <phil@philpep.org>

RUN apt-get -qqy update && apt-get -y install \
    apt-transport-https ca-certificates curl \
    openjdk-7-jre-headless sudo ssh \
    build-essential fontconfig git libevent-dev \
    libfreetype6-dev libjpeg-dev libpng-dev libsmbclient-dev libssl-dev \
    libxml2-dev libxslt1-dev lsb-release pdftk pkg-config redis-server rsync \
    ttf-dejavu wget zlib1g-dev \
    python python-dev \
    python-setuptools \
    python-pip


RUN pip install 'tox>=1.8,<1.9'


# PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -qqy update && apt-get -y install \
    postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4
RUN service postgresql start && \
    su - postgres -c 'createuser -s jenkins; createdb -O jenkins jenkins'

# Jenkins user
RUN useradd -m -s /bin/bash jenkins
RUN echo jenkins:jenkins | chpasswd
RUN echo "jenkins ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
RUN mkdir -p /var/run/sshd

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/sbin/sshd", "-D"]
