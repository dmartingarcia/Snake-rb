FROM ruby
MAINTAINER David Martin <davidmartingarcia0@gmail.com>
ADD . .

RUN apt update
RUN apt-get install -y build-essential libsdl2-dev libgl1-mesa-dev libopenal-dev \
  libsndfile-dev libmpg123-dev libgmp-dev libfontconfig1-dev

RUN gem install bundler
RUN bundle install

ENTRYPOINT []
CMD ["ruby", "game.rb"]
