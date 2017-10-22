web: bin/rails server -p $PORT -e $RAILS_ENV
resque: env TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
