FROM node:9.8.0-alpine

RUN npm install -g tiddlywiki@5.1.15

# Setup wiki volume
VOLUME /var/lib/tiddlywiki
WORKDIR /var/lib/tiddlywiki

# Add init-and-run script
ADD init-and-run-wiki.sh /usr/local/bin/init-and-run-wiki.sh

# Install plugins
ADD plugins/TW5-HotZone/dist/felixhayashi/hotzone /usr/local/lib/node_modules/tiddlywiki/plugins/felixhayashi/hotzone
ADD plugins/TW5-Vis.js/dist/felixhayashi/vis /usr/local/lib/node_modules/tiddlywiki/plugins/felixhayashi/vis
ADD plugins/TW5-TopStoryView/dist/felixhayashi/topstoryview /usr/local/lib/node_modules/tiddlywiki/plugins/felixhayashi/topstoryview
ADD plugins/TW5-TiddlyMap/dist/felixhayashi/tiddlymap /usr/local/lib/node_modules/tiddlywiki/plugins/felixhayashi/tiddlymap

# Copy default wiki
ADD wiki /var/lib/tiddlywiki/wiki

# Meta
CMD ["/usr/local/bin/init-and-run-wiki.sh"]
EXPOSE 8080
