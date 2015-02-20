all:
	RAILS_ENV=production bundle exec foreman start;

stop:
	cat tmp/unicorn.pid | xargs kill -QUIT ;

restart:
	make stop; make;

logs:
	tail -f log/unicorn.log;
