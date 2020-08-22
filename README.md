# aria2-android
![Build Aria2-android](https://github.com/jsda/aria2-android/workflows/Build%20Aria2-android/badge.svg)

## Download
* [Aria2 arm64]
https://github.com/jsda/aria2-android/raw/Build/aria2-arm64-v8a.zip
* [Aria2 armv7a]
https://github.com/jsda/aria2-android/raw/Build/aria2-armeabi-v7a.zip
* [Aria2 x86]
https://github.com/jsda/aria2-android/raw/Build/aria2-x86.zip
* [Aria2 x86_64]
https://github.com/jsda/aria2-android/raw/Build/aria2-x86_64.zip

## Build

Clone the repository with submodules (`--recurse-submodules`), install the Android NDK r20, set the `ANDROID_NDK_HOME` env variable and run `./build_all.sh`.

This will compile aria2 for `armeavi-v7a`, `arm64-v8a`, `x86` and `x86_64`. The binaries can be found inside the `bin` folder.
