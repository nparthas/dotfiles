# export 'PROMPT=%(?.%F{green}√.%F{red}?%?)%f %n@%m:%B%F{006}%~%f%b %# '
export 'PROMPT=%(?.%F{green}√.%F{red}?%?)%f %B%F{006}%~%f%b %# '

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git autocomplete
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

zstyle ':completion:*:*:make:*' tag-order 'targets'

autoload -Uz compinit && compinit

# use gcc
# alias gcc='gcc-9'
# alias cc='gcc-9'
# alias g++='g++-9'
# alias c++='c++-9'

# use brew python
# alias pip3='/usr/local/bin/pip3'
# alias pip='/usr/local/bin/pip3'
# alias python3='/usr/local/bin/python3'
# alias python='/usr/local/bin/python3'

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--multi'

# terminal config via nix
[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ] && source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

true
