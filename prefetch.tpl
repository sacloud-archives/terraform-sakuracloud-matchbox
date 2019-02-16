#!/usr/bin/env bash

set -ex

mkdir -p /opt/matchbox/assets/coreos/${version}

if [ ! -e "/opt/matchbox/assets/coreos/${version}/${kernel}" ]; then
  wget --tries=3 -O /opt/matchbox/assets/coreos/${version}/${kernel}    ${url_prefix}/${version}/${kernel}
fi

if [ ! -e "/opt/matchbox/assets/coreos/${version}/${initrd}" ]; then
  wget --tries=3 -O /opt/matchbox/assets/coreos/${version}/${initrd}    ${url_prefix}/${version}/${initrd}
fi

if [ ! -e "/opt/matchbox/assets/coreos/${version}/${image} " ]; then
  wget --tries=3 -O /opt/matchbox/assets/coreos/${version}/${image}     ${url_prefix}/${version}/${image}
fi

if [ ! -e "/opt/matchbox/assets/coreos/${version}/${image}.sig" ]; then
  wget --tries=3 -O /opt/matchbox/assets/coreos/${version}/${image}.sig ${url_prefix}/${version}/${image}.sig
fi

if [ ! -e "/opt/matchbox/assets/coreos/${version}/version.txt" ]; then
  wget --tries=3 -O /opt/matchbox/assets/coreos/${version}/version.txt  ${url_prefix}/${version}/version.txt
fi

FETCHED_VERSION=`cat /opt/matchbox/assets/coreos/${version}/version.txt | sed -n 's/^COREOS_VERSION=//p'`
if [ "$${FETCHED_VERSION}" != ""${version}"" -a ""${version}"" == "current" ]; then
  if [ ! -e /opt/matchbox/assets/coreos/$${FETCHED_VERSION} ]; then
    mv /opt/matchbox/assets/coreos/${version} /opt/matchbox/assets/coreos/$${FETCHED_VERSION}
  fi

  # Unfortunately, Matchbox assets API don't support symbolic link, so we copy assets.
  cp -r /opt/matchbox/assets/coreos/$${FETCHED_VERSION} /opt/matchbox/assets/coreos/${version}
fi