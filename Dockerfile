FROM ruby:3.1.2

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN set -x && apt-get update -y -qq && apt-get install -yq nodejs yarn

RUN sed -i '/jessie-updates/d' /etc/apt/sources.list 
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

RUN mkdir /expenses
WORKDIR /expenses
COPY Gemfile /expenses/Gemfile
COPY Gemfile.lock /expenses/Gemfile.lock
RUN bundle install
RUN mkdir -p tmp/sockets
COPY . /expenses
