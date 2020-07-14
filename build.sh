#!/bin/sh
#
# \description  Build client components of AnDeT (Ant Development Tracker)
# Note: this script is designed for Linux Ubuntu and might also work on Debian
# or other Linuxes
#
# \author Artem Lutov <lutov.analytics@gmail.com>

# build [-i,--initial] [component]
# components: leto-cli, tag-layouter, studio

./install_reqs.sh
# Update all submodules
git submodule update --recursive

#go get -u github.com/formicidae-tracker/leto/leto-cli
# Client for tracking configuration and live tracking video
cd leto/leto-cli && \
go build -i . && \
cd ../..

# Tag families drawing app
cd tag-layouter && \
git submodule update --init && \
make
# TODO: fix an error
#make

# FORT Studio and Myrmidon API to analyze tracking data
cd studio
# -p to omit error if the directory is already exists
mkdir -p build && \
cd build && \
cmake .. && \
make -j 4
