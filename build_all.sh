#!/bin/bash -e

# Check NDK and ANDROID_NDK_HOME env
if [ -z "$NDK" ]; then
	if [ -z "$ANDROID_NDK_HOME" ]; then
    	echo 'No $NDK or $ANDROID_NDK_HOME specified.'
    	exit 1
    else
    	export NDK="$ANDROID_NDK_HOME"
    fi
else
	export ANDROID_NDK_HOME="$NDK"
fi


# Clean
rm -rf libs
rm -rf bin

echo "修改最大连接数TEXT_MAX_CONNECTION_PER_SERVER"
sed -i 's/1", 1, 16/128", 1, -1/' aria2/src/OptionHandlerFactory.cc
echo "修改PREF_MIN_SPLIT_SIZE, TEXT_MIN_SPLIT_SIZE"
sed -i 's/"20M", 1_m, 1_g/"4K", 1_k, 1_g/' aria2/src/OptionHandlerFactory.cc
echo "修改TEXT_CONNECT_TIMEOUT"
sed -i 's/TEXT_CONNECT_TIMEOUT, "60", 1, 600/TEXT_CONNECT_TIMEOUT, "30", 1, 600/' aria2/src/OptionHandlerFactory.cc
echo "修改TEXT_PIECE_LENGTH"
sed -i 's/TEXT_PIECE_LENGTH, "1M", 1_m/TEXT_PIECE_LENGTH, "4k", 1_k/' aria2/src/OptionHandlerFactory.cc
echo "修改TEXT_RETRY_WAIT"
sed -i 's/TEXT_RETRY_WAIT, "0", 0, 600/TEXT_RETRY_WAIT, "2", 0, 600/' aria2/src/OptionHandlerFactory.cc
echo "修改PREF_SPLIT, TEXT_SPLIT"
sed -i 's/PREF_SPLIT, TEXT_SPLIT, "5"/PREF_SPLIT, TEXT_SPLIT, "8"/' aria2/src/OptionHandlerFactory.cc


# Build c-ares
cd c-ares
echo "----- Build c-ares (`git describe --tags`) -----"
autoreconf -i
../androidbuildlib out_path=../libs minsdkversion=21 \
	target_abis="armeabi-v7a x86 arm64-v8a x86_64" \
	silent="$SILENT" custom_silent="--silent" \
	configure_params="--disable-shared --enable-static"
cd ..


# Build expat
cd libexpat/expat
echo -e "\n\n----- Build expat (`git describe --tags`) -----"
./buildconf.sh
../../androidbuildlib out_path=../../libs minsdkversion=21 \
	target_abis="armeabi-v7a x86 arm64-v8a x86_64" \
	silent="$SILENT" \
	configure_params="--disable-shared --enable-static"
cd ../..


# Build zlib
cd zlib
echo -e "\n\n----- Build zlib (`git describe --tags`) -----"
../androidbuildlib out_path=../libs minsdkversion=21 \
	target_abis="armeabi-v7a x86 arm64-v8a x86_64" \
	no_host="true" \
	silent="$SILENT" custom_silent="" \
	configure_params="--static"
cd ..


# Build sqlite
cd sqlite
echo -e "\n\n----- Build sqlite (`git describe --tags`) -----"
../androidbuildlib out_path=../libs minsdkversion=21 \
	target_abis="armeabi-v7a x86 arm64-v8a x86_64" \
	silent="$SILENT" custom_silent="" \
	configure_params="--build=$(dpkg-architecture -qDEB_BUILD_GNU_TYPE) --enable-static -disable-shared"
cd ..


# Build openssl
./build_openssl.sh "$(pwd)/libs"


# Build libssh2
./build_libssh2.sh "$(pwd)/libs"


# Build aria2
./build_aria2.sh minsdkversion=21 \
	target_abis="armeabi-v7a x86 arm64-v8a x86_64" \
	silent="$SILENT"
