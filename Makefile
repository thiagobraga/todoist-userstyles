PWD := $(shell pwd)
PATH := ${PWD}/node_modules/.bin:$(PATH)
.ONESHELL: install
.SILENT: install build release watch
all: install build watch

install:
	[ ! -f yarn.lock ] || [ -d node_modules ] && yarn && exit
	[ -f yarn.lock ] && [ -d node_modules ] && echo 'Already installed' && exit

build:
	stylus src/stylus -o theme.css
	css2userstyle --no-userscript theme.css
	rm theme.css

release:
	stylus -c src/stylus -o theme.css
	postcss theme.css --use autoprefixer --replace --no-map
	css2userstyle --no-userscript theme.css
	rm theme.css

watch:
	chokidar src/stylus -c 'make -s build'
