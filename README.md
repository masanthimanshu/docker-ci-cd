# Docker CI/CD Backend

[![Node.js 24](https://img.shields.io/badge/Node.js-24-green)](https://nodejs.org/)
[![Express 5.x](https://img.shields.io/badge/Express-5.x-black)](https://expressjs.com/)
[![Docker Ready](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://www.docker.com/)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](./LICENSE)

A containerized Node.js + Express backend service designed to demonstrate secure, scalable application architecture for modern DevOps and CI/CD workflows.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Available Endpoints](#available-endpoints)
- [Development](#development)
- [CI/CD Pipeline](#cicd-pipeline)
- [Infrastructure](#infrastructure)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

## Features

✨ **Key Capabilities:**

- **Modular REST API** – Clean, organized routing with auth and user modules
- **Docker Containerization** – Production-ready Dockerfile for consistent deployments
- **CORS Support** – Secure cross-origin requests out of the box
- **Health Check Endpoints** – Built-in monitoring and service verification
- **Environment Configuration** – Flexible port and settings management
- **Code Quality** – ESLint configuration for consistent code standards
- **Development & Production Modes** – Separate scripts for local development (with hot reload) and production
- **Automated CI/CD Pipeline** – GitHub Actions workflows for build, test, and deployment
- **Infrastructure-as-Code** – Terraform configuration for AWS deployment

## Quick Start

### Prerequisites

- **Node.js** 24+ (includes npm)
- **Docker** (optional, for containerized deployment)

### Local Setup (5 minutes)

```bash
# 1. Clone the repository
git clone <repository-url>
cd docker-ci-cd

# 2. Install dependencies
npm install

# 3. Start the development server
npm run dev

# Application will be running at http://localhost:5500
```

### Using Docker

```bash
# Build the Docker image
docker build -t docker-ci-cd-backend .

# Run the container
docker run -p 5500:5500 docker-ci-cd-backend

# Application will be accessible at http://localhost:5500
```

## Installation

### From Source

```bash
# Install dependencies
npm install
```

**Dependencies:**

- `express` – Web application framework
- `cors` – Cross-Origin Resource Sharing middleware

**Development Dependencies:**

- `@eslint/js` – JavaScript linting rules
- `eslint` – Code quality tool
- `nodemon` – Auto-reload for development
- `globals` – Global variable definitions

## Usage

### Starting the Application

```bash
# Production mode
npm start

# Development mode (with auto-reload)
npm run dev
```

### Environment Variables

You can configure the application by setting environment variables:

```bash
# Custom port (defaults to 5500)
PORT=3000 npm start
```

### Example API Calls

**Health Check (Main):**

```bash
curl http://localhost:5500/health
# Response: {"message":"It's Working!"}
```

**Auth Module Health Check:**

```bash
curl http://localhost:5500/auth/health
# Response: {"message":"Auth route is working!"}
```

**User Module Health Check:**

```bash
curl http://localhost:5500/user/health
# Response: {"message":"User route is working!"}
```

## Available Endpoints

| Method | Endpoint       | Description                   |
| ------ | -------------- | ----------------------------- |
| `GET`  | `/health`      | Main application health check |
| `GET`  | `/auth/health` | Authentication module status  |
| `GET`  | `/user/health` | User management module status |

## Development

### Project Structure

```
.
├── app.js                    # Application entry point
├── package.json              # Dependencies and scripts
├── Dockerfile                # Container configuration
├── eslint.config.js          # Code quality rules
├── routes/
│   ├── export.js             # Route exports
│   ├── auth/
│   │   └── auth_routes.js    # Authentication endpoints
│   └── user/
│       └── user_routes.js    # User management endpoints
├── .github/
│   ├── workflows/
│   │   ├── create-build.yaml # Build and push Docker image
│   │   └── deploy-build.yaml # Terraform deployment to AWS
│   └── AGENTS.md             # AI agent instructions
├── .deploy/
│   ├── main.tf               # AWS infrastructure definition
│   └── variables.tf          # Terraform variables
├── README.md                 # This file
└── SUMMARY.md                # Project summary
```

### Code Quality

Check code quality with ESLint:

```bash
# Run linting
npx eslint . --ext .js

# Fix auto-fixable issues
npx eslint . --ext .js --fix
```

### Adding New Routes

1. Create a new route file in `routes/<module-name>/`:

```javascript
import { Router } from "express";

export const routes = Router();

routes.get("/endpoint", (req, res) => {
  res.json({ message: "Your response" });
});
```

2. Export the route in `routes/export.js`:

```javascript
export { routes as moduleRoutes } from "./module-name/routes.js";
```

3. Mount the route in `app.js`:

```javascript
app.use("/module-name", route.moduleRoutes);
```

## CI/CD Pipeline

This project includes a fully automated CI/CD pipeline using GitHub Actions and AWS.

### Workflow Overview

```
Code Push to main
        ↓
   Create Build (GitHub Actions)
        ↓
  Build & Push Docker Image
        ↓
   Deploy Build (GitHub Actions)
        ↓
   Terraform Apply (AWS Infrastructure)
        ↓
   Deploy to EC2 Instances
```

### Create Build Workflow (`.github/workflows/create-build.yaml`)

Triggered on every push to the `main` branch:

1. **Checks out code** – Retrieves the latest source
2. **Sets up Docker Buildx** – Prepares multi-platform Docker builds
3. **Logs into Docker Hub** – Authenticates with Docker registry
4. **Builds and pushes image** – Creates images for `linux/amd64` and `linux/arm64` platforms
5. **Tags with commit SHA** – Images tagged as `<docker-user>/testing:<commit-sha>`

**Secrets Required:**

- `DOCKER_HUB_USERNAME` – Your Docker Hub username
- `DOCKER_HUB_ACCESS_TOKEN` – Docker Hub access token

### Deploy Build Workflow (`.github/workflows/deploy-build.yaml`)

Triggered after the Create Build workflow completes successfully:

1. **Checks out code** – Retrieves the repository
2. **Configures AWS credentials** – Authenticates with AWS (region: `ap-south-1`)
3. **Sets up Terraform** – Installs Terraform CLI
4. **Initializes Terraform** – Runs `terraform init` in `.deploy/`
5. **Applies infrastructure** – Executes `terraform apply -auto-approve` to deploy changes
6. **Deploys container to EC2** – Container is pulled and run on EC2 instances tagged with `Role: BackendServer`

**Secrets Required:**

- `AWS_ACCESS_KEY_ID` – AWS access key
- `AWS_SECRET_ACCESS_KEY` – AWS secret access key
- `DOCKER_HUB_USERNAME` – Docker Hub username (for pulling images)

### Setting Up GitHub Secrets

To enable the CI/CD pipeline:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add the following secrets:
   - `DOCKER_HUB_USERNAME`
   - `DOCKER_HUB_ACCESS_TOKEN`
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

## Infrastructure

The infrastructure is managed using **Terraform** and deployed to AWS.

### Technology Stack

- **Provider:** AWS (ap-south-1 region)
- **Infrastructure as Code:** Terraform ~> 6.0
- **Deployment Method:** AWS Systems Manager (SSM) Documents and Associations

### Infrastructure Components

The Terraform configuration in `.deploy/main.tf` defines:

1. **AWS SSM Document (`DeployApp`)** – Contains shell commands to:
   - Stop and remove any existing backend container
   - Pull the latest Docker image from Docker Hub
   - Run the container on port 5500

2. **AWS SSM Association** – Associates the deployment document with:
   - EC2 instances tagged with `Role: BackendServer`
   - Automatically applies the deployment to matching instances

### Variables

The infrastructure uses two Terraform variables (defined in `.deploy/variables.tf`):

| Variable      | Type   | Description                                                |
| ------------- | ------ | ---------------------------------------------------------- |
| `docker_user` | string | Docker Hub username (injected from GitHub Actions)         |
| `image_tag`   | string | Docker image tag/commit SHA (injected from GitHub Actions) |

### Terraform Commands

If deploying manually:

```bash
# Navigate to infrastructure directory
cd .deploy/

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

**Environment Variables for Manual Deployment:**

```bash
export TF_VAR_docker_user="your-docker-username"
export TF_VAR_image_tag="sha256-or-tag"
terraform apply
```

## Deployment

### Automated Deployment (CI/CD Pipeline)

The recommended way to deploy is through the automated GitHub Actions pipeline:

1. **Push code** to the `main` branch
2. **GitHub Actions automatically:**
   - Builds Docker image
   - Pushes to Docker Hub
   - Deploys via Terraform to AWS EC2 instances

### Manual Docker Deployment

The project includes a production-ready Dockerfile:

```dockerfile
FROM node:24
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 5500
CMD ["npm", "start"]
```

**Build and run:**

```bash
docker build -t docker-ci-cd-backend .
docker run -p 5500:5500 docker-ci-cd-backend
```

### Environment-Specific Configuration

To run on a different port in production:

```bash
docker run -e PORT=8080 -p 8080:8080 docker-ci-cd-backend
```

### Code Quality

Check code quality with ESLint:

```bash
# Run linting
npx eslint . --ext .js

# Fix auto-fixable issues
npx eslint . --ext .js --fix
```

## Contributing

We welcome contributions! To contribute:

1. **Fork** this repository
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Make your changes** and follow the ESLint standards
4. **Test** your changes locally
5. **Commit** with clear messages: `git commit -m "Add feature: description"`
6. **Push** to your branch: `git push origin feature/your-feature`
7. **Open a Pull Request** with a clear description of your changes

### Code Standards

- Follow ESLint rules (run `npm run lint` to check)
- Use ES6 modules (import/export syntax)
- Add comments for complex logic
- Test endpoints locally before submitting

## Support

### Getting Help

- **Local Issues**: Check application logs with `npm run dev`
- **Health Checks**: Use the `/health`, `/auth/health`, and `/user/health` endpoints to verify service status
- **Port Conflicts**: If port 5500 is in use, change it: `PORT=3000 npm start`
- **Docker Issues**: Ensure Docker daemon is running: `docker ps`

### Troubleshooting

| Issue                 | Solution                                                                        |
| --------------------- | ------------------------------------------------------------------------------- |
| `Port already in use` | Use `PORT=<another-port> npm start`                                             |
| `Module not found`    | Run `npm install` to ensure all dependencies are installed                      |
| `Docker build fails`  | Verify Docker is running: `docker ps`                                           |
| `CORS errors`         | CORS is already enabled; check that your client request includes proper headers |

## License

This project is licensed under the **ISC License** – see the LICENSE file for details.

---

**Built with ❤️ for CI/CD demonstrations and modern DevOps workflows**
