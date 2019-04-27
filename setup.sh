#!/bin/bash

mkdir -p $HOME/.config
for path in $(find . -print | grep '\.\/\.[a-zA-Z0-9]*' | grep -ve 'git'); do
  if [ -d "${path}" ]; then
    mkdir -p $HOME/$path
  elif [ -f "${path}" ]; then
    rm -rf $HOME/$path
    ln -s $path $HOME/$path
  fi
done

if [[ -z $(which antibody) ]]; then
  curl -sL git.io/antibody | sh -s
  antibody bundle < ~/.zsh_plugins.txt > $HOME/.zsh_plugins.sh
fi

if [ ! -d $HOME/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
fi

if [ ! -f $HOME/.vim/autoload/pathogen.vim ]; then
  mkdir -p "$HOME/.vim/autoload"
  curl "https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim" \
    -o "$HOME/.vim/autoload/pathogen.vim" 
fi
