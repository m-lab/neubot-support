# Neubot support for M-Lab

Support scripts for Neubot on M-Lab.

## Build RPM from development branch

Login on a development machine (e.g.
neubot.mlab.mlab4.prg01.measurement-lab.org), then:

### Install development tools

```
yum --disablerepo=epel groupinstall -y 'Development tools'
```

### Clone the repository

```
cd /tmp
rm -rf mlab-neubot-support
git clone --recursive -b develop https://github.com/neubot/mlab-neubot-support.git
```

### Run the slicebuild.sh script

```
cd mlab-neubot-support
git tag
git checkout $tag # very important to make the RPM package
./package/slicebuild.sh mlab_neubot
find /tmp -type f -name \*.rpm
# scp the generated rpm from that sliver to your machine
```

### Test the new RPM

You can use the `deploy.sh` script to test the RPM to another testing sliver
(e.g. neubot.mlab.mlab1.nuq0t.measurement-lab.org).

Run:

```
./deploy.sh $rpm neubot.mlab.mlab1.nuq0t.measurement-lab.org
```
