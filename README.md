# personal_de (Salesforce SFDX Project)

This repository is primarily for my personal Salesforce development and experimentation. It includes a clean, professional setup (CI, linting, tests) but is not intended for external contributions. The code is open-sourced under MIT for transparency and reuse.

## Repository structure

- `force-app/` — deployable metadata (source format)
- `manifest/` — package.xml for selective retrieve/deploy
- `config/` — scratch org definitions and project config
- `scripts/` — helper scripts (apex/ and soql/)
- `.github/` — CI workflow, PR template, CODEOWNERS
- Tooling: ESLint, Prettier, Jest

## Prerequisites

- Node.js LTS and npm
- Salesforce CLI (`sf`)
- VS Code with Salesforce extensions (recommended)

## Quick start (scratch org)

1. Install dependencies
   ```
   npm ci
   ```
2. Create a scratch org
   ```
   sf org create scratch -f config/project-scratch-def.json -a myScratch -d 7 -s
   ```
3. Push source
   ```
   sf project deploy start -d force-app -o myScratch
   ```
4. Open the org
   ```
   sf org open -o myScratch
   ```

## Validation

- Lint
  ```
  npm run lint
  ```
- Unit tests
  ```
  npm test
  ```
- Format (Prettier)
  ```
  npm run format
  ```
- Optional dry-run deploy (no changes committed to an org)
  ```
  sf project deploy start -d force-app -o myScratch --dry-run
  ```

## NPM scripts

Common scripts (see package.json):

- `lint`: ESLint over `force-app`
- `test`: Jest tests
- `format`: Prettier write
- `validate`: `npm run lint && npm run test`
- `deploy`: `sf project deploy start -d force-app`
- `retrieve`: `sf project retrieve start -x manifest/package.xml`

## CI

GitHub Actions workflow at `.github/workflows/ci.yml` runs on pushes/PRs to `main`:

- Install Node and dependencies
- Lint
- Run tests
- Prettier check

Add a status badge after first run:

```
![CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)
```

## Contributing

This is a personal project and not actively seeking external contributions. If you open an issue or PR, I may review it at my discretion. For reference, internal guidance remains in [CONTRIBUTING.md](CONTRIBUTING.md), and code ownership defaults to [CODEOWNERS](.github/CODEOWNERS).

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, copy, modify, and distribute the code under the terms of the MIT license. No warranty is provided.

## Notes

- Use `sf` CLI (not deprecated `sfdx`).
- Respect security and governor-limit best practices in Apex/LWC per your internal rules.
