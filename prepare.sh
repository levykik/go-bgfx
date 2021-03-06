#!/usr/bin/env bash
set -e

# init submodules if we haven't already
if [ `git submodule | grep "^\-" | wc -l` -gt 0 ]; then
	git submodule update --init
fi

# remove old generated files
rm -rf include/*
rm -f bgfx.cpp bgfx_darwin.m

# copy includes
cp -r lib/bgfx/include/* include/
cp -r lib/bgfx/3rdparty/khronos/* include/
cp -r lib/bgfx/src/*.h include/
cp -r lib/bx/include/* include/

# concatenate all *.cpp files into one
echo "// Generate file with prepare.sh" > bgfx.cpp
for file in `ls lib/bgfx/src/*.cpp shim/*.cpp`; do
	cat $file >> bgfx.cpp
done

# concatenate all *.m (obj-c) files into one
echo "// Generate file with prepare.sh" > bgfx_darwin.m
for file in `ls shim/*.m`; do
	cat $file >> bgfx_darwin.m
done

# copy LICENSE file
cp lib/bgfx/LICENSE bgfx-LICENSE
