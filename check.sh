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

        echo ""
        echo ""

        cd neubot

        ./UNIX/bin/neubot bittorrent -A $NODE -f

        echo ""
        echo ""

        ./UNIX/bin/neubot dash -A $NODE -f

        echo ""
        echo ""

        ./UNIX/bin/neubot raw -A $NODE -f

        echo ""
        echo ""

        ./UNIX/bin/neubot speedtest -A $NODE -f

        echo ""
        echo ""

        echo "=== CHECK DEPLOY $NODE ==="
        echo ""
        echo ""
    )

    sleep 3
done
