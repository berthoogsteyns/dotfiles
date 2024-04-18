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

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
autoload -Uz promptinit && promptinit


# HISTORY
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

zinit ice as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init --cmd j zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
# compdef __zoxide_z_complete cd
eval "$(~/.local/share/zinit/plugins/ajeetdsouza---zoxide/zoxide init zsh)"

# zinit light starship 'starship init zsh --print-full-init'
eval "$(starship init zsh)"
# hook for direnv
eval "$(direnv hook zsh)"

zinit wait lucid for \
  OMZP::history \

zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
zinit wait lucid for \
  atinit"zicompinit; zicdreplay"  \
      zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
      zdharma-continuum/history-search-multi-word \
      MichaelAquilina/zsh-you-should-use \
      OMZP::colored-man-pages \
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

zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
eval "$(~/.local/share/zinit/plugins/ajeetdsouza---zoxide/zoxide init zsh)"

zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
source <(docker completion zsh)
setopt auto_cd

# Personal stuff

alias ls=lsd
alias cat=bat
alias grep=rg
alias cd=__zoxide_z

export SUDO_EDITOR=nvim
export KUBE_EDITOR="nvim"

#exports
export FZF_BASE="/usr/bin/sk"
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$FZF_BASE:$PATH"

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
    ssh-add
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

