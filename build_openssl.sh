#!/bin/bash -e

cd openssl
INSTALL_DIR="$1"
PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
echo -e "\n\n----- Build openssl (`git describe --tags`) -----"

VERBOSE_FLAGS=""
if [ "$SILENT" == "true" ]; then
	VERBOSE_FLAGS="-s V=0"
	echo "Using non-verbose mode"
fi

echo -e "\n++ Build openssl armeabi-v7a ++"
./Configure no-asm no-shared android-arm -D__ANDROID_API__=21 --prefix="$INSTALL_DIR/armeabi-v7a"
make $VERBOSE_FLAGS clean
make -j4 $VERBOSE_FLAGS
make install_sw

echo -e "\n++ Build openssl arm64-v8a ++"
./Configure no-asm no-shared android-arm64 -D__ANDROID_API__=21 --prefix="$INSTALL_DIR/arm64-v8a"
make $VERBOSE_FLAGS clean
make -j4 $VERBOSE_FLAGS
make install_sw

echo -e "\n++ Build openssl x86 ++"
./Configure no-asm no-shared android-x86 -D__ANDROID_API__=21 --prefix="$INSTALL_DIR/x86"
make $VERBOSE_FLAGS clean
make -j4 $VERBOSE_FLAGS
make install_sw

echo -e "\n++ Build openssl x86_64 ++"
./Configure no-asm no-shared android-x86_64 -D__ANDROID_API__=21 --prefix="$INSTALL_DIR/x86_64"
make $VERBOSE_FLAGS clean
make -j4 $VERBOSE_FLAGS
make install_sw

cd ..
