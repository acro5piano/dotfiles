FROM debian

RUN apt-get update
RUN apt-get -y install emacs

RUN useradd -G sudo -u 1000 emacs
RUN mkdir -p /home/emacs/host_home
RUN chown -R emacs:emacs /home/emacs

ENV HOME /home/emacs
WORKDIR /home/emacs

CMD /usr/bin/emacs --reverse