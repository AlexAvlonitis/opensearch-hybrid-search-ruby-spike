FROM ruby:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["ruby", "./app.rb"]
