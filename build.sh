#!/bin/bash
#
# \description  Build client components of AnDeT (Ant Development Tracker)
# Note: this script is designed for Linux Ubuntu and might also work on Debian
# or other Linuxes
#
# \author Artem Lutov <lutov.analytics@gmail.com>

USAGE="$0 -h | [-i,--init] [<component>=ALL]
  -h,--help  - help, show this usage description
  -i,--init  - initialize the build environment, which should be done only when building the project for the first time
  <component>  - {leto-cli, tag-layouter, studio, ALL}

  Examples:
  \$ $0 -i
  \$ $0 tag-layouter
"

INIT=0  # Whether to initialize the build environment
TARG='ALL'  # Target component to be built
while [ $1 ]; do
	case $1 in
	-h|--help)
		# Use defaults for the remained parameters
		#echo -e $USAGE # -e to interpret '\n\
        printf "$USAGE"
		exit 0
		;;
	-i|--init)
		if [ "${2::1}" == "-" ]; then
			echo "ERROR, invalid argument value of $1: $2"
			exit 1
		fi
		INIT=1
		echo "Build environment initialzation is activated"
		shift
		;;
	*)
        # Set th building component
    	if [ $1 != 'ALL' ]; then
            TARG=$1
        fi
		shift
        if [ $1 ]; then
            printf "Error: Invalid option specified: $1 ...\n\n$USAGE"
            exit 1
        fi
		;;
	esac
done

# Initialize the build environment if required
if [ $INIT -ne 0 ]; then
    ./install_reqs.sh

    ERR=$?
    if [ $ERR -ne 0 ]; then
        echo "ERROR, installation of the build environment is failed, error code: $ERR"
        exit $ERR
    fi
fi

# Update all submodules
git submodule update --recursive

NBUILDS=0  # The number of all builds

# Client for tracking configuration and live tracking video
ERR_LETO=0
PROJ='leto-cli'
if [ $TARG == 'ALL' -o $TARG == $PROJ ]; then
    echo "Building $PROJ ..."
    #go get -u github.com/formicidae-tracker/leto/leto-cli
    cd leto/$PROJ && \
    go build -i . && \
    cd ../..
    ERR_LETO=$?
    ((++NBUILDS))
fi

# Tag families drawing app
PROJ='tag-layouter'
ERR_TAG=0
if [ $TARG == 'ALL' -o $TARG == $PROJ ]; then
    echo "Building $PROJ ..."
    cd $PROJ && \
    git submodule update --init && \
    make
    # TODO: fix an error
    #make
    ERR_TAG=$?
    ((++NBUILDS))
fi

# FORT Studio and Myrmidon API to analyze tracking data
PROJ='studio'
ERR_STUD=0
if [ $TARG == 'ALL' -o $TARG == $PROJ ]; then
    echo "Building $PROJ ..."
    cd $PROJ
    # -p to omit error if the directory is already exists
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j 4
    ERR_STUD=$?
    ((++NBUILDS))
fi

# Report the build execution status
if [ $ERR_LETO -ne 0 -o $ERR_TAG -ne 0 -o $ERR_STUD -ne 0 ]; then
	echo "ERROR, some builds were failed, errorcodes:
  leto-cli: $ERR_LETO
  tag-layouter: $ERR_TAG
  studio: $ERR_STUD
"
	exit 1
fi

if [ $NBUILDS -eq 0 ]; then
    echo "ERROR: the specified component is unknown: $TARG"
    exit 1
fi

echo "Successfully completed boulds: $NBUILDS"
