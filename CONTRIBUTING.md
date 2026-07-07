# Contributing to OSEC

Thank you for considering contributing to the OSEC project! This document outlines the guidelines for contributing to ensure a smooth and consistent workflow.

## Code of Conduct

By participating in this project, you agree to uphold a respectful and inclusive environment. Harassment, discriminatory language, and personal attacks are not tolerated.

## Branch Naming Conventions

All branches must follow the pattern: `<type>/<short-description>`

| Type | Usage |
|------|-------|
| `feature/` | New features (e.g., `feature/user-authentication`) |
| `bugfix/` | Bug fixes (e.g., `bugfix/login-crash`) |
| `hotfix/` | Urgent production fixes (e.g., `hotfix/payment-timeout`) |
| `release/` | Release preparation (e.g., `release/v1.2.0`) |
| `chore/` | Maintenance tasks (e.g., `chore/update-deps`) |
| `refactor/` | Code restructuring (e.g., `refactor/api-routes`) |

Use kebab-case for descriptions. Keep branch names concise but descriptive.

## Commit Message Format (Conventional Commits)

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat` — A new feature
- `fix` — A bug fix
- `docs` — Documentation changes
- `style` — Code style changes (formatting, missing semicolons, etc.)
- `refactor` — Code refactoring (neither fixes nor adds feature)
- `perf` — Performance improvements
- `test` — Adding or updating tests
- `chore` — Maintenance, dependencies, build process
- `ci` — CI/CD changes

### Examples
```
feat(auth): add OTP verification endpoint
fix(player): resolve memory leak on video exit
docs(api): update payment endpoint examples
chore(deps): upgrade flutter to 3.16.0
```

## Pull Request Process

1. **Create a branch** from `develop` following the branch naming convention above.
2. **Make your changes** following the coding standards in `docs/contributions/coding_standards.md`.
3. **Write or update tests** — aim for at least 80% coverage on new code.
4. **Run tests locally** and ensure all pass.
5. **Rebase onto develop** to keep a linear history.
6. **Create a pull request** against `develop` using the PR template.
7. **Request review** from at least one other team member.
8. **Address feedback** and push changes as needed.
9. **Merge** after approval and successful CI checks.

## Code Review Expectations

- All code must be reviewed by at least one other developer before merging.
- Reviewers should check for:
  - Correctness and logic
  - Adherence to coding standards
  - Test coverage
  - Performance implications
  - Security best practices
- Be constructive and respectful in code reviews.
- Respond to review comments within 24 hours on weekdays.

## Testing Requirements

- **Unit tests** are required for all business logic (domain layer).
- **Widget tests** are required for all UI components.
- **Integration tests** are required for critical user flows (auth, payment, playback).
- Tests must pass before any merge.
- Test files should mirror the source file structure under `test/`.

## Getting Help

- Open a [Discussion](https://github.com/Layne237/osec/discussions) for questions.
- Tag the relevant team member for specific expertise.
- Check existing documentation in the `docs/` folder first.

Thank you for contributing to OSEC! 🚀
