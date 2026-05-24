# Kronika - Telegram Timezone Bot

Telegram bot that converts 24h format time strings in group chats to local time for each user based on their registered timezone.

## Architecture

The project follows a layered architecture using non-blocking I/O with the `async` and `async-http` gems.

### Layers

- **Web Layer (`web/`)**: Entry point for the application. Uses the Falcon server.
  - `web/rack.rb`: Main server class, dispatches requests.
  - `web/webhook_controller.rb`: Handles incoming Telegram webhooks and routes payload to the Telegram Layer.
- **Telegram Layer (`telegram/`)**: Contains the Telegram Bot API client and command parsing/execution logic.
- **Operation Layer (`api/operations/`)**: Contains the business logic for specific actions (Save, Read, Drop Timezone, Convert Time).
- **Service Layer (`api/services/`)**: Domain-specific services that wrap client interactions.
- **Client Layer (`clients/`)**: Raw API clients for external services (Upstash, GeoNames).
- **Model Layer (`api/models/`)**: Simple data structures and value objects.

## Tech Stack

- **Language**: Ruby 4.0
- **Server**: [Falcon](https://github.com/socketry/falcon) (Non-blocking HTTP server).
- **Concurrency**: `async` and `async-http` for non-blocking I/O.
- **Timezones**: `tzinfo` gem.
- **External Services**:
  - **Telegram**: Bot API for interaction.
  - **Upstash**: Redis for persistent user timezone storage.
  - **GeoNames**: API for mapping latitude/longitude to timezone IDs.

## Core Conventions

### Concurrency & I/O

- **Async Everywhere**: All network calls must be non-blocking using `async-http`.
- **Timeouts**: API clients should implement timeouts (currently set to 3 seconds in `clients/` and `telegram/`).
- **Sync/Async Boundary**: The webhook controller handles requests within an `Async` block (see `web/webhook_controller.rb`).

### Configuration

- Configuration is managed through environment variables, loaded in `web/config.rb` via `Web::Config`.
- Required variables: `GEO_NAMES_USERNAME`, `TELEGRAM_BOT_TOKEN`, `TELEGRAM_WEBHOOK_SECRET_TOKEN`, `UPSTASH_TOKEN`, `UPSTASH_URL`.

## Development Workflows

### Environment

- `dev.sh.sample` provides a template for starting the server locally and making requests to it.

### Coding Style

- Follow standard Ruby conventions.
- RuboCop is used for linting (see `.rubocop.yml`).
- Use `Data.define` for simple data structures where appropriate.

## Missing Infrastructure

- **Testing**: Currently, there is no formal testing framework (RSpec/Minitest) or test suite in the repository.
- **CI/CD**: No CI configuration found.
