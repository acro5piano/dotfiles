FROM debian:wheezy

RUN echo "deb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/backports.list
RUN apt-get update
RUN apt-get -t wheezy-backports --yes install emacs24
