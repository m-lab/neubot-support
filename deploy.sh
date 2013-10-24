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

for SLIVER in $*; do
    echo "=== BEGIN DEPLOY $SLIVER ==="

    (
        set -e

        $DEBUG mlab_scp $RPM $SLIVER:

        $DEBUG mlab_ssh $SLIVER sudo init/stop.sh || true

        # Note: avoid sliver recreation
        $DEBUG mlab_ssh $SLIVER sudo rm -f /etc/mlab/slice.installed

        $DEBUG mlab_ssh $SLIVER sudo yum -y update $RPM

        # Idempotent
        $DEBUG mlab_ssh $SLIVER sudo touch /etc/mlab/slice.installed

        $DEBUG mlab_ssh $SLIVER sudo init/initialize.sh || true
        $DEBUG mlab_ssh $SLIVER sudo init/start.sh || true

        $DEBUG mlab_ssh $SLIVER rm $RPM

    )

    echo "=== END DEPLOY $SLIVER ==="
    echo ""
    echo ""

    sleep 30
done
