# Troubleshooting

## UTM VM fails to boot with file system errors

> `/dev/vda2 contains a file system with errors, check forced.`
>
> `Inodes that were part of a corrupted orphan linked list found.`
>
> `/dev/vda2: UNEXPECTED INCONSISTENCY: RUN fsck MANUALLY.` > `(i.e., without -a or -p options)`
>
> `fsck exited with status code 4` > `The root filesystem on /dev/vda2 requires a manual fsck`

At the (initramfs) prompt, type `fsck -y -f /dev/vda2` to check/repair your file system.

## SSH does not work

Make sure you don’t have a VPN that’s interfering with your ability to access the local network.

## Bochs BIOS does not work (black screen)

Some versions of the `bochs` package ship with a broken BIOS. See [https://www.reddit.com/r/linuxquestions/comments/tk4tbk/comment/kh0rchw/]().

Solution: replace it with the latest BIOS from GitHub.

````sh
BOCHS_BIOS=BIOS-bochs-latest
BOCHS_CONFIG_DIR=/usr/share/bochs/
wget https://github.com/ipxe/bochs/raw/master/bios/$BOCHS_BIOS
sudo cp "$BOCHS_CONFIG_DIR$BOCHS_BIOS"{,.bak}
sudo cp "$BOCHS_BIOS" "$BOCHS_CONFIG_DIR"
	```
````
