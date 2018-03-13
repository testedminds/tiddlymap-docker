FROM node:9.8.0-alpine

RUN npm install -g tiddlywiki@5.1.15

# Setup wiki volume
VOLUME /var/lib/tiddlywiki
WORKDIR /var/lib/tiddlywiki

# Add init-and-run script
ADD init-and-run-wiki.sh /usr/local/bin/init-and-run-wiki.sh

# Meta
CMD ["/usr/local/bin/init-and-run-wiki.sh"]
EXPOSE 8080
