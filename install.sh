#!/bin/bash

NV_CONFIG=$HOME/.config/nv

NV_REPO="https://fredericorb@bitbucket.org/fredericorb/nv.git"

GIT_CLONE_FLAGS="--depth 1"

install () {
  echo "Installing Node Versioning"
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
  echo "Setting up bin and nbin folders"
  mkdir -p $NV_CONFIG/bin
  ln -s $NV_CONFIG/nv.sh $NV_CONFIG/bin/nv
  add_path="export PATH=\"\$PATH:$HOME/.config/nv/bin:$HOME/.config/nv/nbin\""
  echo "Adding $add_path to $HOME/.profile"
  echo  $add_path >> $HOME/.profile
}

install
