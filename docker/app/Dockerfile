FROM ruby:2.7.5

RUN apt-get update -qq \
    && apt-get install -y nodejs postgresql-client openssl

RUN gem install bundler

ADD ./application /application
WORKDIR /application

RUN bundle install
RUN bundle exec rails assets:clobber assets:precompile

CMD [ "bash" ]