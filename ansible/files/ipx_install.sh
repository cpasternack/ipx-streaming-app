#!/usr/bin/env bash
set -x
cd $HOME/ipx
echo "installing ipx, ipxripd"
export DEBIAN_FRONTEND=noninteractive
dpkg -i -E --refuse-all ./ipx_2.2.6-8_amd64.deb
dpkg -i -E --refuse-all ./ipxripd_0.7-13.1_amd64.deb
export DEBIAN_FRONTEND=interactive
exit $?
