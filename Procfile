web: bin/rails server -p $PORT -e $RAILS_ENV
worker:  env TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
