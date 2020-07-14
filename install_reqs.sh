#!/bin/sh
#
# \description  Install external system libraries for client components of AnDeT
# Note: this script is designed for Linux Ubuntu and might also work on Debian
# or other Linuxes
#
# \author Artem Lutov <lutov.analytics@gmail.com>

# Target OS: Linux
# Actual build OS: Linux Ubuntu 18.04+

# Common development packages required to build executables
echo "Installing common build environment ..."
ERR=`make --version`
if [ $ERR -ne 0 ]; then
	sudo apt-get install -y build-essential	make g++ cmake bc
fi

ERR=`g++ --version`
if [ $ERR -ne 0 ]; then
	sudo apt-get install -y g++
fi

ERR=`cmake --version`
if [ $ERR -ne 0 ]; then
	sudo apt-get install -y cmake bc
fi
# Install the latest version of cmake if required
CMAKE_MIN=3.11  # Minimal required version of cmake
CMAKE_VER=`cmake --version | grep -o '[0-9].[0-9]*'`
RES=`echo "$CMAKE_VER>$CMAKE_MIN" | bc`
if [ $RES -eq 0 ]; then
	set -o xtrace
	wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
	sudo apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget
	LINUX_CNAME=`lsb_release -cs`  # Linux code name
	sudo apt-add-repository -y "deb https://apt.kitware.com/ubuntu/ $LINUX_CNAME main"
	set +o xtrace
	sudo apt-get update
	sudo apt-get install -y cmake
fi

# Component-specific requirements
echo "Installing build environment for FORT:leto (live tracking video and tracking configuration) ..."
sudo apt-get install -y golang

echo "Installing build environment for FORT:tag-layouter (tags drawing) ..."
sudo apt-get install -y golang libopencv-dev

echo "Installing build environment for FORT:studio (tracking data analysis) ..."
sudo apt-get install -y libopencv-dev libeigen3-dev libprotobuf-dev libasio-dev qt5-default


## TODO: Euresys driver install
#echo "Installing the build environment for FORT:artemis (FORmicidae Tracker) ..."
## Note: requires some FORT:hermes dependences: libprotobuf-dev libasio-dev
## NOTE: requires installation of Euresys grabber drivers
#sudo apt-get install -y ... 

echo "Installing build environment for FORT:olympus (web UI) ..."
sudo apt install -y npm
#sudo npm install -g @angular/cli typescript


# libopencv-dev
#Protobuf 3.3.0, Asio, Typescript
#protobuf
#	libprotobuf-dev

ERR=$?
if [ $ERR -ne 0 ]; then
	echo "ERROR, installation of the build environment is failed, error code: $ERR"
	exit $ERR
fi
