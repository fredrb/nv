NV_CONFIG=$HOME/.config/nv
NV_VERSIONS=$NV_CONFIG/node_versions.config

NV_REPO="https:some"

GIT_CLONE_FLAGS="--depth 1"

install () {
	git=$(which git)
	if [ $? != 0 ]; then
		echo "Could not found git.\nPlease install git before installing Node Versioning"
		exit 1
	fi
	if [ -d $NV_CONFIG ]; then
		echo "An installation of NV already existis"
		echo "If you'd like to update your installation run \`nv update\` instead"
		exit 1
	fi
	$git clone $GIT_CLONE_FLAGS $NV_REPO $NV_CONFIG
	mkdir -p $NV_REPO/bin
	mkdir -p $NV_REPO/nbin
	ln -s $NV_REPO/nv.sh $NV_REPO/bin/nv
	echo "export PATH=$PATH:$HOME/.config/nv/bin:$HOME/.config/nv/nbin" >> $HOME/.profile
}

install
