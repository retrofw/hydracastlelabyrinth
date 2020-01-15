TARGET = hcl/hcl.dge

CHAINPREFIX := /opt/mipsel-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc

SYSROOT     := $(shell $(CC) --print-sysroot)

SDL_CFLAGS = $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LDFLAGS = $(shell $(SYSROOT)/usr/bin/sdl-config --libs)


CFLAGS = -D_SDL -DDINGUX -O2 -mips32 $(SDL_CFLAGS) -Isrc -std=c99
LDFLAGS = -lSDL -lm -lSDL_mixer $(SDL_LDFLAGS)

DEFINES = -Wall

SOURCES = src/collision.c  \
src/effect.c \
src/enemy.c \
src/game.c \
src/hero.c \
src/ini.c \
src/inventory.c \
src/main.c \
src/object.c \
src/options.c \
src/PHL.c \
src/platform.c \
src/qda.c \
src/stagedata.c \
src/text.c \
src/titlescreen.c \
src/weapon.c \
src/enemies/batboss.c \
src/enemies/bat.c \
src/enemies/bee.c \
src/enemies/boar.c \
src/enemies/boomknight.c \
src/enemies/crab.c \
src/enemies/devil.c \
src/enemies/dodo.c \
src/enemies/dog.c \
src/enemies/firewheel.c \
src/enemies/fish.c \
src/enemies/garm.c \
src/enemies/gas.c \
src/enemies/ghoul.c \
src/enemies/golem.c \
src/enemies/gyra.c \
src/enemies/heads.c \
src/enemies/hydra.c \
src/enemies/jellyfish.c \
src/enemies/knight.c \
src/enemies/lolidra.c \
src/enemies/pendulum.c \
src/enemies/podoboo.c \
src/enemies/poisonknight.c \
src/enemies/pumpkin.c \
src/enemies/seal.c \
src/enemies/skeleton.c \
src/enemies/skull.c \
src/enemies/slime.c \
src/enemies/slug.c \
src/enemies/thwomp.c \
src/enemies/waterjumper.c \
src/enemies/wizard.c \
src/sdl/audio.c \
src/sdl/graphics.c \
src/sdl/input.c \
src/sdl/system.c
OBJS = ${SOURCES:.c=.o}

all: $(TARGET)

$(TARGET):${OBJS}
	${CC} -o $(TARGET) ${OBJS} ${CFLAGS} ${LDFLAGS} ${DEFINES}

pack:
	mksquashfs ./opk hydra.opk -all-root -noappend -no-exports -no-xattrs

clean:
	rm src/*.o src/sdl/*.o $(TARGET)

ipk: all
	@rm -rf /tmp/.hcl-ipk/ && mkdir -p /tmp/.hcl-ipk/root/home/retrofw/games/hcl /tmp/.hcl-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@cp -r hcl/hcl.elf hcl/hcl.png hcl/data /tmp/.hcl-ipk/root/home/retrofw/games/hcl
	@cp hcl/hcl.lnk /tmp/.hcl-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" hcl/control > /tmp/.hcl-ipk/control
	@cp hcl/conffiles /tmp/.hcl-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.hcl-ipk/control.tar.gz -C /tmp/.hcl-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.hcl-ipk/data.tar.gz -C /tmp/.hcl-ipk/root/ .
	@echo 2.0 > /tmp/.hcl-ipk/debian-binary
	@ar r hcl/hcl.ipk /tmp/.hcl-ipk/control.tar.gz /tmp/.hcl-ipk/data.tar.gz /tmp/.hcl-ipk/debian-binary

opk: all
	@mksquashfs \
	hcl/default.retrofw.desktop \
	hcl/hcl.dge \
	hcl/hcl.png \
	hcl/data \
	hcl/hcl.opk \
	-all-root -noappend -no-exports -no-xattrs
