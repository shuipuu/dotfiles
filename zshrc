# 補完機能の強化
if [ -d ${HOME}/dotfiles/zsh/zsh_plugin/zsh-completions/src ] ; then
  fpath=(${HOME}/dotfiles/zsh/zsh_plugin/zsh-completions/src $fpath)
fi
autoload -U compinit
compinit

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data 
setopt hist_verify
setopt hist_expand
## 全てのコマンド履歴を表示
function history-all { history 1 }
#search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

function mkcd(){mkdir -p $1 && cd $1}
# zaw.sh
source ~/dotfiles/zsh/zsh_plugin/zaw/zaw.zsh
bindkey '^\' zaw-history

# プロンプトの設定
setopt prompt_subst     #shellscript
autoload colors
colors
## 一般ユーザの設定
tmp_prompt="%{${fg[cyan]}%}%n%B%(?,%{${fg[cyan]}%},%{${fg[red]}%})%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"
## root の設定
if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi
## プロンプト設定の反映
PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
## SSHログイン時のプロンプト
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
  PROMPT="%{${fg[white]}%}${HOST%%.*}@${PROMPT}"
fi

# lsのカラー
DIRCOLORS_PATH=~/dotfiles/dircolors-solarized/dircolors.256dark
if [ -f DIRCOLORS_PATH ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors DIRCOLORS_PATH)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors DIRCOLORS_PATH)
    fi
fi

# 一般
setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt nobeep
setopt print_eight_bit  #日本語ファイル名等8ビットを通す

# 補完関係
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'           # 補完の時に大文字小文字を区別しない

# エイリアス
setopt complete_aliases
case "${OSTYPE}" in
freebsd*|darwin*)
alias ls="ls -GF -w"
;;
linux*)
alias ls="ls --color"
;;
esac
## vim
alias vi="vim"
alias view='vim -R'
## jman設定
alias man='env LANG=C man'
alias jman='env LANG=ja_JP.UTF-8 man -M /usr/local/share/man/'
## docker
alias docker-run="docker run -it"

# path
export PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$HOME/.rbenv/bin:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:/usr/texbin:$PATH
eval "$(rbenv init -)"
eval "$(pyenv init -)"

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi

# タイトル
echo -ne "\033]0;`hostname`\007"

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end

# tmux の起動
#[[ -z "$TMUX" && -z "$WINDOW" && ! -z "$PS1" ]]  && tmux
