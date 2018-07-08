#!/bin/bash

CONFIG_FOLDER=${NV_CONFIG:-$HOME/.config/nv}

BIN_LINK=$CONFIG_FOLDER/current
NODE_INSTALLATION=$CONFIG_FOLDER/dist

NODE_VERSION_REGEX='s/\([0-9]*\.[0-9]*\.[0-9]\).*/\1/p'

NODE_LATEST_DIST_URL="https://nodejs.org/dist/latest/"
NODE_CARBON_DIST_URL="https://nodejs.org/dist/latest-carbon/"
NODE_BORON_DIST_URL="https://nodejs.org/dist/latest-boron/"
NODE_ARGON_DIST_URL="https://nodejs.org/dist/latest-argon/"

REMOTE_URLS=($NODE_LATEST_DIST_URL $NODE_CARBON_DIST_URL $NODE_BORON_DIST_URL $NODE_ARGON_DIST_URL)
REMOTE_NAME=("latest" "carbon" "boron" "argon")

NV_VERSION="v0.1.0"

wget=$(which wget)

net_get_latest_version () {
  $wget -qO- $1 | grep node-v | sed 's/<a href="node-v//' | head -1 | sed -n $NODE_VERSION_REGEX
}

_list_remote () {
  echo "Getting remote versions"
  echo "This might take a while..."
  echo
	
  v=0
  for url in ${REMOTE_URLS[@]}; do
    version=$(net_get_latest_version $url)	
    if [ -d "$NODE_INSTALLATION/$version" ]; then
      echo "  [x] $version (${REMOTE_NAME[$v]})"
    else
      echo "  [ ] $version (${REMOTE_NAME[$v]})"
    fi
    v=$((v + 1))
  done

  echo 
  echo "[x] -> Downloaded"
  echo "[ ] -> Not downloaded"
}

_list_local () {
  echo "Getting installed versions"
  node_path=$(which node 2>&-)
  if [ ! $? = 0 ]; then
    echo "No installations of node is being used"
  elif [ "$BIN_LINK/node" != "$node_path" ]; then
    echo "Node installation is not under nv"
    echo "Its possible that current installation of node is installed directly on tthe system"
    echo 
    echo "Node path found -> $node_path"
  else 
    selected=$(node --version 2>&- | sed 's/v//') 
  fi
  echo
  echo "Downloaded versions:"
  for i in $(ls $NODE_INSTALLATION); do
    if [ "$selected" = "$i" ]; then
      echo "  *$i"
    else
      echo "   $i"
    fi
  done
  echo
  echo "* -> selected"
}

list_cmd () {
  if [ ! -z $1 ]; then
    case $1 in 
      -r|--remote)
        _list_remote
        ;;
      *)
        echo "Unknown parameter $1 for list command"
        exit 1
    esac
  else
    _list_local
  fi
}

get_cmd () {
  version=$1
  shift

  # Get OS and Arch
  OS=$(uname -s | awk '{print tolower($0)}')
  ARCH=$(uname -m)

  if [ $ARCH == "x86_64" ]; then
    ARCH="x64"
  fi

  # Get latest version if no version is passed 
  if [ -z $version ]; then
    echo "Geting latest version from remote"
    version=$(net_get_latest_version $NODE_LATEST_DIST_URL)
    echo "Downloading version $version"
  else
    # Check if version name was passed 
    case $version in 
      latest|LATEST)
        version=$(net_get_latest_version $NODE_LATEST_DIST_URL)
        echo "Current latest is $version"
        ;;
      carbon|CARBON)
        version=$(net_get_latest_version $NODE_CARBON_DIST_URL)
        echo "Current carbon is $version"
        ;;
      boron|BORON)
        version=$(net_get_latest_version $NODE_BORON_DIST_URL)
        echo "Current boron is $version"
        ;;
      argon|ARGON)
        version=$(net_get_latest_version $NODE_ARGON_DIST_URL)
        echo "Current argon is $version"
        ;;
    esac
  fi

  filename="node-v$version-$OS-$ARCH.tar.xz"
  url="https://nodejs.org/dist/v$version/$filename"
  if [ -d "$NODE_INSTALLATION/$version" ]; then
    echo "Version $version already installed"	
    echo
    echo "To use this version, you can type \`nv use $version\`"
    echo "  \`nv use $version\`"
    echo "Or simply:"
    echo "  \`nv use\`"
    echo "if you'd like to use the latest vesrsion"
    exit 1
  fi
  if [ ! -f /tmp/$filename ]; then
    mkdir -p $CONFIG_FOLDER/logs
    $wget -O /tmp/$filename $url 2> $CONFIG_FOLDER/logs/wget.log
    if [ $? != 0 ]; then
      cat $CONFIG_FOLDER/logs/wget.log
      echo "\nwget exited with error."
      exit 1
    fi
  fi
  mkdir -p $NODE_INSTALLATION
  tar -xvf /tmp/$filename -C $NODE_INSTALLATION
  mv $NODE_INSTALLATION/node-v$version* $NODE_INSTALLATION/$version
  if [ $? != 0 ]; then
    echo "\nFailed to extract /tmp/$filename into $target_dir"
    exit 1
  fi
}

use_cmd () {
  version=$1
  if [ -z $version ]; then
    echo "Please specify a version"
    echo "usage: nv use <version>"
    echo
    exit 1
  fi
  echo "Using node $version"
  folder="$NODE_INSTALLATION/$version/bin"
  if [ ! -d $folder ]; then
    echo "Could not find folder $folder"
    echo "Invalid version $version of nodejs"
    echo "Try installing with \`nv get $version\`"
    exit 1
  else	
    echo "Using installation in folder $folder" 
  fi
  if [ -d $BIN_LINK ]; then
    rm $BIN_LINK
  fi
  ln -s $folder $BIN_LINK
}

update_cmd () {
  echo "Updating Node Versioning"
  repo="https://github.com/fredrb/nv.git"
  git=$(which git)
  if [ $? != 0 ]; then
    echo "Could not found git.\nPlease install git before installing Node Versioning"
    exit 1
  fi
  if [ ! -d $CONFIG_FOLDER/.git ]; then
    echo "\`nv update\` only works if nv config folder was setup as a git repository."
    echo "If you installed manually, you can pull the newest changes to update nv command"
    exit 1
  fi
  pushd $CONFIG_FOLDER
  $git pull origin master
  popd
  echo "Node Versioning updated $(nv version)"
}

version_cmd () {
  echo $NV_VERSION
}

print_help () {
  echo "usage: nv command [options]"
  echo
  echo "command:"
  echo
  echo "  list [options]:"
  echo "    prints all installed versions"
  echo "    options:"
  echo "      --remote|-r: print available release versions"
  echo
  echo "  get <version>:"
  echo "    downloads and install version number"
  echo "    (e.g. nv get 10.4.0)" 
  echo "    version can be either version number or release names (latest|carbon|boron|argon)"
  echo "    (e.g. nv get latest)" 
  echo 
  echo "  use <version>:"
  echo "    selects version as current node version"
  echo "    (e.g. nv use 10.4.0)" 
  echo
  echo "  update:"
  echo "    self update nv command"
  echo 
  echo "  help:"
  echo "    prints this help text"
}

command=$1
shift
case $command in
  list)
    list_cmd "$@"
    ;;
  get)
    get_cmd "$@"
    ;;
  use)
    use_cmd "$@"
    ;;
  update)
    update_cmd "$@"
    ;;
  version|-v|--version)
    version_cmd "$@"
    ;;
  help|*)
    print_help
    ;;
esac
