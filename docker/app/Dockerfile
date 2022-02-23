FROM ruby:2.7.5-alpine

#install depedencies
RUN apk add --update-cache \
    build-base \
    busybox \
    ca-certificates \
    curl \
    git \
    gnupg1 \
    graphicsmagick \
    libffi-dev \
    libsodium-dev \
    nodejs \
    openssh-client \
    postgresql-client \
    postgresql-dev \
    rsync \
    shared-mime-info \
    tzdata

#install gem bundler
RUN gem install bundler

WORKDIR /app
COPY ./application .

COPY ./docker/entrypoints/* ./entrypoints/
RUN chmod +x ./entrypoints/*

ENTRYPOINT [ "/app/entrypoints/app-entrypoint.sh"]