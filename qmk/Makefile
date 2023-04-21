mount:
	sudo umount /mnt || true
	sudo mount -o gid=1000,uid=1000 /dev/sd? /mnt


sync-left: mount
	cp -v ./keyfuda-04-left-hand/*.json /mnt/
	sudo umount /mnt

sync-left: mount
	cp -v ./keyfuda-04-right-hand/*.json /mnt/
	sudo umount /mnt
