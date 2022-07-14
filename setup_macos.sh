#! /usr/bin/env zsh

if [ "$(uname)" != "Darwin" ]
then
    echo "Aborting. These dotfiles are meant to be running on macOS"
    exit 1
fi

echo "Test echo"

REPO_NAME=".files"
CURRENT_PATH=$(pwd)
DOTFILES_PATH="${CURRENT_PATH}/${REPO_NAME}"
DOTFILES_PATH="${DOTFILES_PATH}/dotfiles"

# Install applications
if [ ! -f "$(which brew)" ]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

CLI_BREWS=(
    git
    htop
    neovim
    nvm
    python3
    wget
    z
)

APP_BREWS=(
    1password
    firefox
    github
    google-chrome
    iterm2
    pycharm-edu
    microsoft-teams
    visual-studio-code
)

brew install $CLI_BREWS
brew install --cask $APP_BREWS

if [[ ! "$(echo $SHELL)" == "/bin/zsh" && ! "$(echo $SHELL)" == "/usr/bin/zsh" ]]
then
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

compaudit | xargs chmod g-w

# Setup
mkdir "~/5minds"
mkdir "~/.ssh"

git clone https://github.com/5minds/Education.Basics.Dotfiles.git $REPO_NAME
git config --global core.excludesfile '~/.gitignore'
git config --global pull.rebase true

code --install-extension editorconfig.editorconfig
code --install-extension shardulm94.trailing-spaces
code --install-extension stkb.rewrap

ln -sf "${DOTFILES_PATH}/git/.gitignore" $HOME
ln -sf "${DOTFILES_PATH}/zsh/.zshrc" $HOME

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Setup project folder
REPO_NAME="$(id -F | tr ' ' '.' | tr '[:upper:]' '[:lower:]')"

git clone https://github.com/5minds/${REPO_NAME}.git 5minds

# Finish
echo "You may stillt want to configure the following things:"
echo "  - Request password after lock immediately"
echo "  - Run: 'compaudit | xargs chmod g-w' if there are insecure directories"
echo "Reboot."
