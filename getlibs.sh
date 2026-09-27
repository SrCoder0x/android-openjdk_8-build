#!/bin/bash
# https://github.com/termux/termux-packages/blob/master/disabled-packages/openjdk-9-jre-headless/build.sh
set -e

. setdevkitpath.sh

wget https://downloads.sourceforge.net/project/freetype/freetype2/$BUILD_FREETYPE_VERSION/freetype-$BUILD_FREETYPE_VERSION.tar.gz
tar xf freetype-$BUILD_FREETYPE_VERSION.tar.gz

wget https://github.com/apple/cups/releases/download/v2.2.4/cups-2.2.4-source.tar.gz
tar xf cups-2.2.4-source.tar.gz

rm cups-2.2.4-source.tar.gz freetype-$BUILD_FREETYPE_VERSION.tar.gz

case "$TARGET_JDK" in
    x86) ARCH="i686" ;;
    *)   ARCH="$TARGET_JDK" ;;
esac

DEST="dummy_libs"
mkdir -p "$DEST"
workdir="$(mktemp -d)"

urls=(
    "https://packages.termux.dev/apt/termux-main/pool/main/libx/libx11/libx11_1.8.13-1_${ARCH}.deb"
    "https://packages.termux.dev/apt/termux-main/pool/main/libx/libxext/libxext_1.3.7_${ARCH}.deb"
    "https://packages.termux.dev/apt/termux-main/pool/main/libx/libxrender/libxrender_0.9.12-1_${ARCH}.deb"
    "https://packages.termux.dev/apt/termux-main/pool/main/libx/libxtst/libxtst_1.2.5-1_${ARCH}.deb"
    "https://packages.termux.dev/apt/termux-main/pool/main/libx/libxi/libxi_1.8.3_${ARCH}.deb"
)

for url in "${urls[@]}"; do
    deb="$(basename "$url")"
    curl -fsSL -o "${workdir}/${deb}" "$url"
    pushd "$workdir" >/dev/null
    ar x "$deb"
    [ -f data.tar.xz ] && tar xf data.tar.xz
    [ -f data.tar.zst ] && tar --zstd -xf data.tar.zst
    popd >/dev/null
done

find "$workdir/data/data/com.termux/files/usr/lib" -maxdepth 1 -name '*.so*' -exec cp -P {} "$DEST/" \;
rm -rf "$workdir"
