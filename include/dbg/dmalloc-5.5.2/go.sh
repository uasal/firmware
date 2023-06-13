#!/bin/sh
export PATH="$PATH:/home/steve/gcc-linaro-arm-linux-gnueabihf/bin:/home/steve/gcc-linaro-arm-linux-gnueabihf"
export CC=/home/steve/gcc-linaro-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc
export CXX=/home/steve/gcc-linaro-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
./configure --enable-threads --enable-cxx --host=arm-linux-gnueabihf
make clean
make light
