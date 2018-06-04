CONFIG_FOLDER=$HOME/.config/nv
CONFIG_FILE=$CONFIG_FOLDER/node_versions.config
BIN_LINK=$CONFIG_FOLDER/bin

wget=$(which wget)

list_cmd () {
	echo "Reading from $CONFIG_FILE"
	cat $CONFIG_FILE
}

get_cmd () {
	version=$1
	shift
	if [ -z $version ]; then
		version=$(cat $CONFIG_FILE | grep latest | gawk '{ print $1 }')
	fi
	filename="node-v$version-linux-x64.tar.xz"
	url="https://nodejs.org/dist/v$version/$filename"	
	folder="$CONFIG_FOLDER/node-v$version-linux-x64"
	if [ -d $folder ]; then
		echo "Version $version already installed"	
		echo "\nTo use this version, you can type \`nv use $version\`"
		echo "\t\`nv use $version\`"
		echo "Or simply:"
		echo "\t\`nv use\`"
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
	tar -xvf /tmp/$filename -C $CONFIG_FOLDER/
	if [ $? != 0 ]; then
		echo "\nFailed to extract /tmp/$filename into $CONFIG_FOLDER"
		exit 1
	fi
}

use_cmd () {
	version=$1
	if [ -z $version ]; then
		echo "Getting latest version..."
		version=$(cat $CONFIG_FILE | grep latest | gawk '{ print $1 }')
	fi
	echo "Using node $version"
	local NODE_VERSION=$version
	if [ -f $HOME/.nversion ]; then
		rm $HOME/.nversion
	fi
	echo $version >> $HOME/.nversion
	folder="$CONFIG_FOLDER/node-v$version-linux-x64/bin"
	if [ ! -d $folder ]; then
		echo "Could not find folder $folder\n"
		echo "Invalid version $version of nodejs"
		echo "Try installing with \`nv get $version\`"
		exit 1
	else	
		echo "Node folder set to $folder" 
	fi
	if [ -d $BIN_LINK ]; then
		rm $BIN_LINK
	fi
	ln -s $folder $BIN_LINK
}

init_cmd () {
	if [ ! -z $HOME/.nversion ]; then
		local NODE_VERSION=$(cat $HOME/.nversion) 
		use_cmd $NODE_VERSION
	fi
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
	init)
		init_cmd "$@"
		;;
	*)
		print_help
		;;
esac
