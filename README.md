# docker-ci-cd — Minimal Express backend

![version](https://img.shields.io/badge/version-1.0.0-blue)
![license](https://img.shields.io/badge/license-ISC-lightgrey)

A tiny, minimal Express backend example packaged for Docker. Provides a single health-check endpoint and demonstrates a simple Node.js Docker workflow suitable for CI/CD examples and demos.

**Why this project is useful**

- Small, focused example of an Express-based HTTP service.
- Includes a `Dockerfile` configured for container builds and easy deployment.
- Good starting point for CI/CD pipeline demos, testing container builds, or teaching modern Node.js + Docker workflows.

## Features

- Express (v5) server with JSON body parsing and CORS enabled
- Health-check endpoint at `/health`
- Simple `Dockerfile` for building a container image

## Getting started

### Prerequisites

- Node.js (v18+ recommended)
- npm
- Docker (optional, for building/running the container)

### Install and run locally

Install dependencies:

```bash
npm install
```

Run in development (requires `nodemon` if you use `npm run dev`):

```bash
npm run dev
```

Start normally:

```bash
npm start
```

The server listens on `PORT` environment variable (default `5500`). Example:

```bash
PORT=4000 npm start
```

### Docker

Build the image:

```bash
docker build -t docker-ci-cd:latest .
```

Run the container and map port 5500:

```bash
docker run --rm -p 5500:5500 docker-ci-cd:latest
```

Visit the health endpoint:

```bash
curl http://localhost:5500/health
# -> { "status": "It's Working!!" }
```

## Project structure

- `app.js` — Express application entrypoint
- `package.json` — project metadata and scripts
- `Dockerfile` — container image definition
- `eslint.config.js` — linting configuration

## Configuration

- `PORT` — port the server listens on (default `5500`)

## API

- `GET /health` — simple health check that returns JSON `{ status: "It's Working!!" }`

## Contributing & support

- For repository-specific agent instructions, see [.github/copilot-instructions.md](.github/copilot-instructions.md)
- Open an issue to report bugs or request features.
- Submit pull requests against `main` with a short description of your change.

## Maintainers

- Maintainer: repository owner

## License

This project is licensed under the ISC license (see `package.json` for details). If a `LICENSE` file exists, consult it for the full text.

---

If you'd like, I can also add a minimal `CONTRIBUTING.md` or examples for a CI pipeline config (GitHub Actions) next.
