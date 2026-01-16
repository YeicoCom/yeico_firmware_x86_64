#!/bin/bash

SELF=$(realpath $0)

case "$1" in
    setup)
    cd $(dirname $SELF)
    deps/nerves_system_br/create-build.sh nerves_defconfig .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0
    cd .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0
    echo Running within an screen session
    $SELF patch >> ${SELF%.*}.log
    bash
    ;;
    patch)
    for p in $(dirname $SELF)/patches/*.patch; do
        echo $p
        array=(${p//-/ })
        package=${array[1]}
        version=${array[2]}
        ls build/$package-$version
        (cd build/$package-$version && (patch -p1 < $p))
        make $package-rebuild
    done
    make
    ;;
    *)
    cd $(dirname $SELF)
    mix deps.get
    screen $SELF setup
    ;;
esac
