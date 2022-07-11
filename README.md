# docker-rails-postgres-nginx

Simple docker-compose for Rails, with postgresql, redis, nginx for production

# Pre-requisites

- Docker running on the host machine.
- Docker compose running on the host machine.
- Basic knowledge of Docker.

# Installation

- To get started, the following steps needs to be taken:
- Clone the repo.
- open project directory.
- `cp .env.example .env` to use env config file
- Run `docker-compose up -d` to start the containers.
- Visit http://localhost:3000 to see your Rails application.
- Try to connect 127.0.0.1:5433 to access Postgres
- After Succesfully Installed(see logs for app container), run this command if this is a first run `docker-compose exec app bundle exec rails db:setup db:migrate`

# Usage

- `docker-compose up -d` to start all containers
- `docker-compose down` to stop all containers
- If you need to restart after modifying _docker-compose.yml_ restart with `docker-compose down` and `docker-compose up -d`
- `docker-compose logs app|db|sidekiq|web` to see logs on containers

# Images

- redis:alpine
- postgres:12-alpine
- nginx:stable-perl
- ruby:2.7.5-alpine

# DockerFiles

### webserver: nginx.conf

- config file nginx

# Volumes

- db_data : postgres data

# Troubleshooting

## If you need to restart after modifying _Dockerfile_ and have Troubleshooting:

- Verify all containers running: `docker ps -a`
- Stop all containers and remove: `docker stop $(docker ps -a -q)` and `docker rm $(docker ps -a -q)`
- Try to start again `docker-compose up -d`
