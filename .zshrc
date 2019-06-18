# Git status
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Prompt
setopt prompt_subst
autoload -U colors && colors
PROMPT='%{$fg_bold[blue]%}%n@%m:%1~%{$fg_bold[green]%}$(parse_git_branch)%{$reset_color%}$ '

# Completion
autoload -Uz compinit && compinit
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu yes select=2
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*:processes' command 'ps -aux'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Options
bindkey -e
setopt append_history
setopt auto_cd
setopt extended_glob
setopt always_to_end
setopt complete_aliases
unsetopt beep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagGxGx
export EDITOR="vim"
export TERM="xterm-256color"
export PATH="/usr/local/bin:$PATH"

if command -v rustc &> /dev/null; then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

source ~/.aliases
