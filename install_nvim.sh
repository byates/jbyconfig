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
python3 --version
exit_on_requirment $? "python3 required by this script"

# Get SUDO credentials for later use
/usr/bin/sudo -v
refresh_sudo_indefinitely &

# Install prereqs
sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch
exit_on_error $?

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh | bash
exit_on_error $?

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
exit_on_error $?

nvm list

curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
exit_on_error $?

sudo yum -y install yarn
npm install -g diff-so-fancy

mkdir -p ~/tools && pushd ~/tools
if [ ! -d neovim ]; then
	>&2 echo "------------------------------------------------------------"
	>&2 echo "  BUILDING NEOVIM"
	>&2 echo "------------------------------------------------------------"
	git clone https://github.com/neovim/neovim
	exit_on_error $?
	cd neovim
	git checkout stable
	exit_on_error $?
	make CMAKE_BUILD_TYPE=Release
	exit_on_error $?
	./build/bin/nvim --version | grep ^Build
	sudo make install
	nvim --version
	exit_on_error $?
else
	>&2 echo "------------------------------------------------------------"
	>&2 echo "  SKIPPING NEOVIM BUILD SINCE ~/tools/neovim ALREADY EXISTS."
	>&2 echo "------------------------------------------------------------"
fi
popd

python3 --version
exit_on_error $?
sudo pip install --upgrade setuptools pip

if python -c 'import pkgutil; exit(not pkgutil.find_loader("neovim"))'; then
	echo 'python2 neovim found'
else
	pip2 install --user neovim
fi

if python3 -c 'import pkgutil; exit(not pkgutil.find_loader("neovim"))'; then
	echo 'python3 neovim found'
else
	pip3 install --user neovim
fi

exit_on_error $?
sudo npm install -g neovim
yarn global add neovim
sudo ln -sf /usr/local/bin/nvim /usr/bin/nvim

# config
pushd ~
if [ ! -d jbyconfig ]; then
	git clone https://github.com/byates/jbyconfig.git
	exit_on_error $?
fi

if [ ! -d .config/nvim ]; then
	mkdir -p ~/.config/nvim
	cp ~/jbyconfig/nvim/* ~/.config/nvim
else
	>&2 echo "------------------------------------------------------------"
	>&2 echo "  SKIPPING CONFIG UPDATE SINCE ~/.config/nvim ALREADY EXISTS"
	>&2 echo "------------------------------------------------------------"
fi
popd

kill $(jobs -p)

>&2 echo ""
>&2 echo ""
>&2 echo "------------------------------------------------------------"
>&2 echo " RESTART SHELL BEFORE RUNNING NVIM FOR THE FIRST TIME. "
>&2 echo "------------------------------------------------------------"


} # this ensures the entire script is downloaded #

