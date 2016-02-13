set -e

pushd ~/config > /dev/null

git submodule update --init --recursive

# Config files.
FILES=(ackrc bash* gitconfig inputrc profile selected_editor tmux.conf xsession
vim/vimrc vim/gvimrc)

cd ..

for file in "${FILES[@]}"
do
  if [ -f ".$file" ]; then
    mv ".$file" ".${file}.bak"
  fi
  filename=$(basename "$file")
  ln -sfT ~/config/"$file" ".$filename"
done

# Vim.
if [ -d ~/.vim ]; then
  mv ~/.vim ~/.vim.bak
fi

ln -sfT ~/config/vim/vimfiles .vim
mkdir -p ~/.vimbackup/{swap,undo,backup}

# Vim - Vundle.
vim +PluginInstall +qall

# Emacs.
ln -sfT ~/config/emacs .emacs.d
ln -sf ~/config/emacs/.emacs .emacs
ln -sf ~/config/emacs/.emacs-normal .emacs-normal

popd > /dev/null
