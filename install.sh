#!/bin/bash

dir=~/dotfiles
backup=~/dotfiles_backup
files=".aliases .zshrc .emacs.d .vimrc .tmux.conf"

echo "Creating backup directory"
mkdir -p $backup

for file in $files; do
  if [ -a ~/$file ]; then
    mv ~/$file $backup
  fi
  echo "Creating symlink for $file"
  ln -s $dir/$file ~/$file
done

echo "Done"
