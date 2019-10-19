FROM ubuntu

WORKDIR /dotfiles

COPY . /dotfiles

RUN apt-get update && apt-get upgrade -y && apt-get install -y sudo locales && \
        localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

CMD cd /dotfiles; ./install.sh; zsh
