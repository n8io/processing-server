#!/bin/bash
set -e
echo "Installing dependencies..."
apt-get update -y >/dev/null
apt-get install -y \
  git \
  screen \
  python3-setuptools \
  python3-appdirs \
  python3-dateutil \
  python3-requests \
  python3-sqlalchemy \
  python3-pip \
  w3m \
  fuse \
  jq \
  unzip \
  inotify-tools \
  libxml2-utils \
  glances \
  ;
pip install subliminal
apt-get install -y \
  encfs \
  ;
MSG="Successfully initialized dependencies."; \
echo -e "\e[32m${MSG}\e[0m"
