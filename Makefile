all: main.lua
	zip -r .builds/JUMP-LOVE--`date +%Y-%m-%d--%H-%M`.love *

zip: main.lua
	zip -r .builds/JUMP-LOVE--`date +%Y-%m-%d--%H-%M`.zip *

opk: main.lua
	zip -r .builds/JUMP-LOVE.love *
	mksquashfs .builds/JUMP-LOVE.love img/Logo-32x32.png gcw0/default.gcw0.desktop .builds/JUMP-LOVE.opk -all-root -noappend -no-exports -no-xattrs

# vim: set noet:
