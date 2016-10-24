# Neubot support for M-Lab

Support scripts for Neubot on M-Lab.

## Install development tools

```
yum --disablerepo=epel groupinstall -y 'Development tools'
```

## Build RPM from development branch

```
cd /tmp
git clone --recursive -b develop https://github.com/neubot/neubot-support.git
cd neubot-support
git checkout <tag>
./package/slicebuild.sh neubot
find . -type f -name \*.rpm
```
