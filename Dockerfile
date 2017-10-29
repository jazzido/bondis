FROM ruby:latest

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
RUN bundle install

CMD ["bundle", "exec", "ruby", "runner.rb", "-o", "/out/bondis.csv"]


