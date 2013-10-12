neubot-support
==============

Support scripts for Neubot on M-Lab

    yum groupinstall -y 'Development tools'  # if not already done

    git clone --recursive https://github.com/m-lab-tools/neubot-support.git
    cd neubot-support
    git checkout <tag>
    ./package/slicebuild.sh neubot
