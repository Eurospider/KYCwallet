# Contributing

Thanks for your interest in contributing to this project! This document covers how to get set up, our contribution process, and what to expect.

## Contributor License Agreement (CLA)

Before we can accept your contribution, you'll need to sign our [Contributor License Agreement (CLA)](CLA.md).

This is handled automatically:

1. Open a pull request.
2. Our CLA bot will comment on the PR with instructions.
3. Follow the link (or comment as instructed) to sign.
4. Once signed, the check will pass and you won't need to sign again for future contributions from the same account.

You only need to do this once per GitHub account.

## Ways to Contribute

- **Report bugs** by opening an issue with steps to reproduce, expected vs. actual behavior, and your environment details.
- **Suggest features** by opening an issue describing the problem you're trying to solve (not just the solution).
- **Submit code** via pull requests for bug fixes, features, or documentation improvements.
- **Improve docs** — typo fixes, clarifications, and examples are always welcome.

## Getting Started

1. Fork the repository and clone it locally.
2. Create a new branch for your change:
   ```bash
   git checkout -b your-branch-name
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Make your changes, following the code style guidelines below.
5. Add or update tests as needed.
6. Run the test suite:
   ```bash
   npm test
   ```

## Pull Request Process

1. Ensure your branch is up to date with `main` before opening a PR.
2. Fill out the PR template, including a clear description of what changed and why.
3. Link any related issues.
4. Make sure CI checks (tests, linting, CLA) pass.
5. A maintainer will review your PR. Please be responsive to review feedback — PRs with no activity after 30 days may be closed.
6. Once approved, a maintainer will merge your PR.

## Code Style

- Follow the existing formatting and naming conventions in the codebase.
- Run the linter before submitting: `npm run lint`
- Keep commits focused and write clear commit messages (e.g., `fix: handle empty input in parser`).

## Reporting Security Issues

Please **do not** open a public issue for security vulnerabilities. Instead, email [admin@eurospider.com](mailto:admin@eurospider.com) with details, and we'll respond as soon as possible.

## Questions?

Open an issue with the `question` label, or reach out via [Discussions](../../discussions).
