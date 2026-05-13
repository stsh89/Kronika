FROM ruby:3.4.7-alpine3.22 AS build

RUN apk add --no-cache build-base openssl-dev

WORKDIR /app
COPY Gemfile Gemfile.lock ./

ENV BUNDLE_WITHOUT="development:test"
ENV BUNDLE_PATH="/app/vendor/bundle"

RUN bundle install --jobs 4 --retry 3

FROM ruby:3.4.7-alpine3.22 AS runtime

ENV BUNDLE_WITHOUT="development:test"
ENV BUNDLE_PATH="/app/vendor/bundle"

RUN apk add --no-cache openssl tzdata ca-certificates

WORKDIR /app

COPY --from=build /app/vendor/bundle /app/vendor/bundle
COPY ./app ./app
COPY ./clients ./clients
COPY ./web ./web
COPY config.ru Gemfile Gemfile.lock ./

EXPOSE 3000

CMD ["bundle", "exec", "falcon", "serve", "--bind", "http://0.0.0.0:3000"]
