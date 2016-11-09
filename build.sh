#!/bin/bash
export NDK=/home/tfn/Android/Sdk/ndk-bundle
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
export PLATFORM=$NDK/platforms/android-19/arch-arm
export PREFIX=/home/tfn/FFmpeg_Android/android_ffmpeg/ffmpegwith264
export FFMPEGDIR=/home/tfn/FFmpeg_Android/android_ffmpeg/ffmpeg
export EXTRAINCLUDE=/home/tfn/FFmpeg_Android/android_x264/include
export EXTRALIB=/home/tfn/FFmpeg_Android/android_x264/lib
export CC=$PREBUILT/bin/arm-linux-androideabi-gcc
export CPREFIX=$PREBUILT/bin/arm-linux-androideabi-
export NM=$PREBUILT/bin/arm-linux-androideabi-nm

function build_one
{
$FFMPEGDIR/configure \
    --target-os=linux \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --enable-shared \
    --enable-static \
    --disable-asm \
    --arch=arm \
    --cc=$CC \
    --cross-prefix=$CPREFIX \
    --disable-stripping \
    --nm=$NM \
    --sysroot=$PLATFORM \
    --enable-nonfree \
    --enable-version3 \
    --disable-everything \
    --enable-gpl \
    --disable-doc \
    --enable-avresample \
    --enable-demuxer=rtsp \
    --enable-muxer=rtsp \
    --disable-ffplay \
    --disable-ffserver \
    --disable-ffmpeg \
    --disable-ffprobe \
    --enable-libx264 \
    --enable-encoder=libx264 \
    --enable-decoder=h264 \
    --enable-protocol=rtp \
    --enable-hwaccels \
    --enable-zlib \
    --disable-devices \
    --disable-avdevice \
    --extra-cflags="-I$EXTRAINCLUDE -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=armv7-a" \
    --extra-ldflags="-L$EXTRALIB"

    #make clean
    make -j4 install
    #make install
}

build_one

$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o

$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$EXTRALIB -soname libffmpeg.so -shared -nostdlib -z noexecstack -Bsymbolic --whole-archive --no-undefined -o libffmpeg.so libavcodec/libavcodec.a libavfilter/libavfilter.a libavresample/libavresample.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog -lx264 --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a


