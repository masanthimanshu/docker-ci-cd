# Docker CI/CD Backend

[![Node.js 24](https://img.shields.io/badge/Node.js-24-green)](https://nodejs.org/)
[![Express 5.x](https://img.shields.io/badge/Express-5.x-black)](https://expressjs.com/)
[![Docker Ready](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://www.docker.com/)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue)](package.json)

A container-ready Node.js and Express backend service for demonstrating modular route design, observability, and automated DevOps delivery with Docker, GitHub Actions, and Terraform.

## Table of Contents

- [What it does](#what-it-does)
- [Why it is useful](#why-it-is-useful)
- [Getting started](#getting-started)
- [Usage](#usage)
- [Endpoints](#endpoints)
- [Project structure](#project-structure)
- [CI/CD and deployment](#cicd-and-deployment)
- [Support](#support)
- [Maintainers](#maintainers)
- [License](#license)

## What it does

This repository provides a lightweight backend service with:

- Express 5-based API routing split into `auth` and `user` modules
- built-in health checks for the app and route modules
- Prometheus-compatible metrics via `/metrics`
- Docker image support via `Dockerfile`
- sample local stack orchestration with `compose.yaml`
- automated build and publish workflows in `.github/workflows/`
- Terraform deployment automation in `.deploy/`

## Why it is useful

Use this project to:

- bootstrap a Node.js backend with clean route separation
- learn containerized development and Docker Compose workflows
- expose operational metrics for monitoring systems
- build and publish Docker images automatically on push
- deploy a containerized backend with Terraform and AWS automation

## Getting started

### Prerequisites

- Node.js 24+
- npm
- Docker (recommended for containerized execution)

### Install dependencies

```bash
git clone <repository-url>
cd docker-ci-cd
npm install
```

### Run locally

```bash
npm start
```

The application listens on `http://localhost:5500` by default.

### Run in development mode

```bash
npm run dev
```

### Run with Docker

```bash
docker build -t docker-ci-cd-backend .
docker run -p 5500:5500 docker-ci-cd-backend
```

### Run with Docker Compose

```bash
docker compose up --build
```

This starts the backend plus supporting services defined in `compose.yaml`.

## Usage

### Environment variables

- `PORT` — HTTP port for the backend (default: `5500`)

Example:

```bash
PORT=3000 npm start
```

### Example requests

```bash
curl http://localhost:5500/health
curl http://localhost:5500/auth/health
curl http://localhost:5500/user/health
curl http://localhost:5500/metrics
```

## Endpoints

| Method | Path           | Description                         |
| ------ | -------------- | ----------------------------------- |
| GET    | `/health`      | Application health check            |
| GET    | `/auth/health` | Auth route health check             |
| GET    | `/user/health` | User route health check             |
| GET    | `/metrics`     | Prometheus metrics output           |

## Project structure

```
.
├── app.js                    # Application entry point
├── package.json              # Dependencies and scripts
├── Dockerfile                # Container image configuration
├── compose.yaml              # Local compose stack
├── eslint.config.js          # ESLint rules
├── routes/
│   ├── export.js             # Route exports
│   ├── auth/auth_routes.js   # Auth endpoints
│   └── user/user_routes.js   # User endpoints
├── .github/workflows/        # CI/CD workflows
├── .deploy/                  # Terraform deployment config
├── SUMMARY.md                # Project summary
└── README.md                 # Project documentation
```

### Linting

```bash
npx eslint . --ext .js
npx eslint . --ext .js --fix
```

## CI/CD and deployment

This repository includes two GitHub Actions workflows:

- `.github/workflows/create-build.yaml` — builds and pushes a Docker image to Docker Hub
- `.github/workflows/deploy-build.yaml` — applies Terraform deployment automation

### Create Build workflow

Triggered on push to `main`.

Steps:

1. checkout the repository
2. set up Docker Buildx
3. log in to Docker Hub
4. build and push a multi-platform Docker image
5. tag the image with `github.sha`

Required secrets:

- `DOCKER_HUB_USERNAME`
- `DOCKER_HUB_ACCESS_TOKEN`

### Deploy Build workflow

Triggered when the Create Build workflow completes successfully.

Steps:

1. checkout the repository
2. configure AWS credentials for `ap-south-1`
3. set up Terraform
4. run `terraform init` in `.deploy/`
5. run `terraform apply -auto-approve`

Required secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_HUB_USERNAME`

## Support

If you need help:

- open an issue in this repository
- inspect `app.js`, `routes/`, and `.github/workflows/`
- review `.deploy/` for deployment configuration

## Maintainers

Maintained by the repository owner and contributors. Contributions are welcome via issues and pull requests.

## License

Licensed under ISC as declared in `package.json`.
