# AGENTS.md — AI Agent Instructions

Purpose

- Provide concise, actionable guidance for AI coding agents working in this repository.

Quick start (commands)

- Install dependencies: `npm install`
- Run in production mode: `npm start`
- Run in development mode: `npm run dev` (requires `nodemon` in PATH)
- Linting: `npx eslint . --ext .js`
- Docker build: `docker build -t docker-ci-cd:latest .`
- Docker run: `docker run --rm -p 5500:5500 docker-ci-cd:latest`

What this project is

- Minimal Express backend example for Docker / CI-CD demos.
- Uses ES modules (`"type": "module"` in `package.json`).
- Entry point: [app.js](app.js)
- Route registration is centralized in [routes/export.js](routes/export.js).
- Exposes Prometheus metrics at `GET /metrics` via `prom-client`.

Important conventions and notes

- Express v5 is used with global JSON parsing and CORS enabled.
- Default port is `5500`; override with `PORT`.
- Current routes:
  - `GET /health` — root health check
  - `GET /auth/health` — auth route health check
  - `GET /user/health` — user route health check
  - `GET /metrics` — Prometheus metrics output
- Route modules export `routes` and are mounted through `routes/export.js`.
- No test framework exists yet; do not add tests without discussing scope.
- The `dev` script depends on `nodemon`; if it is not installed locally, use `npx nodemon .` or add it as a dev dependency.

Where to look first

- [app.js](app.js) — app setup and route mounting
- [routes/export.js](routes/export.js) — route exports
- [routes/auth/auth_routes.js](routes/auth/auth_routes.js) — auth route module
- [routes/user/user_routes.js](routes/user/user_routes.js) — user route module
- [package.json](package.json) — scripts and dependencies
- [Dockerfile](Dockerfile) — container build definition
- [eslint.config.js](eslint.config.js) — lint rules
- [.github/workflows/create-build.yaml](.github/workflows/create-build.yaml) — Docker build and push workflow
- [.github/workflows/deploy-build.yaml](.github/workflows/deploy-build.yaml) — deploy workflow triggered after build success
- [.deploy/main.tf](.deploy/main.tf) — Terraform deploy resources for AWS SSM
- [.deploy/variables.tf](.deploy/variables.tf) — Terraform input variables

Guidance for agents

- Prefer small, focused changes.
- Avoid introducing new frameworks or major architecture changes without explicit scope.
- Preserve the simple demo nature of the repository.
- Keep deployment automation intact: build workflow pushes a multi-arch Docker image, and deploy workflow applies Terraform to create an SSM-based deploy command for EC2 targets.
