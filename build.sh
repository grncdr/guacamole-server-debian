#!/bin/sh

set -e

DEFAULT_REMOTE="https://github.com/glyptodon/guacamole-server"
DEFAULT_COMMIT="master"

while getopts "hr:c:" opt; do
  case "$opt" in
    h)
      cat <<EOF
build.sh [options]

Options:
  -r <REMOTE>    Specify the git remote to pull sources from
                 (default: $DEFAULT_REMOTE)

  -c <COMMITISH> Specify a commit (or branch or tag) to checkout after cloning.
                 (default: $DEFAULT_COMMIT)

  -h             Show this help
EOF
      exit 0;
      ;;
    r)
      REMOTE="$OPTARG"
      ;;
    c)
      COMMIT="$OPTARG"
      ;;
  esac;
done

if [ -z "$REMOTE"]; then REMOTE="$DEFAULT_REMOTE"; fi
if [ -z "$COMMIT"]; then COMMIT="$DEFAULT_COMMIT"; fi

echo "Installing build dependencies"
sudo apt-get install \
  git automake libtool build-essential dh-autoreconf libcunit1-dev \
  libpng12-dev libcairo2-dev libpango1.0-dev libvorbis-dev libpulse-dev \
  libvncserver-dev libfreerdp-dev libssh2-1-dev

set -x

if [ -d guacamole-server/.git ]; then
  cd guacamole-server
  git clean -fdx
  cd ..
else
  rm -fr guacamole-server
  git clone $REMOTE guacamole-server
fi

cd guacamole-server
git checkout $COMMIT
autoreconf -i
./configure
make dist
# TODO - don't assume we're building 0.8.3
mv guacamole-server-0.8.3.tar.gz ../guacamole-server_0.8.3.orig.tar.gz
git reset --hard
git clean -fdx
cp -R ../debian ./debian
dpkg-buildpackage
