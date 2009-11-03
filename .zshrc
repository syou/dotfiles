#PATH
PATH=$PATH:/usr/local/ruby1.8/bin

# �ץ��ץȤΥ��顼ɽ����ͭ��
autoload colors; colors

#screen�䴰��
if [ "$TERM" = "screen" ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
	# see [zsh-workers:13180]
	# http://www.zsh.org/mla/workers/2000/msg03993.html
	emulate -L zsh
	local -a cmd; cmd=(${(z)2})
	case $cmd[1] in
	    fg)
    if (( $#cmd == 1 )); then
	cmd=(builtin jobs -l %+)
	else
	cmd=(builtin jobs -l $cmd[2])
	fi
    ;;
	    %*) 
    cmd=(builtin jobs -l $cmd[1])
    ;;
	    cd)
    if (( $#cmd == 2)); then
	cmd[1]=$cmd[2]
	fi
    ;&
    *)
    echo -n "k$cmd[1]:t\\"
return
;;
esac

local -A jt; jt=(${(kv)jobtexts})

$cmd >>(read num rest
    cmd=(${(z)${(e):-\$jt$num}})
    echo -n "k$cmd[1]:t\\") 2>/dev/null
}
chpwd
fi



# Emacs style key binding
bindkey -e


# sudo ���䴰��ͭ���ˤ���
 zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin
#                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin


# �䴰�λ�����ʸ����ʸ������̤��ʤ�
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'



#gem�䴰�ؿ�(from kabus)
alias gem-update-list="gem list -r 2> /dev/null | grep '^[a-zA-Z]' | awk '{print \$1}' > $HOME/.gemlist"
_gem () {
    LIMIT=`date -d "1 week ago" +%s`
    if ! [[ ( -f $HOME/.gemlist ) && ( `date -r "$HOME/.gemlist" +%s` -gt $LIMIT ) ]]; then
        gem-update-list
    fi
    reply=(`cat $HOME/.gemlist`)
}
compctl -k "(`gem help commands | grep '^    \w.*' | sed 's/^\s*//' | sed 's/\s\s*.*//'`)" -x 'c[-1,-t]' - 'C[-1,(install)]' -K _gem -- gem


#���򸡺���ǽ�Υ��硼�ȥ��å�����
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end


# ��ư�����ǥ��쥯�ȥ��Ͽ
setopt auto_pushd



#case "${TERM}" in
#kterm*|xterm*)
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#cons25)
#    unset LANG
#    export LSCOLORS=ExFxCxdxBxegedabagacad
#    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#    ;;
#esac



export LANG=ja_JP.UTF-8

# ���������ץ������󥹤�Ȥ���
setopt prompt_subst

#emacs��Ȥ�
export EDITOR=emacs
export SVN_EDITOR=emacs


case "${TERM}" in
kterm*|teraterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac



# C s ̵��
stty stop undef

PROMPTTTY=`tty | sed -e 's/^\/dev\///'`
PROMPT="[%B${cyan}%~${default}%b] <%B${PROMPTTTY}%b> %E
%b%# "
if [ `whoami` = root ]; then
        RPROMPT="${red}%B%n${default}%b@${logreen}%m${default}%b"
else
        RPROMPT="${loyellow}%n${default}%b@${logreen}%m${default}%b"
fi
 SPROMPT="${red}Correct ${default}> '%r' [%BY%bes %BN%bo %BA%bbort %BE%bdit] ? "

#command correct edition before each completion attempt
setopt correct

#if [ $USER = "root" ] 
#then
#    PROMPT="%{[31]m%}%B$LOGNAME@%m[%W %T]:%b%{%} %h# "
#    RPROMPT="[%{%}%~%{%}]"
#    PATH=${PATH}:/sbin:/usr/sbin:/usr/local/sbin
#    HOME=/root
#else
##    PROMPT="%{%}$LOGNAME@%m%B[%W %T]:%b%{%} %h%% "
#    PROMPT="%{%}$LOGNAME@%m: "
#    #PROMPT="%$LOGNAME@%m%B[%W %T]:%b%{%} %h%% "
#    #RPROMPT="[%{%}%~%{%}]"
#fi

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

function history-all { history -E 1 } # ������ΰ�������Ϥ���


#case ${UID} in
#0)
#    PROMPT="%{${fg[red]}%}%/#%{${reset_color}%}%b "
#    PROMPT2="%{${fg[red]}%}%_#%{${reset_color}%}%b "
#    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
##    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
#    ;;
#*)
#    PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
#    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
#    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
#    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
#    ;;
#esac

# �ǥե���Ȥ��䴰��ǽ��ͭ��
## Completion configuration
#
# fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit; compinit

