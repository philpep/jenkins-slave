Jenkins docker slaves
=====================

This [docker](https://www.docker.com/) [jenkins](https://jenkins-ci.org) slaves
images to be used with the awesome [jenkins docker
plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin>).

They are available in the
[philpep/jenkins-slave](https://registry.hub.docker.com/u/philpep/jenkins-slave/)
repository.

All the images run a [openssh](http://www.openssh.com) server, the jenkins
master can connect with the `jenkins` user (the password is `jenkins`). This
user can run any command as root using [sudo](http://www.sudo.ws).

The jenkins user is also a postgresql superuser. A basic build script for jenkins can be:

    sudo service postgresql start
    createdb test
    DBNAME=test ./runtests.sh


*WARNING*: Neither docker and the image is safe against malicious code, so
consider that any developer who can push code and trigger a build can take
control of your jenkins server. If you don't trust the developer, carefully
review the code before trigger a build.


philpep/jenkins-slave:jessie
----------------------------

Installation:

    docker pull philpep/jenkins-slave:jessie

This is a [debian](https://debian.org) jessie including:

  * [gcc](https://gcc.gnu.org/) 4.9
  * [Python](https://python.org) 2.7.9 and 3.4.2
  * [PostgreSQL](http://www.postgresql.org) 9.4
  * [redis](http://redis.io) 2.8
  * [pip](https://pip.pypa.io/en/stable/) 7.1
  * [virtualenv](https://virtualenv.pypa.io) 13.1
  * [tox](https://tox.readthedocs.org) 2.1
  * [docker](https://www.docker.com/) 1.8
  * [vagrant](https://www.vagrantup.com) 1.8

As you can see, this image can run docker in docker :)

![dind](http://dl.philpep.org/docker-meme.jpg)

This is convenient if your test/build process include docker or vagrant (or
both).

You will have to run container privileged (an option configure in jenkins
Docker Template) and start docker within the build script.

    sudo wrapdocker true
    [...]

You are advised to use a [docker registry
mirror](https://docs.docker.com/articles/registry_mirror/) to save bandwidth
while pulling images.

    sudo DOCKER_DAEMON_ARGS="--registry-mirror=http://mirror:5000" wrapdocker true
    [...]


For optimal performance, if you have a slow disks but a lot of RAM, you can run docker on tmpfs:

    sudo mount -t tmpfs -o size=3G tmpfs /var/lib/docker
    sudo wrapdocker true
    [...]


philpep/jenkins-slave:wheezy
----------------------------

Installation:

    docker pull philpep/jenkins-slave:wheezy

This is a [debian](https://debian.org) jessie including:

  * [gcc](https://gcc.gnu.org/) 4.7
  * [Python](https://python.org) 2.7.3
  * [PostgreSQL](http://www.postgresql.org) 9.4
  * [redis](http://redis.io) 2.4
  * [pip](https://pip.pypa.io/en/stable/) 7.1
  * [virtualenv](https://virtualenv.pypa.io) 13.1
  * [tox](https://tox.readthedocs.org) 2.1


philpep/jenkins-slave:wheezy32
------------------------------

Same as `philpep/jenkins-slave:wheezy` but in i386 architecture.
