FROM ruby:3.1.2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN sed -i '/jessie-updates/d' /etc/apt/sources.list 
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

RUN mkdir /expenses
WORKDIR /expenses
COPY Gemfile /expenses/Gemfile
COPY Gemfile.lock /expenses/Gemfile.lock
RUN bundle install
COPY . /expenses
