up: stop
	docker-compose up -d
down:
	docker-compose down
start:
	docker-compose start
stop:
	docker-compose stop
build:
	docker-compose build
build-front:
	cd frontend && npm run build && cp -r build/* ../backend/public/
