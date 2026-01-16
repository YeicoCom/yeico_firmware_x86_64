# Nerves Shell Script

This script enters the nerves shell applying patches along the way.

Type `exit` to exit the screen session.

```bash
./shell.sh

make cog-rebuild

make linux-menuconfig
make linux-update-defconfig

make menuconfig
make savedefconfig

make

exit
```
