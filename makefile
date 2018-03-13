SHELL = /usr/bin/env bash

# Customize name and img for your project:
name = tiddlymap
img = testedminds/$(name)

latest = $(img):latest
number = `cat ./next-version.txt`
version = `date +%y.%m.%d`.$(number)

dev: stop build run sleep-2 open

version:
	@echo $(version)

sleep-%:
	sleep $*

build:
	echo "<div class='version'>v$(version)</div>" > ./version.html
	docker build -t $(latest) .

# https://devcenter.heroku.com/articles/container-registry-and-runtime#get-the-port-from-the-environment-variable
run:
	docker run -d -p 8080:8080 -v `pwd`/wiki:/var/lib/tiddlywiki/wiki -e PORT=8080 --rm --name $(name) $(latest)

# run a container without mounting the local volume so that any changes to the wiki are scoped to the container:
test:
	docker run -d -p 8080:8080 -e PORT=8080 --rm --name $(name) $(latest)

exec:
	docker exec -it $(name) sh

stop:
	-docker stop $(name)

open:
	open http://`docker-machine ip dev`:8080

release: push tag update-version

push:
	docker tag $(latest) $(img):$(version)
	docker push $(latest)
	docker push $(img):$(version)

tag:
	git tag v$(version)
	git push --tags

update-version:
	echo $$(($(number) + 1)) > ./next-version.txt
	git add ./next-version.txt
	git commit -m "Bump version"
	git push
