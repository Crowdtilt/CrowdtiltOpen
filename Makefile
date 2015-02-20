all:
	bundle exec foreman start


restart:
	cat tmp/unicorn.pid | xargs kill -QUIT ;
	make	
