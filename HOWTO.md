
- https://hexdocs.pm/nerves/customizing-systems.html
- package: fbv, rsync, socat, wireguard-tools
- kernel: 
    - Framebuffer FRAMEBUFFER_CONSOLE, FB_CORE, AGP, DRM_FBDEV_EMULATION, FB

Pending

- framebuffer
- wireguard 
- cog/wpe
- tplink
- canbus

```bash
sudo apt install squashfs-tools
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo apt install git bash curl vim inotify-tools
sudo apt install build-essential libssl-dev automake autoconf libncurses5-dev #libwxgtk-webview3.2-dev 
sudo apt install bc # required by nerves.system.shell

# https://docs.docker.com/engine/install/debian/
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
curl -fsSL https://get.docker.com | sudo sh
sudo sh -eux <<EOF
# Install newuidmap & newgidmap binaries
apt-get install -y uidmap
EOF
dockerd-rootless-setuptool.sh install
# docker not needed on debian

brew install --cask docker
# works until UI opened
# no signing needed
docker version  
docker info     

git clone git@github.com:YeicoCom/yeico_firmware_x86_64.git
cd yeico_firmware_x86_64

git checkout yeico
asdf install

mix archive.install hex nerves_bootstrap --force
mix deps.get
# rm -fr ~/.nerves/artifacts/yeico_firmware_x86_64-portable-1.32.0
mix nerves.system.shell #takes a while

# support/dependencies/check-host-python3.sh: 21: [: version: unexpected operator
# linux works despite error, no special prompt shown
make linux-menuconfig
make linux-update-defconfig

make menuconfig
make savedefconfig

exit

mix nerves.artifact
mv yeico_firmware*.tar.gz ~/.nerves/dl/
```
