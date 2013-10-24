#!/bin/sh
# Public domain, 2013 Simone Basso <bassosimone@gmail.com>

#
# Manually deploy the RPM on M-Lab
#

DEBUG=

if [ $# -lt 2 ]; then
    echo "usage: $0 rpm host [host ...]" 1>&2
    exit 1
fi

RPM=$1
shift

for NODE in $*; do
    (
        set -e
        echo "=== BEGIN DEPLOY $NODE ==="

        $DEBUG mlab_scp $RPM $NODE:

        $DEBUG mlab_ssh $NODE sudo init/stop.sh || true

        # Note: avoid sliver recreation
        $DEBUG mlab_ssh $NODE sudo rm -f /etc/mlab/slice.installed

        $DEBUG mlab_ssh $NODE sudo yum -y update $RPM

        # Idempotent
        $DEBUG mlab_ssh $NODE sudo touch /etc/mlab/slice.installed

        $DEBUG mlab_ssh $NODE sudo init/initialize.sh || true
        $DEBUG mlab_ssh $NODE sudo init/start.sh || true

        $DEBUG mlab_ssh $NODE rm $RPM

        echo "=== END DEPLOY $NODE ==="
        echo ""
        echo ""
    )

    sleep 30
done
