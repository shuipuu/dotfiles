#!/bin/bash

# rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv

# vim plugin
mkdir -p vim/bundle
git clone https://github.com/Shougo/neobundle.vim vim/bundle/neobundle

# zsh plugin
mkdir -p zsh/zsh_plugin
git clone https://github.com/zsh-users/zaw.git zsh/zsh_plugin/zaw
git clone https://github.com/zsh-users/zsh-completions.git zsh/zsh_plugin/zsh-completions

# dircolors
git clone https://github.com/seebi/dircolors-solarized.git

# iterm2's scheme
curl -o JetBrains_Darcula.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/JetBrains%20Darcula.itermcolors

ln -s ~/dotfiles/ctags ~/.ctags
ln -s ~/dotfiles/gemrc ~/.gemrc
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore_global
ln -s ~/dotfiles/screenrc ~/.screenrc
ln -s ~/dotfiles/ssh_config ~/.ssh/config
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/zprofile ~/.zprofile
ln -s ~/dotfiles/zshrc ~/.zshrc

chmod 600 ~/.ssh/config

