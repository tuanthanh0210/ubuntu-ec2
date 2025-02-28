#!/bin/bash

# Update package list
sudo apt update

# Install Zsh
sudo apt install -y zsh

# Set Zsh as default shell
chsh -s $(which zsh)

# Check if script is running in Bash, switch to Zsh
if [ -z "$ZSH_VERSION" ]; then
    echo "Switching to Zsh to continue installation..."
    exec zsh "$0" "$@"
    exit
fi

# Install zsh-autosuggestions
sudo apt install -y zsh-autosuggestions

echo "Zsh and zsh-autosuggestions installed successfully"

# Install Oh My Zsh if it doesn't exist
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping this step."
fi

# Configure zsh-autosuggestions plugin
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
if [ ! -d "$ZSH_CUSTOM/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"\else
    echo "zsh-autosuggestions plugin already exists, skipping this step."
fi

# Add plugin to ~/.zshrc if it doesn't exist
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
fi

# Install zsh-completions if it doesn't exist
if [ ! -d "$HOME/.zsh/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions
else
    echo "zsh-completions already exists, skipping this step."
fi

# Configure autocompletion
if ! grep -q "fpath+=(~/.zsh/zsh-completions/src)" ~/.zshrc; then
    echo "fpath+=(~/.zsh/zsh-completions/src)" >> ~/.zshrc
    echo "autoload -U compinit && compinit" >> ~/.zshrc
fi

# Enable cache to speed up autocompletion
mkdir -p ~/.zsh/cache
if ! grep -q "zstyle ':completion:*' use-cache on" ~/.zshrc; then
    echo "zstyle ':completion:*' use-cache on" >> ~/.zshrc
    echo "zstyle ':completion:*' cache-path ~/.zsh/cache" >> ~/.zshrc
fi

# Reload Oh My Zsh to recognize plugins
omz reload

echo "exec zsh" >> ~/.bashrc

# Apply configuration
source ~/.zshrc

# Add a configuration code for .zshrc
cat <<EOF >> ~/.zshrc
# Custom prompt
function work_in_progress() {
  if \$(git log -n 1 2>/dev/null | grep -q -c "--wip--"); then
    echo "[WIP!!] "
  fi
}

TIME=%{\$fg_bold[yellow]%}%D{%H:%M:%S}
local ret_status="%(?:%{\$fg_bold[green]%}➜ %n ~ :%{\$fg_bold[red]%}➜ )"
local git_branch='\$(git_prompt_info)%{\$reset_color%}'
local git_wip='%{\$fg[yellow]%}\$(work_in_progress)%{\$reset_color%}'

PROMPT="\${ret_status}%{\$fg[cyan]%}%c ➜%{\$reset_color%} \${git_branch}%{\$fg[yellow]%}✗ \${git_wip}%{\$fg[white]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}(%{\$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%})%{\$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"

# Aliases
alias dc="docker-compose"
EOF

echo "Install zsh successfully"
