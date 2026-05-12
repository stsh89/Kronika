FROM ruby:3.4.7-alpine3.22

RUN apk add --no-cache build-base openssl-dev tzdata

WORKDIR /app
COPY Gemfile Gemfile.lock ./

ENV BUNDLE_WITHOUT="development:test"
RUN bundle install

COPY app clients web config.ru ./
EXPOSE 3000
CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]
