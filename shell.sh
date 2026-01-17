#!/bin/bash

SELF=$(realpath $0)

case "$1" in
    setup)
    cd $(dirname $SELF)
    deps/nerves_system_br/create-build.sh nerves_defconfig .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0
    cd .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0
    echo Running within an screen session
    $SELF patch | tee ${SELF%.*}.log
    bash
    ;;
    patch)
    counter=0
    for p in $(dirname $SELF)/patches/*.patch; do
        echo $p
        array=(${p//-/ })
        package=${array[1]}
        version=${array[2]}
        dir=build/$package-$version
        [ -f $dir/.yeico_patched ] || echo $dir
        [ -f $dir/.yeico_patched ] || (cd build/$package-$version && (patch -p1 < $p))
        [ -f $dir/.yeico_patched ] || make $package-rebuild
        [ -f $dir/.yeico_patched ] || counter=$((counter + 1))
	[ -f $dir/.yeico_patched ] || touch $dir/.yeico_patched
    done
    echo Total patched: $counter
    [ $counter -gt 0 ] && make
    ;;
    *)
    cd $(dirname $SELF)
    mix deps.get
    screen $SELF setup
    ;;
esac
