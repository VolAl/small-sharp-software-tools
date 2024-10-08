#!/usr/bin/env bash
datestamp=$(date + "%Y%m%d%H%M")

sudo -v

ERRORCOLOR=$(tput setaf 1)   # Red
SUCCESSCOLOR=$(tput setaf 2) # Green
INFOCOLOR=$(tput setaf 3)    # Yellow
RESET=$(tput sgr0)

function info() { echo "${INFOCOLOR}${@}${RESET}"; }
function success() { echo "${SUCCESSCOLOR}${@}${RESET}"; }
function error() { echo "${ERRORCOLOR}${@}${RESET}" >&2; }

info "Starting install at $(date)"

declare -a apps=(tree curl unzip make)

info "Updating Package list"
sudo apt-get update

info "Installing apps:"
for app in ${apps[@]}; do
 info "Installing ${app}"
 sudo apt-get -y install $app
 result=$?
 if [ $result -ne 0 ]; then
  error "Error: failed to install ${app}"
  exit 1
 else
  success "Installed ${app}"
 fi
done

info "Installing Node.js from Nodesource"
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get -y install nodejs
result=$?
if [ $result -ne 0 ]; then
 error "Couldn't install Node.js"
 exit 1
else
 success "Installed Nodejs"
fi

mkdir -p ~/conf_files

info "Setting up ~/.bashrc"
if [ -f ~/.bashrc ]; then
 oldbashrc=~/.bashrc.${datestamp}
 info "Found existing ~/.bashrc file. Backing up to ${oldbashrc}."
 mv ~/.bashrc ${oldbashrc}
fi
cat << 'EOF' > ~/conf_files/.bashrc
[ -z "$PS1" ] && return

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
HISTIGNORE="exit:clear"

export EDITOR=nano
export VISUAL=nano

export PATH=~/bin:PATH
EOF
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create ~/conf_files/.bashrc"
 exit 1
else
 success "Created ~/conf_files/.bashrc"
fi
info "Creating symlink to ~/conf_files/.bashrc"
ln -sf ~/conf_files/.bashrc ~/.bashrc
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create symlink to ~/conf_files/.bashrc"
 exit 1
else
 success "Created symlink to ~/conf_files/.bashrc"
fi

info "Setting up ~/.bash_profile"
if [ -f ~/.bash_profile ]; then
 oldbashprofile=~/.bash_profile.${datestamp}
 info "Found existing ~/.bash_profile file. Backing up to ${oldbashprofile}."
 mv ~/.bash_profile ${oldbash_profile}
fi
cat ~/.bashrc > ~/conf_files/.bash_profile
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create ~/conf_files/.bash_profile"
 exit 1
else
 success "Created ~/conf_files/.bash_profile"
fi
info "Creating symlink to ~/conf_files/.bash_profile"
ln -sf ~/conf_files/.bash_profile ~/.bash_profile
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create symlink to ~/conf_files/.bash_profile"
 exit 1
else
 success "Created symlink to ~/conf_files/.bash_profile"
fi

info "Setting up ~/.inputrc"
if [ -f ~/.inputrc ]; then
 oldinputrc=~/.inputrc.${datestamp}
 info "Found existing ~/.inputrc file. Backing up to ${inputrc}."
 mv ~/.inputrc ${oldinputrc}
fi
cat << 'EOF' > ~/conf_files/.inputrc
\$include /etc/inputrc

"\e[A": history-search-backward
"\e[B": history-search-forward
"\e\"": "\C-a\"\C-e\""
"\e\(": "\C-a\(\C-e\)"
"\e\'": "\C-a\ef\ef\eb\"\C-e\"" 

set completion-ignore-case On
set visible-stats On
set show-all-if-ambiguous on
set bell-style visible
#set editing-mode vi
#set -o vi
EOF
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create ~/conf_files/.inputrc"
 exit 1
else
 success "Created ~/conf_files/.inputrc"
fi
info "Creating symlink to ~/conf_files/.inputrc"
ln -sf ~/conf_files/.inputrc ~/.inputrc
result=$?
if [ $result -ne 0 ]; then
 error "Error: failed to create symlink to ~/conf_files/.inputrc"
 exit 1
else
 success "Created symlink to ~/conf_files/.inputrc"
fi


success "Done! Run  source ~/.bashrc  to apply changes."
