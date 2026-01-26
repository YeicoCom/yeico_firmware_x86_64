# Nerves Shell Script

This script enters the nerves shell applying patches along the way.

Type `exit` to exit the screen session.

```bash
./yeico

make <package>-dirclean
make <package>-patch
make <package>-rebuild

make linux-menuconfig
make linux-update-defconfig

make menuconfig
make savedefconfig

make

exit
```
