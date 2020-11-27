FROM ruby:2.6.0-alpine3.7
RUN apk --update add --virtual build-deps build-base && \
    apk add --no-cache su-exec postgresql-dev tzdata git \
        libxml2-dev libxslt-dev less nodejs yarn

RUN adduser -D -u 1000 dev

RUN mkdir /api /bundle

WORKDIR /api
RUN gem install rails -v '5.1.4'
COPY . /api
RUN bundle install

RUN chown -R dev:dev /api /bundle
USER dev

CMD rails s -p 3333 -b 0.0.0.0
