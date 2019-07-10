# MusicArchive-Web

[![Build Status](https://travis-ci.org/jescriba/MusicArchive-Web.svg?branch=master)](https://travis-ci.org/jescriba/MusicArchive-Web)

## Build

Run `make bootstrap` for first-time setup.
This will install Homebrew dependencies, Gemfiles, etc.
You should also add:

```
test -x /usr/local/bin/rbenv && eval "$(rbenv init -)"
```
to your `~/.bash_profile` or `~/.zshrc` to ensure that the correct Ruby version is used.

### Environment setup

MusicArchive uses `postgres`. If it's not running, start it with:

```sh
make db
```

From here, you can create the DB:

```sh
rails db:setup
```

and read more @ https://guides.rubyonrails.org/command_line.html. `rails -T` is a useful command to get a list of all tasks.

#### Required ENV vars:

```
S3_BUCKET
S3_BASE_URL
S3_ACCESS_KEY
S3_SECRET_KEY
SECRET_KEY_BASE
REDISTOGO_URL
```
