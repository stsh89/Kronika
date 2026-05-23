FROM ruby:4.0.4-alpine3.23 AS build

ENV BUNDLE_WITHOUT="development:test"
ENV BUNDLE_PATH="/app/vendor/bundle"

RUN apk add --no-cache build-base openssl-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

FROM ruby:4.0.4-alpine3.23 AS runtime

ENV BUNDLE_WITHOUT="development:test"
ENV BUNDLE_PATH="/app/vendor/bundle"

RUN apk add --no-cache openssl ca-certificates

WORKDIR /app

COPY --from=build /app/vendor/bundle /app/vendor/bundle
COPY ./api ./api
COPY ./clients ./clients
COPY ./telegram ./telegram
COPY ./web ./web
COPY config.ru Gemfile Gemfile.lock ./

EXPOSE 3000

CMD ["bundle", "exec", "falcon", "serve", "--bind", "http://0.0.0.0:3000"]
