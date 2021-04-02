FROM ruby:2.7
MAINTAINER David Martin <davidmartingarcia0@gmail.com>

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  build-essential \
  libsdl2-dev \
  libgl1-mesa-dev \
  libopenal-dev \
  libgmp-dev \
  libfontconfig1-dev \
  libmpg123-dev \
  libsndfile1-dev

RUN gem update --system && gem install bundler
RUN mkdir -p /usr/src/app


WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock  ./
RUN bundle install --jobs $(nproc)

COPY . ./

ENTRYPOINT []
CMD ["ruby", "game.rb"]
