FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  chromium-driver

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

RUN mkdir /gunpla-type
WORKDIR /gunpla-type
COPY Gemfile /gunpla-type/Gemfile
COPY Gemfile.lock /gunpla-type/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /gunpla-type

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
