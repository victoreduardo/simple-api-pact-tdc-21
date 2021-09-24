SHELL := /bin/bash # Use bash syntax

args = $(filter-out $@,$(MAKECMDGOALS))
DK_BASE_CMD = docker
DC_BASE_CMD = docker-compose --file docker-compose.yml
RAILS_CMD = /usr/src/app/bin/rails

down:
	$(DC_BASE_CMD) down

up: down
	docker-compose up --force-recreate --build $(args)

bash:
	$(DC_BASE_CMD) exec $(or $(args), "api") /bin/bash --login

console:
	$(DC_BASE_CMD) exec api bundle exec rails console

test:
	$(DC_BASE_CMD) --file docker-compose.test.yml exec -e RAILS_ENV=test api bundle exec rspec

test_all:
	@docker-compose --file docker-compose.test.yml exec -e RAILS_ENV=test api bundle exec rake test:all
