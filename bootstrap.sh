set -e

pushd ~/config > /dev/null

git submodule update --init --recursive

cd ..

# Config files.
FILES=(ackrc bash* gitconfig inputrc profile selected_editor tmux.conf xsession)
for file in "${FILES[@]}"
do
  ln -sfT ~/config/"$file" ".$file"
done

# Vim.
FILES=(~/config/vim/_vimrc ~/config/vim/_gvimrc)
for file in "${FILES[@]}"
do
  ln -sf $file .
done

ln -sfT ~/config/vim/vimfiles .vim
mkdir -p ~/.vimbackup/{swap,undo,backup}

# Vim - Vundle.
vim +PluginInstall +qall

# Emacs.
ln -sfT ~/config/emacs .emacs.d
ln -sf ~/config/emacs/.emacs .emacs
ln -sf ~/config/emacs/.emacs-normal .emacs-normal

popd > /dev/null
