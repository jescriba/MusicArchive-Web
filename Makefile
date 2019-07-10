bootstrap: .env
	@brew tap heroku/brew && bin/brew_install.sh heroku postgresql rbenv
	@rbenv install -s
	@gem install -v 2.0.1 bundler --minimal-deps --conservative
	@bundle install --quiet

db: db_start

db_start:
	@pg_ctl -D /usr/local/var/postgres start

db_stop:
	@pg_ctl -D /usr/local/var/postgres stop

.env:
	@echo "$$DOTENV" > .env

.PHONY: bootstrap \
				db \
				db_start \
				db_stop

define DOTENV
S3_BASE_URL=
S3_BUCKET=
S3_ACCESS_KEY=
S3_SECRET_KEY=
REDISTOGO_URL=
SECRET_KEY_BASE=$(shell rake secret)
endef
export DOTENV
