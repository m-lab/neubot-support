# Neubot support for M-Lab

Support scripts for Neubot on M-Lab.

## Update to latest neubot-server

```
cd neubot-server
git checkout mlab
git pull
cd ..
git commit -am "Update to latest neubot-server"
```

## Build RPM from development branch

Login on a development machine (e.g.
neubot.mlab.mlab4.prg01.measurement-lab.org), then:

### Install development tools

```
sudo yum --disablerepo=epel groupinstall -y 'Development tools'
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

### Check list for testing

- [ ] deploy on a testing machine
- [ ] test using `./test.sh`
- [ ] make sure test results are written on disk and parse as JSON
- [ ] make sure rsync and syslog are running on the sliver
- [ ] make sure the memory usage of neubot and botticelli is reasonable
- [ ] both are running under the expected non privileged user
- [ ] data is being collected from the sliver
