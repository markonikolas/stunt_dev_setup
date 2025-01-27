#!/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install caskroom/cask/brew-cask

brew tap homebrew/bundle
brew bundle

# Remove apps from Dock
dockutil --remove 'Launchpad' --allhomes
dockutil --remove 'Siri' --allhomes
dockutil --remove 'Safari' --allhomes
dockutil --remove 'Mail' --allhomes
dockutil --remove 'Contacts' --allhomes
dockutil --remove 'Reminders' --allhomes
dockutil --remove 'Maps' --allhomes
dockutil --remove 'Photos' --allhomes
dockutil --remove 'Messages' --allhomes
dockutil --remove 'FaceTime' --allhomes
dockutil --remove 'iTunes' --allhomes
dockutil --remove 'iBooks' --allhomes
dockutil --remove 'App Store' --allhomes
dockutil --remove 'System Preferences' --allhomes
dockutil --remove 'Keynote' --allhomes
dockutil --remove 'Pages' --allhomes
dockutil --remove 'Numbers' --allhomes
dockutil --remove 'Podcasts' --allhomes
dockutil --remove 'TV' --allhomes

# Add apps to Dock
dockutil --add '/Applications/Mattermost.app' --position 1 --allhomes
dockutil --add '/Applications/Google Chrome.app' --position 2 --allhomes
dockutil --add '/Applications/Visual Studio Code.app' --position 3 --allhomes
dockutil --add '/Applications/Sublime Text.app' --position 4 --allhomes
dockutil --add '/Applications/iTerm.app' --position 5 --allhomes

# Install Grunt and Sass
npm install --global grunt-cli
sudo gem install sass

# Install yadr
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh`"
cd ~/.yadr/ && rake update
sed -i '' -e 's/skwp/agnoster/g' ~/.yadr/zsh/theme.zsh

# Install theme
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i '' -e 's/ZSH_THEME="robbyrussel"/ZSH_THEME="agnoster"/g' ~/.zshrc

# Fix zsh security issues
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# Add aliases
cat <<EOT >> ~/.zshrc
# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'

# Vagrant
alias vup='vagrant up'
alias vd='vagrant suspend'
alias vssh='vagrant ssh'

# Docker
alias docker-compose="docker compose"
alias dcb="docker-compose build"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcl="docker-compose exec --user $(id -u):$(id -g) web /bin/bash"
alias dcdebug="docker-compose down && docker-compose run --service-ports web"
alias dclc="dockerlogin"
alias dwp="docker_wpcli"

docker_wpcli() {
  declare ARGS

  # if CWD is not WordPress project, exit
  if ! [[ -d ./wp-includes && -d ./wp-admin && -d ./wp-content ]]; then
    echo 'Not in WordPress project.'
    return 1
  fi

  # If WordPress and DB are not running, exit
  CWD=${PWD##*/}
  CONTAINERS_ACTIVE=$(docker ps | grep $CWD |  wc -l)

   if [ $CONTAINERS_ACTIVE -lt 2 ]; then
    echo 'Start WordPress and Database containers first.'
    return 1
  fi

  # if container already exists, recreate it
  COUNT=$(docker ps -a | grep wp_cli | wc -l)

  if [ $COUNT -gt 0 ]; then
    echo Recreating wp_cli container..
    docker rm wp_cli
  fi

  # If no arguments are passed, display wp info
  if [ $# -eq 0 ]; then
    ARGS="--info"
  else
    ARGS=("$@")
  fi

  docker-compose run --name wp_cli --rm wp_cli "${ARGS[@]}"
}

dockerlogin() {
  if [ -n "$1" ]
  then
    docker-compose exec --user $(id -u):$(id -g) $1 /bin/bash
  fi
}

# Install Vagrant plugins
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-faster

# Fabric
alias fsd='fab staging deploy'
alias fpd='fab production deploy'

# Terminal
alias cat='bat'
alias l='exa --long --header -g -a --classify'
EOT

# Fix zsh Insecure completion-dependent directories issues
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# Local files, folders and scripts setup
mkdir ~/Sites/
sudo easy_install pip
pip install -Iv fabric==1.14.1

# Rbenv
brew install rbenv
rbenv install 2.7.1
rbenv global 2.7.1

# Install Capistrano
gem install capistrano
