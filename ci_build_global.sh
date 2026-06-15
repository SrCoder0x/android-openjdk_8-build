#!/bin/bash
set -e
. setdevkitpath.sh

export JDK_DEBUG_LEVEL=release

if [ ! -d "$NDK" ]; then
  wget -nv -O android-ndk-$NDK_VERSION-linux-x86_64.zip "https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux-x86_64.zip"
  ./extractndk.sh
else
  echo "NDK already extracted at $NDK, skipping download"
fi
./maketoolchain.sh

# Some modifies to NDK to fix

./getlibs.sh
./buildlibs.sh
./clonejdk.sh
./buildjdk.sh
./removejdkdebuginfo.sh
./tarjdk.sh
./debpack.sh debout
