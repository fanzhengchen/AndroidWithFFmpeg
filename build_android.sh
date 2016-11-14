#!/bin/bash
export TEMPDIR=/Users/fanzhengchen/Desktop/ffmpeg
NDK=/Users/fanzhengchen/Android/sdk/ndk-bundle
PLATFORM=/Users/fanzhengchen/Android/sdk/ndk-bundle/platforms/android-21/arch-arm
INCLUDE=/Users/fanzhengchen/Android/sdk/ndk-bundle/platforms/android-21/arch-arm/usr/include
TOOLCHAIN=/Users/fanzhengchen/Android/sdk/ndk-bundle/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
CC=~/Android/sdk/ndk-bundle/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/
function build_one
{
./configure \
    --prefix=$PREFIX \
    --target-os=linux \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --arch=arm \
    --sysroot=$PLATFORM \
    --cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
    --nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
    --extra-cflags="-I$INCLUDE $OPTIMIZE_CFLAGS -I/Users/fanzhengchen/x264/android_x264/include -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=armv7-a" \
    --extra-ldflags="-L/Users/fanzhengchen/x264/android_x264/lib" \
    --disable-asm \
    --arch=arm \
    --enable-shared \
    --disable-static \
    --enable-runtime-cpudetect \
    --enable-nonfree \
    --enable-version3 \
    --enable-gpl \
    --disable-doc \
    --disable-avresample \
    --enable-demuxer=rtsp \
    --enable-muxer=rtsp \
    --disable-ffplay \
    --disable-ffserver \
    --disable-ffmpeg \
    --disable-ffprobe \
    --enable-libx264 \
    --disable-debug \
    --enable-small \
    --enable-encoder=libx264 \
    --enable-decoder=h264 \
    --enable-protocol=rtp \
    --enable-hwaccels \
    --enable-zlib \
    --disable-devices \
    --disable-avdevice \
    --disable-debug \
    --disable-static \
    --disable-doc \
    --disable-asm \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-postproc \
    --disable-avdevice \
    --disable-symver \
    --disable-stripping \

make clean
make -j4
make install
} 
CPU=armv7-a
PREFIX=$(pwd)/android/$CPU 
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
build_one

