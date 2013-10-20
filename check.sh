#!/bin/sh
# Public domain, 2013 Simone Basso <bassosimone@gmail.com>

#
# Make sure that the nodes are correctly deployed
#

DEBUG=

for NODE in $*; do
    (
        set -e
        echo "=== BEGIN CHECK $NODE ==="

        cd neubot

        ./UNIX/bin/neubot dash -A $NODE -f

        echo "=== CHECK DEPLOY $NODE ==="
        echo ""
        echo ""
    )

    sleep 3
done
