FROM ruby:3.2.2

WORKDIR /app

COPY ./sinatra/Gemfile ./sinatra/Gemfile.lock ./

RUN bundle install

COPY ./sinatra .

EXPOSE 4567
CMD ["ruby", "./app.rb"]
