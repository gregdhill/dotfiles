#!/bin/bash

mkdir -p $HOME/.config
for path in $(find -printf '%P\n' | grep -vE 'git|setup'); do
  if [ -d "${path}" ]; then
    mkdir -p $HOME/$path
  elif [ -f "${path}" ]; then
    rm -rf $HOME/$path
    ln -s `pwd`/$path $HOME/$path
  fi
done

if [[ -z $(which antibody) ]]; then
  curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
fi

antibody bundle < ~/.zsh_plugins.txt > $HOME/.zsh_plugins.sh

if [ ! -d $HOME/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
fi

if [ ! -f $HOME/.vim/autoload/pathogen.vim ]; then
  mkdir -p "$HOME/.vim/autoload"
  curl "https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
    -o "$HOME/.vim/autoload/pathogen.vim" 
fi
