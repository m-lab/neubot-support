#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "usage: $0 <server> <parallelism>" 1>&2
    exit 1
fi

# params:
max_runtime_min=30
test_server=$1; shift
parallel=$1; shift

clone() {
    if [ ! -d `basename $1` ]; then
        git clone --single-branch --depth 1 --branch $2 https://github.com/$1
    fi
}

clone "neubot/neubot" "0.4.16.9"
clone "measurement-kit/measurement-kit" "stable"

# This assumes you have installed MK dependencies (libevent-dev, libssl-dev,
# and libgeoip-dev), you have a C++11 compiler etc.
(
    if [ ! -x ./measurement-kit/measurement_kit ]; then
        cd measurement-kit
        ./autogen.sh -n
        ./configure
        make V=0 -j2
    fi
)

child() {
    max_runtime_sec=$(($max_runtime_min * 60))
    begin=`date +%s`
    while [ $((`date +%s` - $begin)) -lt $max_runtime_sec ]; do
        (
            cd neubot
            ./UNIX/bin/neubot speedtest -fA $test_server
        )
        (
            cd neubot
            ./UNIX/bin/neubot bittorrent -fA $test_server
        )
        (
            cd neubot
            ./UNIX/bin/neubot raw -fA $test_server
        )
        (
            cd neubot
            ./UNIX/bin/neubot dash -fA $test_server
        )
        (
            cd measurement-kit
            ./measurement_kit ndt -vT download -T download-ext $test_server
        )
    done
}

trap 'kill $(jobs -p)' EXIT

set +e
count=1
while [ $count -lt $parallel ]; do
    child &
    count=$(($count + 1))
done
child
