FROM ruby:2.6.1
RUN apt-get update && apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev libmagic-dev && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y jpegoptim optipng && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

# Preinstall majority of gems
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
WORKDIR /app
RUN bundle install

CMD bundle exec ruby run.rb
