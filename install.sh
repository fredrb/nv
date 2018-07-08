#!/bin/bash

NV_CONFIG="${NV_CONFIG:-$HOME/.config/nv}"
NV_SHELL_FILE="${NV_SHELL_FILE:-$HOME/.profile}"
NV_REPO="https://github.com/fredrb/nv.git"

GIT_CLONE_FLAGS="--depth 1"

install () {
  echo "Installing nv (Node Versioning)"
  git=$(which git)
  if [ $? != 0 ]; then
    echo "Could not found git.\nPlease install git before installing Node Versioning"
    exit 1
  fi
  if [ -d $NV_CONFIG ]; then
    echo "An installation of nv already existis"
    echo "If you'd like to update your installation run \`nv update\` instead"
    exit 1
  fi
  $git clone $GIT_CLONE_FLAGS $NV_REPO $NV_CONFIG
  echo "Setting up bin and current folders"
  mkdir -p $NV_CONFIG/bin
  ln -s $NV_CONFIG/nv.sh $NV_CONFIG/bin/nv
  config_folder="export NV_CONFIG=\"$NV_CONFIG\""
  echo "Adding $config_folder to $NV_SHELL_FILE"
  echo  $config_folder >> $NV_SHELL_FILE
  add_path="export PATH=\"\$PATH:$NV_CONFIG/bin:$NV_CONFIG/current\""
  echo "Adding $add_path to $NV_SHELL_FILE"
  echo  $add_path >> $NV_SHELL_FILE
}

install
