# Initialize zplug
source ~/.zplug/init.zsh

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# zplug plugins
zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "greymd/docker-zsh-completion"
zplug "themes/robbyrussell", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

# Install plugins if not installed
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load plugins
zplug load

# Aliases
alias vi=nvim
alias vim=nvim
alias n=nvim

# Git aliases
alias gpall="git push origin --all"
alias gcos="git checkout staging && git pull origin staging"
alias gcod="git checkout develop && git pull origin develop"

# Directory shortcuts
alias dev='cd ~/Documents/Dev/ && echo "Welcome Dev"'
alias down='cd ~/Downloads/ && echo "Welcome Downloads"'

# Docker
export DOCKER_BUILDKIT=0

# History configuration
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Utility function
mt() {
    mkdir -p "$(dirname "$1")" && touch "$1"
}

# Load local environment if exists
[ -f ~/.env ] && source ~/.env

# Increase file descriptor limit
ulimit -n 2048
