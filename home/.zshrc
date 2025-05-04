if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"
CASE_SENSITIVE="true"
zstyle ':omz:update' mode reminder

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unsetopt share_history

path+=('/home/nparthas/.local/bin')
export PATH

alias logout="qdbus org.kde.ksmserver /KSMServer logout 1 3 3"

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--multi'

source <(fzf --zsh)
