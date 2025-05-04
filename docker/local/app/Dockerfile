FROM ruby:2.7.5

# Install Node.js and PostgreSQL client for Rails
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set up working directory
WORKDIR /application

# Install a specific Bundler version (compatible with Ruby 2.7.5)
RUN gem install bundler -v 2.4.22

# Copy Gemfile and Gemfile.lock for bundle install
COPY ./application/Gemfile ./application/Gemfile.lock ./
RUN bundle install

# No COPY of full source code — handled by volume mount
CMD ["bash"]
