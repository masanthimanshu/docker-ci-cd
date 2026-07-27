# Docker CI/CD Backend

[![Node.js 24](https://img.shields.io/badge/Node.js-24-green)](https://nodejs.org/)
[![Express 5.x](https://img.shields.io/badge/Express-5.x-black)](https://expressjs.com/)
[![Docker Ready](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://www.docker.com/)

A container-ready Node.js and Express backend service built to demonstrate modular API design, observability, and automated DevOps delivery with Docker, GitHub Actions, and Terraform.

## Table of Contents

- [What it does](#what-it-does)
- [Why it is useful](#why-it-is-useful)
- [Getting started](#getting-started)
- [Usage](#usage)
- [Endpoints](#endpoints)
- [Development](#development)
- [CI/CD and deployment](#cicd-and-deployment)
- [Support](#support)
- [Maintainers](#maintainers)
- [License](#license)

## What it does

This repository provides a backend service with:

- a lightweight Express API with separate `auth` and `user` route modules
- a health-check endpoint for service readiness
- Prometheus-compatible metrics via `/metrics`
- a Dockerfile for container builds
- a sample `docker compose` stack with MongoDB, Prometheus, and Grafana
- GitHub Actions workflows for build and deployment
- Terraform-driven AWS deployment logic in `.deploy/`

## Why it is useful

Use this project to:

- learn how to organize a Node.js backend into modular route components
- run a containerized service locally or in CI/CD pipelines
- expose metrics for monitoring and observability
- automate image build and push workflows with GitHub Actions
- deploy Docker containers to AWS using Terraform and SSM

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

The app listens on `http://localhost:5500` by default.

### Run in development mode

```bash
npm run dev
```

> Note: `npm run dev` uses `nodemon`. Install it globally if needed:
>
> ```bash
> npm install -g nodemon
> ```

### Run with Docker

```bash
docker build -t docker-ci-cd-backend .
docker run -p 5500:5500 docker-ci-cd-backend
```

### Run the sample compose stack

The provided `compose.yaml` defines a local stack for the backend, MongoDB, Prometheus, and Grafana.

```bash
docker compose up --build
```

> The backend currently exposes its own API and metrics endpoints; the compose file is useful for extending local development into a broader observability/demo stack.

## Usage

### Environment configuration

- `PORT` — port to listen on (default: `5500`)

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
| GET    | `/auth/health` | Auth module health check            |
| GET    | `/user/health` | User module health check            |
| GET    | `/metrics`     | Prometheus metrics output           |

## Development

### Project structure

```
.
├── app.js                    # Application entry point
├── package.json              # Dependencies and scripts
├── Dockerfile                # Container image configuration
├── compose.yaml              # Local multi-service stack
├── eslint.config.js          # ESLint rules
├── routes/
│   ├── export.js             # Route exports
│   ├── auth/auth_routes.js   # Auth endpoints
│   └── user/user_routes.js   # User endpoints
├── .github/workflows/        # CI/CD workflows
├── .deploy/                  # Terraform AWS deployment config
├── README.md                 # Project documentation
└── SUMMARY.md                # Project summary
```

### Linting

```bash
npx eslint . --ext .js
npx eslint . --ext .js --fix
```

## CI/CD and deployment

This project includes GitHub Actions workflows under `.github/workflows/`:

- `create-build.yaml` — builds and pushes a Docker image to Docker Hub
- `deploy-build.yaml` — deploys the image using AWS credentials and Terraform

The deployment workflow uses `.deploy/` to apply an AWS SSM document and associate it with EC2 instances tagged `BackendServer`.

### Create Build Workflow

Triggered on every push to the `main` branch:

1. Checks out code
2. Sets up Docker Buildx
3. Logs into Docker Hub
4. Builds and pushes a multi-platform Docker image
5. Tags the image with the current commit SHA

**Secrets Required:**

- `DOCKER_HUB_USERNAME`
- `DOCKER_HUB_ACCESS_TOKEN`

### Deploy Build Workflow

Triggered after the Create Build workflow completes successfully:

1. Checks out code
2. Configures AWS credentials for `ap-south-1`
3. Sets up Terraform
4. Runs `terraform init` in `.deploy/`
5. Runs `terraform apply -auto-approve`
6. Deploys the Docker image to EC2 instances tagged `Role: BackendServer`

**Secrets Required:**

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_HUB_USERNAME`

### Setting up GitHub secrets

To enable the CI/CD pipeline, add the following secrets in the repository settings:

- `DOCKER_HUB_USERNAME`
- `DOCKER_HUB_ACCESS_TOKEN`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Support

If you need help, open an issue in this repository.

## Maintainers

Maintained by the repository owner. Contributions are welcome via issues and pull requests.

## License

Licensed under ISC as declared in `package.json`.
