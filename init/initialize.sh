#!/bin/sh -e

#
# init/initialize.sh - After the new neubot distribution has been copied on
# a sliver, this script removes the old neubot (if any) and installs the new
# neubot on the sliver.
#
# Written by Stephen Soltesz and Simone Basso.
#
# =======================================================================
# This file is part of Neubot <http://www.neubot.org/>.
# 
# Neubot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#   
# Neubot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Neubot.  If not, see <http://www.gnu.org/licenses/>.
# =======================================================================
#

if [ `id -u` -ne 0 ]; then
    echo "$0: FATAL: need root privileges" 1>&2
    exit 1
fi

cd /home/mlab_neubot

if [ -f neubot-server.tar.gz ]; then

    if [ -x /home/mlab_neubot/neubot-server/M-Lab/uninstall.sh ]; then
        echo "uninstall previous neubot"
        /home/mlab_neubot/neubot-server/M-Lab/uninstall.sh
    fi

    echo "extract new neubot"
    tar -xzf neubot.tar.gz

    echo "install new neubot"
    /home/mlab_neubot/neubot-server/M-Lab/install.sh

    # Note: would be wrong to cleanup because tarball is installed by the RPM
    #echo "cleanup"
    #rm -rf neubot-server.tar.gz

else
    echo "FATAL: neubot.tar.gz missing" 1>&2
    exit 1
fi
