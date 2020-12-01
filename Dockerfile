FROM ruby:2.6.5
MAINTAINER diego.desu@gmail.com

RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  locales

RUN apt-get install --yes curl
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential
RUN npm install -g yarn

RUN mkdir -p /app 
WORKDIR /app

COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5

# precompile assets
RUN yarn install
RUN bundle exec rails assets:precompile

COPY . ./

# Use en_US.UTF-8 as our locale
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

CMD puma -C config/puma.rb
