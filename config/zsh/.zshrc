# main zsh settings


# load modules
autoload -Uz colors && colors
autoload -Uz compinit
compinit


# cmp options
zstyle ':completion:' menu select 



HISTFILE=~/.config/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# User additions


# Starship Prompt Activiation
eval "$(starship init zsh)"


# Aliases
alias vim="vim -u ~/.config/vim/vimrc"
