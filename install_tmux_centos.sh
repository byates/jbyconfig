#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #

refresh_sudo_indefinitely()
{
    while true; do
        /usr/bin/sudo -v && sleep 5 || { echo "sudo verification failed"; break; }
    done
}

exit_on_error() {
    exit_code=$1
    if [ $exit_code -ne 0 ]; then
        >&2 echo "-------------------------------------------------"
        >&2 echo "Command failed with exit code ${exit_code}."
        >&2 echo "-------------------------------------------------"
        kill $(jobs -p)
        exit $exit_code
    fi
}

exit_on_requirment() {
    exit_code=$1
    if [ $exit_code -ne 0 ]; then
        >&2 echo "-------------------------------------------------"
        >&2 echo $2
        >&2 echo "-------------------------------------------------"
        kill $(jobs -p)
        exit $exit_code
    fi
}

# check requirements
if [ "$EUID" -eq 0 ]
  then echo "Can't run as root"
  exit
fi

# Get SUDO credentials for later use
/usr/bin/sudo -v
refresh_sudo_indefinitely &

# Install prereqs
sudo yum install -y automake build-essential libncurses5-dev libncursesw5-dev bison flex
exit_on_error $?

mkdir -p ~/tools && pushd ~/tools
if [ ! -d libevent-2.1.11-stable ]; then
	>&2 echo "------------------------------------------------------------"
	>&2 echo "  BUILDING LIBEVENT"
	>&2 echo "------------------------------------------------------------"
    wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz
    exit_on_error $?
    tar -xzf libevent*.tar.gz
    cd libevent-2.1.11-stable
    ./configure  --prefix=/usr/local
    exit_on_error $?
    make
    exit_on_error $?
    sudo make install
    exit_on_error $?
    sudo ldconfig
else
	>&2 echo "-------------------------------------------------"
	>&2 echo "  SKIPPING LIBEVENT BUILD"
 	>&2 echo "  '~/tools/libevent-2.1.11-stable' ALREADY EXISTS"
	>&2 echo "-------------------------------------------------"
fi
popd


mkdir -p ~/tools && pushd ~/tools
if [ ! -d tmux ]; then
	>&2 echo "------------------------------------------------------------"
	>&2 echo "  BUILDING TMUX"
	>&2 echo "------------------------------------------------------------"
    git clone https://github.com/tmux/tmux.git
    exit_on_error $?
    cd tmux
    git checkout 3.0a
    exit_on_error $?
    sh autogen.sh
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    make
    exit_on_error $?
    sudo make install
	exit_on_error $?
    tmux -V
else
	>&2 echo "----------------------------------------------------------"
	>&2 echo "  SKIPPING TMUX BUILD SINCE ~/tools/tmux ALREADY EXISTS."
	>&2 echo "----------------------------------------------------------"
fi
popd

# config
pushd ~
if [ ! -d jbyconfig ]; then
	git clone https://github.com/byates/jbyconfig.git
	exit_on_error $?
fi

if [ ! -f .tmux.conf ]; then
	cp ~/jbyconfig/.tmux.conf  ~/.tmux.conf
else
	>&2 echo "----------------------------------------------------------"
	>&2 echo "  SKIPPING CONFIG UPDATE SINCE ~/.tmux.conf ALREADY EXISTS"
	>&2 echo "----------------------------------------------------------"
fi
popd

kill $(jobs -p)

} # this ensures the entire script is downloaded #

