# Neubot support for M-Lab

Support scripts for Neubot on M-Lab.

⚠: This is probably the latest package to be deployed on the legacy
M-Lab infrastructure. As such, and given that the ship is really
burning, I took the liberty of using somehow different instructions
to workaround several issues causes by the age of the platform. In
the interest of reproducibility, I have documented these steps below
using the `⚠' sign to indicate what I did differently from the
original instructions (-Simone 2019-03-26).

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

⚠:The above command failed when I run it. So, I basically did install
the required packages manually. The `slicebuild.sh` script is nice
enough that it tells you what is missing before proceeding.

### Clone the repository

```
cd /tmp
rm -rf mlab-neubot-support
git clone --recursive -b develop https://github.com/neubot/mlab-neubot-support.git
```

⚠: The version of git in the slice uses a version of cURL that uses SSLv3
that, in turn, is not supported anymore by GitHub. I worked around this
by cloning locally and remotely copying the cloned directory.

### Run the slicebuild.sh script

```
cd mlab-neubot-support
git tag
git checkout $tag # very important to make the RPM package
./package/slicebuild.sh mlab_neubot
find /tmp -type f -name \*.rpm
# scp the generated rpm from that sliver to your machine
```

⚠: `slicebuild.sh` fails because a `sliceversion.sh` also attempts to
fetch from GitHub. I worked around this with this diff:

```
diff --git a/sliceversion.sh b/sliceversion.sh
index e6557dd..de51a70 100755
--- a/sliceversion.sh
+++ b/sliceversion.sh
@@ -19,10 +19,10 @@ cd $SOURCE_DIR
 
 set -e
 echo "git remote show origin ; git log -n 1" 
-git remote show origin 
-git log -n 1 
+#git remote show origin 
+#git log -n 1 
 echo "git submodule foreach 'git remote show origin ; git log -n 1 '" 
-git submodule foreach 'git remote show origin ; git log -n 1 '
+#git submodule foreach 'git remote show origin ; git log -n 1 '
 if test -f svn-submodules ; then
     echo "SVN-submodules:"
     cat svn-submodules
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
