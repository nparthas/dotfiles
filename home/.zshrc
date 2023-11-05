# export 'PROMPT=%(?.%F{green}√.%F{red}?%?)%f %n@%m:%B%F{006}%~%f%b %# '
export 'PROMPT=%(?.%F{green}√.%F{red}?%?)%f %B%F{006}%~%f%b %# '

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git autocomplete
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

zstyle ':completion:*:*:make:*' tag-order 'targets'

autoload -Uz compinit && compinit

# keep emacs navigation for terminal
bindkey -e
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

alias logout="qdbus org.kde.ksmserver /KSMServer logout 1 3 3"

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--multi'

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

true
