#!/bin/bash


DOTFILES_BACKUP_DIR=~/.dotfiles.bak


install_packages() {
    printf "${BOLD}Installing packages.${NORMAL}\n"
    sudo apt-get update
    sudo apt-get install -y \
        cmake \
        curl \
        fonts-powerline \
        git \
        locales \
        neovim \
        python-dev python-pip python3-dev python3-pip \
        tmux \
        xclip \
        zsh

    pip install --user neovim
    pip3 install --user neovim

    # Prevent the cloned repository from having insecure permissions. Failing to do
    # so causes compinit() calls to fail with "command not found: compdef" errors
    # for users with insecure umasks (e.g., "002", allowing group writability).
    umask g-w,o-w
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh || {
        printf "${BOLD}Error: git clone of oh-my-zsh repo failed${NORMAL}\n"
        exit 1
    }

    # If this user's login shell is not already "zsh", attempt to switch.
    TEST_CURRENT_SHELL=$(basename "$SHELL")
    if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
        # If this platform provides a "chsh" command (not Cygwin), do it, man!
        if hash chsh >/dev/null 2>&1; then
            printf "${BLUE}Time to change your default shell to zsh!${NORMAL}\n"
            chsh -s $(grep /zsh$ /etc/shells | tail -1)
            # Else, suggest the user do so manually.
        else
            printf "I can't change your shell automatically because this system does not have chsh.\n"
            printf "${BLUE}Please manually change your default shell to zsh!${NORMAL}\n"
        fi
    fi
}


setup_dotfiles() (
    local dotfiles=(
        ".config/nvim"
        ".gitconfig"
        ".gitignore"
        ".ideavimrc"
        ".parallel"
        ".pylintrc"
        ".tmux.conf"
        ".zshenv"
        ".zshrc"
    )

    backup_exisiting_dotfiles() {
        backup_file() {
            [ -z "$1" ] && return 1
            local file=$1
            [ -e file ] && backup_file $file
            mv $file $file.bak
        }

        [ -e $DOTFILES_BACKUP_DIR ] && backup_file $DOTFILES_BACKUP_DIR
        mkdir $DOTFILES_BACKUP_DIR
        for filename in ${dotfiles[*]}; do
            local dir=$(dirname $filename)
            mkdir -p $dir
            [ -e ~/$filename ] && mv ~/$filename $DOTFILES_BACKUP_DIR/$dir
        done
    }

    write_dotfiles() {
        cd dotfiles
        for filename in ${dotfiles[*]}; do
            cp --parent -r $filename ~
        done
        cd ..
    }

    backup_exisiting_dotfiles
    write_dotfiles
)


config_neovim() {
    mkdir -p ~/.local/share/nvim/backup

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall

    printf "${BOLD}Update alternatives for editor.${NORMAL}\n"
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
}


config_git() (
    printf "${BOLD}Configure Git.${NORMAL}\n"
    read -p "Email: " email
    read -p "Name: " name

    git config --global user.name $name
    git config --global user.email $email
)


main() {
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        RED="$(tput setaf 1)"
        GREEN="$(tput setaf 2)"
        YELLOW="$(tput setaf 3)"
        BLUE="$(tput setaf 4)"
        BOLD="$(tput bold)"
        NORMAL="$(tput sgr0)"
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        NORMAL=""
    fi

    install_packages
    setup_dotfiles
    config_neovim
    config_git
}


main
