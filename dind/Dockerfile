FROM philpep/jenkins:latest
MAINTAINER Philippe Pepiot <phil@philpep.org>

ADD https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker /usr/local/bin/wrapdocker
ADD https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.3_x86_64.deb /tmp/
RUN apt-get -qqy update && \
    apt-get -y install apt-transport-https ca-certificates curl lxc iptables && \
    echo "deb https://get.docker.com/ubuntu docker main" > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    apt-get -y install sudo lxc-docker aufs-tools

RUN dpkg -i /tmp/vagrant_1.7.3_x86_64.deb
RUN adduser jenkins docker
RUN chmod +x /usr/local/bin/wrapdocker

EXPOSE 22
VOLUME /var/lib/docker
CMD ["/usr/bin/sshd", "-D"]
