#!/usr/bin/env bash
set +x
VGLDIR="/opt/VirtualGL/bin"
cd $HOME/vgl
dpkg -i -E --refuse-all ./turbovnc_2.2.5_amd64.deb
dpkg -i -E --refuse-all ./virtualgl_2.6.3_amd64.deb
dpkg -i -E --refuse-all ./virtualgl32_2.6.3_amd64.deb
if [ -d "$VGLDIR" ]
then
  "$VGLDIR"/vglserver_config -config +s +f +t
fi
exit $?
