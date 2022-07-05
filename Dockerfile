FROM ruby:2.6.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs postgresql-client npm yarn && npm update -g npm && npm install n -g && n 14.15.0

RUN mkdir /expenses
WORKDIR /expenses
COPY Gemfile /expenses/Gemfile
COPY Gemfile.lock /expenses/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /expenses
