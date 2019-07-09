bootstrap:
	@brew tap heroku/brew && bin/brew_install.sh heroku
	@gem install -v 2.0.2 bundler --minimal-deps --conservative
	@bundle install --quiet

.PHONY: bootstrap
