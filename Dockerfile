FROM ruby:3.4.7-alpine3.22

RUN apk add --no-cache build-base

WORKDIR /app
RUN gem install falcon
COPY . .
EXPOSE 3000
CMD ["falcon", "serve", "--bind", "http://0.0.0.0:3000"]
