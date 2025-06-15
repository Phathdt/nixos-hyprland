# Initialize zplug
export ZPLUG_HOME="$HOME/.zplug"
if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
    source "$ZPLUG_HOME/init.zsh"
else
    echo "zplug not found. Please install zplug first."
    return 1
fi

# zplug plugins - manage everything through zplug
zplug "zplug/zplug", hook-build:'zplug --self-manage'

# Oh My Zsh framework and theme
zplug "robbyrussell/oh-my-zsh", use:"oh-my-zsh.sh"
zplug "themes/robbyrussell", from:oh-my-zsh

# Oh My Zsh plugins
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh

# Additional zsh plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "greymd/docker-zsh-completion"

# Install plugins if not installed
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
        echo "Skipping plugin installation. Run 'zplug install' manually later."
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
