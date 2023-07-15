# digitalguestbook-docker

## Project setup

```
1. Copy .env.example to .env
2. docker-compose up -d
```

### The Output

```
Creating rails-docker_database_1 ... done
Creating rails-docker_redis_1    ... done
Creating rails-docker_app_1      ... done
Creating rails-docker_sidekiq_1  ... done
```

### Setup db

```
docker-compose exec app bundle exec rake db:setup db:migrate
```
