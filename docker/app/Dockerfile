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
COPY ./workspace/Gemfile* .
COPY ./docker/app/entrypoint.sh /entrypoints/entrypoint.sh
RUN chmod +x /entrypoints/entrypoint.sh
EXPOSE 9000

ENTRYPOINT [ "/entrypoints/entrypoint.sh"]