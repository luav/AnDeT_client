#!/bin/sh
#
# \description  Install external system libraries for client components of AnDeT
# Note: this script is designed for Linux Ubuntu and might also work on Debian
# or other Linuxes
#
# \author Artem Lutov <lutov.analytics@gmail.com>

# Target OS: Linux
# Actual build OS: Linux Debian 9 + / Ubuntu 18.04+

# Update and init all submodules
git submodule update --init --recursive

# Common development packages required to build executables
echo "Installing common build environment ..."
echo "-- make --"
make --version
ERR=$?
if [ $ERR -ne 0 ]; then
	sudo apt-get install -y build-essential	make g++ cmake bc
fi

echo "-- g++ --"
g++ --version
ERR=$?
if [ $ERR -ne 0 ]; then
	sudo apt-get install -y g++
fi

echo "-- cmake --"
cmake --version
ERR=$?
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
# leto (live tracking video and tracking configuration)
whereis go | grep go > /dev/null
ERR=$?
if [ $ERR -ne 0 ]; then
	echo "Installing build environment for leto (live tracking video and tracking configuration) ..."
	sudo apt-get install -y golang
fi

#tag-layouter (tags drawing)
whereis go | grep go > /dev/null
ERR=$?
if [ $ERR -eq 0 ]; then
	# Note: opencv is not detectable via `whereis``
	dpkg -l | grep libopencv > /dev/null
	ERR=$?
fi
if [ $ERR -ne 0 ]; then
	echo "Installing build environment for tag-layouter (tags drawing) ..."
	sudo apt-get install -y golang libopencv-dev
fi

# studio (tracking data analysis)
dpkg -l | grep libopencv > /dev/null
ERR=$?
if [ $ERR -eq 0 ]; then
	whereis eigen3 | grep eigen3 > /dev/null
	ERR=$?
fi
if [ $ERR -eq 0 ]; then
	whereis libprotobuf | grep libprotobuf > /dev/null
	ERR=$?
fi
if [ $ERR -eq 0 ]; then
	whereis asio | grep asio > /dev/null
	ERR=$?
fi
if [ $ERR -eq 0 ]; then
	whereis qt5 | grep qt5 > /dev/null
	ERR=$?
fi
if [ $ERR -ne 0 ]; then
	echo "Installing build environment for studio (tracking data analysis) ..."
	sudo apt-get install -y libopencv-dev libeigen3-dev libprotobuf-dev libasio-dev qt5-default
fi

## TODO: Euresys driver install
#echo "Installing the build environment for FORT:artemis (FORmicidae Tracker) ..."
## Note: requires some FORT:hermes dependences: libprotobuf-dev libasio-dev
## NOTE: requires installation of Euresys grabber drivers
#sudo apt-get install -y ... 


if [ $ERR -eq 0 ]; then
	ERR=$?
fi
if [ $ERR -ne 0 ]; then
	echo "ERROR, installation of the build environment is failed, error code: $ERR"
	exit $ERR
fi
