# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export "LC_ALL=en_US.UTF-8"
export "LANG=en_US.UTF-8"
export "LANGUAGE=en_US.UTF-8"
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

function retrodate(){
    fancyoutput=$(date +%H:%M)
    zerox=${fancyoutput//[0]/🯰}
    onex=${zerox//[1]/🯱}
    dvajox=${onex//[2]/🯲}
    treix=${dvajox//[3]/🯳}
    quadrox=${treix//[4]/🯴}
    pentax=${quadrox//[5]/🯵}
    seqxta=${pentax//[6]/🯶}
    septex=${seqxta//[7]/🯷}
    oktax=${septex//[8]/🯸}
    nonet=${septex//[9]/🯹}
    echo $nonet
}
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    function battery_segment {
    #local bg_color="$1"
    #local fg_color="$2"
    local batt_dir
    local content
    local batt_dir="/sys/class/power_supply/BAT0"
    #if [ -d $batt_dir"0" ]; then
    #    batt_dir=$batt_dir"0"
    #elif [ -d $batt_dir"1" ]; then
    #    batt_dir=$batt_dir"1"
    #else
    #    return 1
    #fi
    local cap
    cap="$(<"$batt_dir/capacity")"
    local status
    status="$(<"$batt_dir/status")"

    if [ "$status" == "Discharging" ]; then
        content="🗙 "
    else
        content="🗲 "
    fi
    content="$content$cap%"

    echo "$content"
    }
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1='\[\033[48;2;83;200;83;38;2;255;255;255m\] \$ \[\033[48;2;123;100;255;38;2;255;255;255m\] \u@\h \[\033[48;2;30;30;30;38;2;255;255;255m\] \w \[\033[00m\] '
    #PS1='\[\033[48;2;238;244;83;90;2;255;255;255m\] $(battery_segment) \[\033[48;2;0;230;108;38;2;238;244;83m\]\[\033[48;2;0;230;108;38;2;255;255;255m\] \$ \[\033[48;2;173;135;255;38;2;0;230;108m\]\[\033[48;2;173;135;255;38;2;255;255;255m\] \u@\h λ \[\033[48;2;10;10;10;38;2;173;135;255m\]\[\033[48;2;10;10;10;38;2;255;255;255m\] 🗁  \w  \[\033[49;38;2;10;10;10m\]\[\033[00m\] '
    PS1='\[\033[48;2;238;244;83;90;2;255;255;255m\] $(battery_segment) \[\033[48;2;0;230;108;38;2;238;244;83m\]\[\033[48;2;0;230;108;38;2;255;255;255m\] \$ \[\033[48;2;43;69;112;38;2;0;230;108m\]\[\033[48;2;43;69;112;38;2;255;255;255m\] $(retrodate) \[\033[48;2;173;135;255;38;2;43;69;112m\]\[\033[48;2;173;135;255;38;2;255;255;255m\] Nika@\h λ \[\033[48;2;10;10;10;38;2;173;135;255m\]\[\033[48;2;10;10;10;38;2;255;255;255m\] 🗁  \w  \[\033[49;38;2;10;10;10m\]\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias yeet='sudo rm -rf'
#alias py='python3'
alias nf='neofetch --ascii ~/Scripts/XeniaAscii.txt'
alias bashconfDD='nano ~/.bashrc'
alias btTools='bluetoothctl'
alias ip='ip -c'
alias TelSSH='ssh -p 8022 -l u0_a422'
alias mkpasswdhash='tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c 20; echo'
alias gimmenetfolder='wget -r -np -R "index.html*"'
alias screenietool='sh -c "gnome-screenshot -acf /tmp/screenie && cat /tmp/screenie | xclip -i -selection clipboard -target image/png ; rm -rf /tmp/screenie"'
alias winestopall="ls -l /proc/*/exe 2>/dev/null | grep -E 'wine(64)?-preloader|wineserver' | perl -pe 's;^.*/proc/(\d+)/exe.*$;$1;g;' | xargs -n 1 kill"
##alias foldercheck='sh -c "find $1 -type f -exec md5sum {} + | LC_ALL=C sort | md5sum"'
#alias btSend
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# To enable battery conservation mode
# setcharging 1

# To disable it
# setcharging 0

# Default is enabled
function convbat()
{
        echo ${1:-1}  | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode
}
function btSend()
{
	bluetooth-sendto --device="$1"
}
#function TelSSH()
##{
#	ssh $1 -p 8022 -l u0_a422
#}
function flacplay()
{
	flac -d -c "$1" | aplay -f cd
}
function lol()
{
    if [ -t 1 ]; then
        "$@" | lolcat
    else
        "$@"
    fi
}
function foldercheck()
{
	find "$1" -type f -exec md5sum {} + | LC_ALL=C sort | md5sum
}
##bind 'RETURN: "\e[1~lol \e[4~\n"'
function set-title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}
function tpadctrl()
{
    declare -i TouchPID
    TouchPID=`echo 16`
    ###ID=`xinput list | grep -Eo 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    declare -i STATE
    STATE=`xinput list-props $TouchPID|grep 'Device Enabled'|awk '{print $4}'`
    if [ $STATE -eq 1 ]
    then
        xinput disable $TouchPID
        notify-send -u normal -t 2000  "Touchpad Status" "Touchpad disabled" -i touchpad-disabled-symbolic
    else
        xinput enable $TouchPID
        notify-send -u normal -t 2000 "Touchpad Status" "Touchpad enabled" -i input-touchpad-symbolic
    fi

}