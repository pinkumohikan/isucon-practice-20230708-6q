.PHONY: *

gogo: stop-services build truncate-logs start-services

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuda.go
	sudo systemctl stop isutar.go
	sudo systemctl stop mysql

build:
	cd webapp/go/ && rm -f isuda isutar && make

truncate-logs:
	sudo journalctl --vacuum-size=1K
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log && sudo chmod 666 /var/log/mysql/mysql-slow.log
	sudo truncate --size 0 /var/log/mysql/error.log

start-services:
	sudo systemctl start mysql
	sudo systemctl start isutar.go
	sudo systemctl start isuda.go
	sudo systemctl start nginx