# �䴰�����Emacs�Υ����Х���ɤ�ư�����
# zstyle ':completion:*:default' menu select=1

# compacked complete list display
#
setopt list_packed

# �ǥ��쥯�ȥ�̾�����ǰ�ư�Ǥ��롣
setopt auto_cd

# rm * ��¹Ԥ������˳�ǧ����롣
setopt rmstar_wait

# ������ȥ������Ȥ�ƻ뤹�롣
#watch=(all all)
# �����ƻ�
watch="all"
# 10ʬ����(�ǥե���Ȥ�1ʬ����)
#LOGCHECK="$[10 * 60]"
# ��ꤢ����ɽ�����Ƥߤ�
log

# �ե�����ꥹ���䴰�Ǥ�ls��Ʊ�ͤ˿���Ĥ���
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# �Хå����饦��ɥ���֤���λ�����餹�����Τ餻�롣
setopt no_tify

# ����ե�����˻����Ͽ
setopt extended_history

#history�ե�����˾�񤭤������ɲ�
setopt append_history

# ����򥤥󥯥��󥿥���ɲ�
setopt inc_append_history

# ����ζ�ͭ
setopt share_history

# �ҥ��ȥ���ɲä���륳�ޥ�ɹԤ��Ť���Τ�Ʊ���ʤ�Ť���Τ���
setopt hist_ignore_all_dups

# ľ����Ʊ�����ޥ�ɥ饤��ϥҥ��ȥ���ɲä��ʤ�
setopt hist_ignore_dups

# ���ڡ����ǻϤޤ륳�ޥ�ɹԤϥҥ��ȥ�ꥹ�Ȥ�����
setopt hist_ignore_space

# �ҥ��ȥ��ƤӽФ��Ƥ���¹Ԥ���֤˰�ö�Խ���ǽ
setopt hist_verify

# core�Υ�����
limit coredumpsize 0

# screen�ǥХå����ڡ����������ʤ��ʤ������fix
#alias screen="TERM=screen screen"
bindkey '^@' backward-delete-char

### set alias
alias rr="rm -rf"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ll="ls -al"
#�ȡ�������Ʊ�����롣
alias ntpdate="ntpdate -u 130.69.251.23"
alias twitter="~/ruby/twitter/tw.rb"

#alias where="command -v"
#alias j="jobs -l"
alias ls="ls --color=auto -F"
#alias ls="ls -G -w"
alias la="ls -a"
#alias lf="ls -F"
#alias ll="ls -al"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias pd="pushd"
alias po="popd"
#alias cd="cd \!*; dirs"
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'

alias la="ls -lhAF --color=auto"
alias cl="make -f ~/Makefile clean"
alias ps="ps -fU`whoami` --forest"

#alias a2ps="a2psj"
#alias xdvi="xdvi-ja"
#alias xdvi="ssh -X -f paddy \xdvi"
if [ `uname` = "FreeBSD" ]
then
    alias xdvi="\xdvi -page a4 -s 0"
fi
#alias gs="gs-ja"
alias jman="LANG=ja_JP.UTF-8 \jman"

alias mo="mozilla &"
alias e="emacs &"
#alias enw="emacs -nw"

#emacs only no window
#alias emacs="emacs -nw"

alias a="./a.out"
alias x="exit"

alias -g L='| lv -c'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
#alias -g W='| wc'
alias -g S='| sed'
#alias -g A='| awk'


alias rd2ewb="rd2 -r rd/rd2ewb-lib"
#alias rd2ewb "rd2 -r rd2ewb-lib"
alias dpkg="env COLUMNS=130 \dpkg"

alias mutt="env EDITOR=vim \mutt"

#���ޤ������ʤ���
# alias sudo="env PATH=${PATH}:/sbin:/usr/sbin:/usr/local/sbin \sudo"

#alias sodipodi="env GTK_IM_MODULE=im-ja \sodipodi"

alias tgif="\tgif -dbim xim"

## terminal configuration
#
unset LSCOLORS
case "${TERM}" in
xterm)
    export TERM=xterm-color
    ;;
kterm)
    export TERM=kterm-color
    # set BackSpace control character
    stty erase
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors \
        'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors \
        'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
esac


# current directory���ѹ����줿���˼¹Ԥ���ؿ�
function chpwd()
{
    # �ե����������ɽ��
    ls;
    # screen�����ȥ�򥫥��ȥǥ��쥯�ȥ��
    [ "$TERM" = "screen" ] && \
	echo -ne "\ek`pwd | sed -n 's/^.*\/\(.*\)$/\1\//p'`\e\\"
}


### end of file