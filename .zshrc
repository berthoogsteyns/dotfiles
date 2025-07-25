# ================================================================
# ZINIT PLUGIN LOADING
# ================================================================

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zoxide setup
# zinit ice as"command" from"gh-r" lucid \
#   mv"zoxide*/zoxide -> zoxide" \
#   atclone"./zoxide init --cmd j zsh > init.zsh" \
#   atpull"%atclone" src"init.zsh" nocompile'!'
# zinit light ajeetdsouza/zoxide

# Load important annexes (required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Load plugins with turbo mode
zinit wait lucid for \
  OMZP::history \
  atinit"zicompinit; zicdreplay"  \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
      zdharma-continuum/history-search-multi-word \
      MichaelAquilina/zsh-you-should-use \
      OMZP::git \
      OMZP::fzf \
      OMZP::kubectl \
      OMZP::sudo \
      OMZP::command-not-found \
      chrissicool/zsh-256color \
  blockf \
      zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions

# Docker completion
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# ================================================================
# ALL EVALUATIONS
# ================================================================

# zoxide initialization
eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Direnv hook
eval "$(direnv hook zsh)"

# SSH agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
    ssh-add
fi

# Atuin setup
source $HOME/.atuin/bin/env
eval "$(atuin init zsh)"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Kubectl completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Docker completion
source <(docker completion zsh)

# Deno environment
. "/home/berthoogsteyns/.deno/env"

# ================================================================
# ZSH STYLING
# ================================================================

# History configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

# Completion path and autoload
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
autoload -Uz promptinit && promptinit

# Completion styles
zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Shell options
setopt auto_cd

# ================================================================
# EXPORTS
# ================================================================

# Editor configuration
export SUDO_EDITOR=nvim
export KUBE_EDITOR="nvim"
export SYSTEMD_EDITOR=nvim

# Environment variables
export ANSIBLE_HOST_KEY_CHECKING=False

# Path configuration
export FZF_BASE="/usr/bin/sk"
export PATH="$(yarn global bin):$HOME/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.cargo/bin:$FZF_BASE:/usr/local/go/bin:$HOME/go/bin:$PATH"

# ================================================================
# ALIASES
# ================================================================

alias ls=lsd
alias cat=bat
alias grep=rg
alias cd=z
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ================================================================
# TERMINAL KEYBINDS
# ================================================================

# Ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[H"    beginning-of-line  
bindkey "\e[F"    end-of-line         

# Ctrl+delete
bindkey "\e[3;5~" kill-word

# Delete
bindkey "\e[3~" delete-char

# Ctrl+backspace
bindkey '^H' backward-kill-word

# Ctrl+shift+delete
bindkey "\e[3;6~" kill-line
