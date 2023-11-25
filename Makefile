BASEDIR=$(CURDIR)
DOCDIR=$(BASEDIR)/docs
DISTDIR=$(BASEDIR)/dist

pip-tools:
	pip install -U pip
	pip install -U poetry
	poetry self add poetry-plugin-up

requirements: pip-tools
	poetry install

build:
	docker compose -f deploy/docker_compose.yml build

run:
	poetry run python app.py

check:
	pre-commit run --show-diff-on-failure --color=always --all-files

update: pip-tools
	poetry up
	pre-commit autoupdate

release:
	poetry run bump-my-version bump patch
