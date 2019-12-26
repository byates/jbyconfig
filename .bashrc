# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# ADDED HELLASTORM
#

PS1='\n\[\e[01;36m\]\u \[\e[0m\]on \[\e[01;33m\]\h \[\e[0m\]in \[\e[01;34m\]\w\[\e[0m\]\n$ '

export HISTSIZE=2000
export HISTFILESIZE=2000
export HISTIGNORE="&:[ ]*:exit:ls:la:ll:lll:history"
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# Turn off history substitution "!" in bash commands.
set +H

alias ls='ls -x --color=auto --group-directories-first'
alias la='ls -Ax --color=auto --group-directories-first'
alias ll='ls -l --color=auto --group-directories-first'
alias lll='ls -lA --color=auto --group-directories-first'
alias rsyncp='rsync -avzh --info=progress2 --info=name0 --stats'
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

export PATH=$PATH:/usr/local/go/bin

export loc_linux_kernel_generic=/usr/src/kernels/$(uname -r)
export loc_linux_kernel=/usr/src/kernels/$(basename $(uname -r) -generic)

export QSYS_ROOTDIR="/home/hellastorm/intelFPGA_pro/18.1/qsys/bin"
export GOPATH=/home/hellastorm/AppDev/hs_go_examples

#------------------------------------------------------------
# the following makes sure that ssh-agent runs for each shell
# this is necessary for git access with key files.
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# DPDK STUFF
export DPDK_VER=dpdk-stable-19.08.2
export RTE_SDK=$HOME/tools/${DPDK_VER}
export RTE_TARGET=x86_64-native-linux-gcc
export PKG_CONFIG_PATH=~/tools/${DPDK_VER}/build/meson-private:$PKG_CONFIG_PATH
export PCAPPLUSPLUS_HOME=~/tools/PcapPlusPlus-19.12
alias dpstat='~/tools/${DPDK_VER}/usertools/dpdk-devbind.py --status'
alias dpbind='/usr/bin/sudo -E ~/tools/${DPDK_VER}/usertools/dpdk-devbind.py --force --bind=vfio-pci'
alias dpunbind='/usr/bin/sudo -E ~/tools/${DPDK_VER}/usertools/dpdk-devbind.py -u'

# dsf A B will procude "fancy" diffs.
function dsf() { diff -u $1 $2 | diff-so-fancy; }

# END HELLASTORM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source scl_source enable devtoolset-8 rh-python36
# lauch shell as tmux session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    if [ "$TERM_PROGRAM" == "vscode" ]; then
        echo "vscode dectected. running standard shell."
    else
        tmux
    fi
fi


