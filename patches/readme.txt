this solves the button click count not triggering on live view (kinda works on normal web sites)
this does not solve the righ click context menu bug (oncontextmenu="return false;" still needed)

generated patch by apt installing and running weston on builder
and then also in builder cloned, built, and installed cog as follows

# on builder
mkdir code
cd code
git clone https://github.com/Igalia/cog.git
cd cog
git checkout c4625676a21308e7c82175f1ce9a6c8849f22800
sudo apt install -y libwpewebkit-1.1-dev libmanette-0.2-dev libwpebackend-fdo-1.0-dev libinput-dev weston
meson setup build
time ninja -C build -j 4 2> /tmp/build.log
sudo ninja -C build install

ninja: Entering directory `build'
[0/1] Installing files.
Installing core/libcogcore.so.9.2.7 to /usr/local/lib/x86_64-linux-gnu
Installing platform/drm/libcogplatform-drm.so to /usr/local/lib/x86_64-linux-gnu/cog/modules
Installing platform/headless/libcogplatform-headless.so to /usr/local/lib/x86_64-linux-gnu/cog/modules
Installing platform/wayland/libcogplatform-wl.so to /usr/local/lib/x86_64-linux-gnu/cog/modules
Installing launcher/cog to /usr/local/bin
Installing launcher/cogctl to /usr/local/bin
Installing /home/samuel/code/cog/core/cog.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-request-handler.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-directory-files-handler.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-host-routes-handler.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-prefix-routes-handler.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-shell.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-utils.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-webkit-utils.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-platform.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-modules.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/core/cog-gamepad.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/build/core/cog-config.h to /usr/local/include/cog/
Installing /home/samuel/code/cog/data/cog.1 to /usr/local/share/man/man1
Installing /home/samuel/code/cog/data/cogctl.1 to /usr/local/share/man/man1
Installing /home/samuel/code/cog/build/meson-private/cogcore.pc to /usr/local/lib/x86_64-linux-gnu/pkgconfig
Installing symlink pointing to libcogcore.so.9.2.7 to /usr/local/lib/x86_64-linux-gnu/libcogcore.so.9
Installing symlink pointing to libcogcore.so.9 to /usr/local/lib/x86_64-linux-gnu/libcogcore.so

rm -fr /tmp/weston-runtime-dir
mkdir -p /tmp/weston-runtime-dir
export XDG_RUNTIME_DIR=/tmp/weston-runtime-dir
weston # shows up on p3420
weston --shell=kiosk-shell.so # cog won't maximize window, resize weston before launching cog

export XDG_RUNTIME_DIR=/tmp/weston-runtime-dir
export WAYLAND_DISPLAY=wayland-1
export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu
cog -P wl https://w3c.github.io/uievents/tools/mouse-event-viewer.html

# rebuilt, reinstall and run with debug enabled
# no need to reconfigure meson
ninja -C build -j 4 && sudo ninja -C build install
G_MESSAGES_DEBUG=all cog -P wl https://w3c.github.io/uievents/tools/mouse-event-viewer.html

# patch needs to be manually applied to cog package

# builder -> apply patch

cd yeico_firmware_x86_64

manually replace the cog-platform-wl.c file with:
cp cog.patch/cog-platform-wl.c .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0/build/cog-0.18.4/platform/wayland/
grep g_debug .nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0/build/cog-0.18.4/platform/wayland/cog-platform-wl.c

screen
mix nerves.system.shell

# /home/samuel/yeico_firmware_x86_64/deps/nerves_system_br/create-build.sh /home/samuel/yeico_firmware_x86_64/nerves_defconfig /home/samuel/yeico_firmware_x86_64/.nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0 >/dev/null && cd /home/samuel/yeico_firmware_x86_64/.nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0

make cog-rebuild
make # critical to carry rebuilt changes to final image
exit

mix nerves.artifact 
mv yeico_firmware*.tar.gz ~/.nerves/dl/

# p3420 -> rebuild and test image

fw/run artifacts builder # yeico_firmware_x86_64-portable-1.32.0-5F8399A.tar.gz
rm -fr ~/.nerves/artifacts/yeico_firmware_*
fw/run clean proxmox-x86_64-2gdisk-virtiogl
fw/run deploy proxmox-x86_64-2gdisk-virtiogl 110

doc/81-webkit-browser
terminal run browser.exs vm110
# check button/buttons columns in https://w3c.github.io/uievents/tools/mouse-event-viewer.html

voila!
