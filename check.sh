#!/bin/sh
# Public domain, 2013 Simone Basso <bassosimone@gmail.com>

#
# Make sure that the nodes are correctly deployed
#

DEBUG=

for SLIVER in $*; do
    (
        set -e
        echo "=== BEGIN CHECK $SLIVER ==="

        echo ""
        echo ""

        cd neubot

        ./UNIX/bin/neubot bittorrent -A $SLIVER -f

        echo ""
        echo ""

        ./UNIX/bin/neubot dash -A $SLIVER -f

        echo ""
        echo ""

        ./UNIX/bin/neubot raw -A $SLIVER -f

        echo ""
        echo ""

        ./UNIX/bin/neubot speedtest -A $SLIVER -f

        echo ""
        echo ""

        echo "=== END CHECK $SLIVER ==="
        echo ""
        echo ""
    )

    sleep 3
done
