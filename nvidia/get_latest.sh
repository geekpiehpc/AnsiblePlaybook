#!/bin/bash

#
# get_nvidia_driver.sh
#
#
# quick and dirty script to fetch nVidia's latest driver for Linux.
#
# ./get_nvidia_driver.sh -h for help
# auth murez
#

# First, test if requirements are met
requirements="wget"
for r in $requirements
do
        which $r > /dev/null
        if [ -$? -ne 0 ]
        then
                echo -e "\nERROR - $r not found. Please install it and try again...\n"
                exit 1
        fi 
done

# some variables
nvidia_url=https://download.nvidia.com/XFree86/Linux-x86_64     # URL where the drivers are
nvidia_latest=$nvidia_url/latest.txt                            # file with the latest info
target_dir=$(pwd)                                               # where to store the downloaded file

 function banner() {

    echo -e "\nLinux nVidia Driver Downloader"
    echo "by GeekPieHPC"
    echo -e "==============================\n"
}

function goodbye() {
    echo -e "= Doing some clean up..."
    rm -f latest.txt
    echo -e "\n=== All set.\n"
    exit 0
}

function usage() {  # option: -h
    cat << EOF
$(basename $0) [-h][-d][-i]
            -h Prints this help
            -d Download only 
            -i (root only) Download and install
            -c Check latest only (no download, no install)
            
EOF
}

function returnStatus { # helper funcion
    if [[ $? -eq 0 ]]
    then
        echo -e "[ PASS ]"
    else
        echo -e "[ FAIL ]"
    fi
}

function get_latest() {
    # get latest version
    echo -e "= Fetching latest nVidia driver version... \c"
    wget -q $nvidia_latest -O latest.txt
    returnStatus
    nvidia_driver=$(awk '{ print $2 }' latest.txt)
    nvidia_driver_version=$(awk '{ print $1 }' latest.txt)
    nvidia_driver_file=$(awk -F/ '{ print $2 }' latest.txt)
    echo "= Latest version available on nVidia's website: $nvidia_driver_version"
}


function download_file() {  # and another helper function
    if [ -r $target_dir/$nvidia_driver_file ]
        then
            echo "= Found local copy of $nvidia_driver_file ..."
            ls -l $target_dir/$nvidia_driver_file
        else
            echo -e "= Downloading latest nVidia driver file... \n"
            curl $nvidia_url/$nvidia_driver -o $target_dir/$nvidia_driver_file
        fi
}
        
function download_only() {  # option: -d
    if [ -r $target_dir/$nvidia_driver_file ]
    then
        echo "= Found local copy of $nvidia_driver_file ..."
        ls -l $target_dir/$nvidia_driver_file
    else
        download_file
        echo "= I placed a copy of the downloaded file under $target_dir"
        echo "= and also added execution permissions to it..."
        chmod +x $target_dir/$nvidia_driver_file
        ls -l $target_dir/$nvidia_driver_file
    fi

}

function download_install() {   # option: -i
 
    download_file
    
    echo -e "\n= Following needs to happen::\n"
    echo -e "\t 1) take the system to run-level 3"
    echo -e "\t 2) run the install script I just downloaded\n"
    
    echo -e "= Let me add execution permissions to $target_dir/$nvidia_driver_file ...\c"
    chmod +x $target_dir/$nvidia_driver_file
    returnStatus
    
    echo -e "\n= Now, please, run the following commands:"
    echo -e "\n\tinit 3"
    echo -e "\n\t$target_dir/$nvidia_driver_file -Xq\n"
    echo "= After that, you will need to reboot your system."

}

function ru_root() {    # another helper function
    # check if we are root.. if not, stop right here, right now.
    # may be an unnecessary check but, hey! you never know...
    if [[ $UID -ne 0 ]]
    then
        echo -e "\tWARNING - Nice try! Are you root?..."
        echo -e "\tBecome root and run this script again...\n"
        exit 3
    fi
}

#------------------------------------------------------
# Main
#------------------------------------------------------

set -- `getopt hdic $*`

if [[ $? -ne 0 ]]
then
        usage
        exit
fi

banner

for arg in $*
do
        case $arg in
        -h) usage; exit 1;;
        -d) get_latest; download_only; goodbye; exit 0;;
        -i) ru_root; get_latest; download_install; goodbye; exit 0;;
        -c) get_latest; goodbye; exit 0;;
        *) usage; exit 0;;
        esac
done
