# Neubot support for M-Lab

Support scripts for Neubot on M-Lab.

## Build RPM from development branch

Login on a development machine (i.e. mlab4.prg01), then:

### Install development tools

```
yum --disablerepo=epel groupinstall -y 'Development tools'
```

### Clone the repository

```
cd /tmp
git clone --recursive -b develop https://github.com/neubot/neubot-support.git
```

### Run the slicebuild.sh script

```
cd neubot-support
git checkout <tag>
./package/slicebuild.sh mlab_neubot
find . -type f -name \*.rpm
```
