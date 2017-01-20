#!/bin/bash

set -e

BACKUP_DIR="config_bootstrap_backup"

pushd "$HOME/config" > /dev/null

git submodule update --init --recursive

# Config files.
FILES=(ackrc bash* gitconfig inputrc profile selected_editor tmux.conf xsession
       vim/vimrc vim/gvimrc vim/vundle.vim zsh*)

popd > /dev/null

create_backup_dir() {
  if [[ -e "$BACKUP_DIR" ]]; then
    echo "Error: backup directory $BACKUP_DIR already exists"
    return 1
  fi

  if ! mkdir "$BACKUP_DIR"; then
    echo "Error creating backup directory $BACKUP_DIR"
    return 2
  fi
}

back_up_files() {
  for file in "$@"; do
    if [[ (-f ".$file" || -d ".$file") && ! -L ".$file" ]]; then
      if ! cp -r ".$file" "${BACKUP_DIR}/.${file}"; then
        echo "Error backing up .$file"
        return 1
      fi
    fi
  done
}

if ! create_backup_dir; then
  exit 1
fi

if ! back_up_files "${FILES[@]}"; then
  exit 1
fi

for file in "${FILES[@]}"; do
  filename=$(basename "$file")
  ln -sfT ~/config/"$file" ".$filename"
done

# Vim.
back_up_files vim

ln -sfT ~/config/vim/vimfiles .vim
mkdir -p ~/.vimbackup/{swap,undo,backup}

# Vim - Vundle.
pushd ~/config/vim > /dev/null
if [[ ! -d vimfiles/bundle/Vundle.vim ]]; then
  git clone https://git@github.com/VundleVim/Vundle.vim vimfiles/bundle/Vundle.vim
fi
vim -u NONE -s vundle.vim +PluginInstall +qall

# Emacs.
back_up_files emacs.d emacs emacs-normal

ln -sfT ~/config/emacs .emacs.d
ln -sfT ~/config/emacs/.emacs .emacs
ln -sfT ~/config/emacs/.emacs-normal .emacs-normal

popd > /dev/null
