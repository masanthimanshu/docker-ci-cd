# AGENTS.md — AI Agent Instructions

Purpose

- Provide concise, actionable guidance for AI coding agents working in this repository.

Quick start (commands)

- Install dependencies: `npm install`
- Run in production mode: `npm start`
- Run in development mode: `npm run dev` (requires `nodemon`)
- Linting: run `eslint` (project contains `eslint.config.js`).

What this project is

- Minimal Express backend (single-file service).
- Entry point: [app.js](app.js)
- Package manifest: [package.json](package.json)

Important conventions and notes

- Uses ES modules (`"type": "module"` in `package.json`).
- The server listens on `process.env.PORT || 5500`.
- Keep changes minimal and focused; prefer small PRs for infra or runtime changes.
- No test framework currently present — do not add tests without discussing scope.

Where to look first

- [app.js](app.js) — service routes and startup logic
- [package.json](package.json) — scripts and dependencies
- [eslint.config.js](eslint.config.js) — linting rules

Suggested next agent customizations

- Add a `.github/copilot-instructions.md` to document reviewer preferences and PR checks.
- Add a small `skill` to run `npm install && npm run dev` and surface common errors.

If you want, I can create the `.github/copilot-instructions.md` or implement one of the suggested skills next. Feedback welcome.
