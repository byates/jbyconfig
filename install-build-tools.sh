#!/bin/bash -e

Distro=$(awk -F= '/^NAME/{print tolower($2)}' /etc/os-release)
VersionID=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release)

if [[ $(id -u $USER) = 0 ]]; then
    # If we are running as root, then we don't need (and may not have) sudo
    echo "Userid=$(id -u $USER)"
    SUDO=
else
    SUDO=sudo
fi

if [[ $Distro =~ "ubuntu" ]]; then
    echo "Ubuntu distribution detected: $VersionID"
    # Install common build packages
    sudo apt -y install ninja-build libtool autoconf pkg-config libibverbs-dev libnuma-dev libssl-dev libcurl4-openssl-dev
    # Select GCC-10 compiler
    $SUDO apt -y install software-properties-common
    $SUDO add-apt-repository ppa:ubuntu-toolchain-r/test
    $SUDO apt -y install gcc-10 g++-10 postgresql postgresql-contrib libpcap-dev
    $SUDO update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10
    $SUDO apt -y install dh-make
    $SUDO apt -y remove golang
fi

if [[ $Distro =~ .*(centos|red).* ]]; then
    echo "CentOS or RHEL distribution detected: $VersionID"
    # Install common build packages
    if [[ $VersionID =~ "7"* ]]; then
        echo "$Distro is at version 7"
        # install EPEL repo
        $SUDO yum install epel-release -y
        # Update all repos
        $SUDO yum update -y
        # Start installing needed pkgs
        $SUDO yum -y install ninja-build libtool autoconf pkgconfig libibverbs-devel numactl-devel curl-devel zlib-devel openssl-devel wget scl-utils
        $SUDO yum -y groupinstall "Development Tools"
        # Install GTest and Gtest-devel 
        $SUDO yum -y install gtest gtest-devel
        # Select GCC-10 compiler
        $SUDO yum -y install centos-release-scl-rh
        $SUDO yum -y --enablerepo=centos-sclo-rh-testing install devtoolset-10-gcc-c++
        # pcap
        mkdir -p ~/tools
        pushd ~/tools
        wget -q http://mirror.centos.org/centos/7/os/x86_64/Packages/libpcap-devel-1.5.3-12.el7.x86_64.rpm
        $SUDO yum install -y libpcap-devel-1.5.3-12.el7.x86_64.rpm
        popd
    else
        echo "$Distro is at version 8"
        # Install all distro tools
        $SUDO yum update -y --nobest
        $SUDO yum install -y 'dnf-command(config-manager)' gtest-devel
        $SUDO yum install -y wget make gcc gcc-c++ curl-devel openssl-devel numactl-devel.x86_64 rpm-build
        $SUDO yum install -y ninja-build meson tcl libstdc++-static rdma-core-devel.x86_64
        $SUDO pip3 install --upgrade pip meson
        $SUDO dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
        $SUDO dnf -y install gcc-toolset-10-gcc gcc-toolset-10-gcc-c++
        export PATH=/opt/rh/gcc-toolset-10/root/usr/bin:$PATH
        if [[ $Distro =~ .*(red).* ]]; then
            echo -e "******************************\nInstalling RHEL specific tools\n******************************"
            $SUDO dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
            $SUDO yum -y group install "Development Tools"
            $SUDO yum -y install llvm-toolset autoconf-2.69-27.el8.noarch
        else
            echo -e "********************************\nInstalling CentOS specific tools\n********************************"
            $SUDO yum install -y epel-release dh-autoreconf
            $SUDO yum config-manager --set-enabled powertools
        fi
    fi
fi

#cmake
cmake_version="3.23.1"
mkdir -p ~/tools
if [ ! -d ~/tools/cmake ] ; then
    pushd ~/tools
    mkdir -p cmake
    wget -q https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.sh
    chmod +x cmake-${cmake_version}-linux-x86_64.sh
    ./cmake-${cmake_version}-linux-x86_64.sh --skip-license --prefix=$(realpath ~)/tools/cmake
    rm -f ./cmake-${cmake_version}-linux-x86_64.sh
    popd
fi
export PATH="$PATH:$(realpath ~)/tools/cmake/bin"

# golang
GODOWNLOAD=go1.19.1.linux-amd64.tar.gz
mkdir -p ~/tools
pushd ~/tools
wget -q https://golang.org/dl/${GODOWNLOAD}
$SUDO rm -rf /usr/local/go
$SUDO tar -C /usr/local -xzf $GODOWNLOAD > /dev/null
$SUDO rm -f $GODOWNLOAD
$SUDO touch /etc/profile.d/go.sh
$SUDO chmod 666 /etc/profile.d/go.sh
$SUDO echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile.d/go.sh
$SUDO chmod 644 /etc/profile.d/go.sh
popd
