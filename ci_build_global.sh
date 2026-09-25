#!/bin/bash
set -e
. setdevkitpath.sh

export JDK_DEBUG_LEVEL=release

check_eula() {
  if [ ! -f "eula.txt" ]; then
    cat > "eula.txt" <<EOF
# By changing the setting below to TRUE you are indicating your agreement to the Android SDK License Agreement (https://developer.android.com/ndk/downloads).
# Generated: $(date +"%Y-%m-%d %H:%M")
eula=false
EOF
    exit 1
  fi

  local eula_value
  eula_value=$(grep -E '^eula=' "eula.txt" | cut -d'=' -f2 | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

  if [ "$eula_value" != "true" ]; then
    echo "You need to agree to the EULA in order to run the server. Go to eula.txt for more info." >&2
    exit 1
  fi
}

check_eula

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
# ./tarjdk.sh  # disabled (fix breaks compatibility with launchers)
./debpack.sh debout
