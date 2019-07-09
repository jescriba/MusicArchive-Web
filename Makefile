bootstrap:
	@brew tap heroku/brew && bin/brew_install.sh heroku postgresql
	@gem install -v 2.0.2 bundler --minimal-deps --conservative
	@bundle install --quiet

db: db_start

db_start:
	@pg_ctl -D /usr/local/var/postgres start

db_stop:
	@pg_ctl -D /usr/local/var/postgres stop

.PHONY: bootstrap \
				db \
				db_start \
				db_stop
