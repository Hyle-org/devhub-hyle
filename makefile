.PHONY: serve build deploy

serve:
	python3 -m mkdocs serve

build:
	python3 -m mkdocs build

deploy:
	python3 -m mkdocs gh-deploy
