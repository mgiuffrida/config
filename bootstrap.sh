set -e

pushd ~/config > /dev/null

git submodule update --init --recursive

# Config files.
FILES=(ackrc bash* gitconfig inputrc profile selected_editor tmux.conf xsession
vim/vimrc vim/gvimrc)

cd ..

back_up_files() {
  for file in "$@"; do
    if [[ (-f ".$file" || -d ".$file") && ! -L ".$file" ]]; then
      mv ".$file" ".${file}.bak"
    fi
  done
}

back_up_files "${FILES[@]}"
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
mkdir -p vimfiles/bundle/Vundle.vim
trash vimfiles/bundle/Vundle.vim
git clone https://git@github.com/VundleVim/Vundle.vim vimfiles/bundle/Vundle.vim
vim +PluginInstall +qall
popd > /dev/null

# Emacs.
back_up_files emacs.d emacs emacs-normal

ln -sfT ~/config/emacs .emacs.d
ln -sfT ~/config/emacs/.emacs .emacs
ln -sfT ~/config/emacs/.emacs-normal .emacs-normal

popd > /dev/null
