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

REPO="https://packages.termux.dev/apt/termux-main/pool/main/libx"

packages=(
    libx11
    libxext
    libxrender
    libxtst
    libxi
)

urls=()

for pkg in "${packages[@]}"; do
    dir="$REPO/$pkg"

    version=$(
        curl -fsSL "$dir/" |
        grep -oE "${pkg}_[^\"<>]+_${ARCH}\.deb" |
        sed -E "s/^${pkg}_//; s/_${ARCH}\.deb$//" |
        sort -Vu |
        tail -n1
    )

    if [[ -z "$version" ]]; then
        exit 0
        continue
    fi

    urls+=("$dir/${pkg}_${version}_${ARCH}.deb")
done

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
