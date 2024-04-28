FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client
RUN npm install -g yarn
WORKDIR /app
COPY . /app
RUN gem install bundler && bundle install
EXPOSE 3000
