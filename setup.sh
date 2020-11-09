#!/usr/bin/env bash
PACK_DIR=~/.vim/pack/dev/start

echo "ensuring ~/.vim/ exists"
mkdir -p "${PACK_DIR}" 2>/dev/null

echo "Adding packages"
declare -A PACKAGES
PACKAGES=(
    ["vim-fugitive"]="tpope"
    ["vim-rhubarb"]="tpope"
    ["vim-surround"]="tpope"
    ["vim-commentary"]="tpope"
    ["fzf.vim"]="junegunn"
    ["ultisnips"]="SirVer"
    ["vim-highlightedyank"]="machakann"
    ["vimwiki"]="vimwiki"

    # Rust
    ["rust.vim"]="rust-lang"
    ["vim-racer"]="racer-rust"
    ["vim-vebugger"]="hagsteel"
    ["vimproc.vim"]="Shougo"
    # ["completor.vim"]="maralla"
)

for package in ${!PACKAGES[@]}
do
    if [[ $1 == "--update" ]]
    then
        echo "$package:"
        (cd ${PACK_DIR}/$package 2>/dev/null && git pull 2>/dev/null)
    else
        echo " --- Downloading: $package"
        git clone https://github.com/${PACKAGES[$package]}/$package.git ${PACK_DIR}/$package 2>/dev/null
        if [[ $? == 128 ]]
        then
            echo "$package already installed"
        elif [[ $? > 2 ]]
        then
            echo "Failed to install $package"
        fi
        echo 
    fi
done

echo "Building vimproc"
echo "-----------------"
(cd ${PACK_DIR}/vimproc.vim && make)
echo ""

# echo "Setup language client"
# echo "-----------------"
# (cd ${PACK_DIR}/LanguageClient-neovim && ./install.sh)
# echo ""

echo "Creating symlinks"
echo "-----------------"
AFTER_LINK_FROM=`pwd`/after 
AFTER_LINK_TO=~/.vim/after 

ULTISNIPS_LINK_FROM=`pwd`/UltiSnips 
ULTISNIPS_LINK_TO=~/.vim/UltiSnips 

VIMRC_LINK_FROM=`pwd`/vimrc 
VIMRC_LINK_TO=~/.vimrc 

COLORS_LINK_FROM=`pwd`/colors 
COLORS_LINK_TO=~/.vim/colors

if [ ! \( -e "$AFTER_LINK_TO" \) ]
then
    echo "Creating symlink to \"after\""
    ln -sf $AFTER_LINK_FROM $AFTER_LINK_TO
else
    echo "\"after\" already exists, skipping"
fi

if [ ! \( -e "$ULTISNIPS_LINK_TO" \) ]
then
    echo "Creating symlink to \"UltiSnips\""
    ln -sf $ULTISNIPS_LINK_FROM $ULTISNIPS_LINK_TO
else
    echo "\"UltiSnips\" already exists, skipping"
fi

if [ ! \( -e "$VIMRC_LINK_TO" \) ]
then
    echo "Creating symlink to \"vimrc\""
    ln -sf $VIMRC_LINK_FROM $VIMRC_LINK_TO
else
    echo "\"vimrc\" already exists, skipping"
fi

if [ ! \( -e "$COLORS_LINK_TO" \) ]
then
    echo "Creating symlink to \"colors\""
    ln -sf $COLORS_LINK_FROM $COLORS_LINK_TO
else
    echo "\"colors\" already exists, skipping"
fi

vim -c ":helptags ALL" -c ":q!"
echo 
echo "DONE! Helptags generated"
echo
