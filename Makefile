BASEDIR=$(CURDIR)
DOCDIR=$(BASEDIR)/docs
DISTDIR=$(BASEDIR)/dist

pip-tools:
	pip install -U pip
	pip install -U poetry
	poetry add poetry-plugin-up --group dev

requirements: pip-tools
	poetry install

build:
	docker compose -f deploy/docker_compose.yml build

run:
	poetry run python app.py

check:
	pre-commit run --show-diff-on-failure --color=always --all-files

update: pip-tools
	poetry update
	poetry run poetry up
	poetry lock
	poetry run pre-commit autoupdate

release:
	poetry run bump-my-version bump patch
