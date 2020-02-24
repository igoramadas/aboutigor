COFFEE:= ./node_modules/.bin/coffee

build:
	$(COFFEE) -b --output lib --compile src

clean:
	rm -rf ./lib
	rm -rf ./node_modules
	rm -f package-lock.json

update:
	-ncu -u
	npm version $(shell date '+%y.%-V.%u%H') --force --allow-same-version --no-git-tag-version
	npm install
	$(COFFEE) -b --output lib --compile src

run:
	$(COFFEE) -b --output lib --compile src
	npm start

publish:
	npm version $(shell date '+%y.%-V.%u%H') --force --allow-same-version
	git push --tags
