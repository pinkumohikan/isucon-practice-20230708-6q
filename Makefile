.PHONY: *

gogo: stop-services build truncate-logs start-services bench

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

bench:
	cd ~/isucon6q && ./isucon6q-bench

kataribe: timestamp=$(date "+%Y%m%d-%H%M%S")
kataribe:
	mkdir -p ~/kataribe-logs
	sudo cp /var/log/nginx/access.log /tmp/last-access.log && sudo chmod 666 /tmp/last-access.log
	cat /tmp/last-access.log | ./kataribe -conf kataribe.toml > ~/kataribe-logs/$timestamp.log
	cat ~/kataribe-logs/$timestamp.log | grep --after-context 20 "Top 20 Sort By Total"

