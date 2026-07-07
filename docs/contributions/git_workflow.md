# OSEC Git Workflow

## Overview

OSEC follows a modified GitFlow workflow tailored for a 4-developer team. This approach balances structure with agility, ensuring stable releases while enabling parallel feature development.

## Branch Structure

```
main
  ▲
  │
release/vX.Y.Z
  ▲
  │
develop
  ▲
  │
feature/user-auth   feature/payments   fix/player-crash
```

### Permanent Branches

| Branch | Purpose | Protection |
|--------|---------|------------|
| `main` | Production-ready code. All commits to main are releases. | Protected — no direct pushes |
| `develop` | Integration branch for ongoing work. Default branch for PRs. | Protected — no direct pushes |

### Temporary Branches

| Branch | Source | Merges Into | Naming Pattern |
|--------|--------|-------------|----------------|
| Feature | `develop` | `develop` | `feature/<short-description>` |
| Bugfix | `develop` | `develop` | `bugfix/<short-description>` |
| Hotfix | `main` | `main` & `develop` | `hotfix/<short-description>` |
| Release | `develop` | `main` & `develop` | `release/v<major>.<minor>.<patch>` |
| Chore | `develop` | `develop` | `chore/<short-description>` |

## Workflow

### 1. Starting a New Feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication
```

### 2. Working on the Feature

- Commit frequently with [Conventional Commits](coding_standards.md#commit-message-format-conventional-commits).
- Rebase onto `develop` regularly to stay up to date:

```bash
git fetch origin develop
git rebase origin/develop
```

### 3. Completing a Feature

```bash
# Rebase to keep linear history
git fetch origin develop
git rebase origin/develop

# Create PR against develop (via GitHub UI or CLI)
gh pr create --base develop --head feature/user-authentication
```

### 4. Code Review & Merge

- PR requires at least 1 approval from another team member.
- All CI checks must pass.
- Merge via **Squash and Merge** to keep a clean `develop` history.

### 5. Creating a Release

```bash
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0
```

- Bump version numbers in `pubspec.yaml`, `package.json`, and CHANGELOG.
- Run full regression tests.
- Create PR from `release/v1.2.0` into `main`.

### 6. Deploying a Release

```bash
git checkout main
git pull origin main
git tag v1.2.0
git push origin v1.2.0
```

- Merge `main` back into `develop`:

```bash
git checkout develop
git merge main
```

## Commit Message Format

We strictly follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

See [coding_standards.md](coding_standards.md#commit-message-format-conventional-commits) for full type list and examples.

## Pull Request Process

1. Fill out the [PR template](../../.github/PULL_REQUEST_TEMPLATE.md) completely.
2. Add appropriate labels (`feature`, `bug`, `docs`, etc.).
3. Assign at least one reviewer.
4. Link related issues using `Fixes #123` or `Closes #123`.
5. Ensure CI passes before requesting review.

## Code Review Checklist

Reviewers should verify:

- [ ] Code follows coding standards
- [ ] Tests are added/updated and pass
- [ ] No new linting warnings/errors
- [ ] Edge cases are handled (empty states, errors, loading)
- [ ] No hardcoded secrets or environment-specific values
- [ ] Proper error handling and user feedback
- [ ] Localization strings are added (FR/EN)
- [ ] No performance regressions

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **Major:** Breaking changes
- **Minor:** New features (backward-compatible)
- **Patch:** Bug fixes (backward-compatible)

### Release Checklist

- [ ] All features for the release are merged to `develop`
- [ ] Release branch created from `develop`
- [ ] Version bumped in all relevant files
- [ ] CHANGELOG.md updated per Keep a Changelog
- [ ] Full test suite passes
- [ ] Release PR reviewed and approved
- [ ] Tag created on `main`
- [ ] Deployment to production completed
- [ ] `main` merged back to `develop`

## Handling Conflicts

- **During rebase:** Resolve conflicts in your local branch and continue rebase.
- **During merge:** Resolve in GitHub UI or locally.
- If conflicts are complex, sync with the other developer whose code conflicts.

## Emergency Hotfixes

For urgent production issues:

```bash
git checkout main
git checkout -b hotfix/critical-payment-fix
# Make the fix
git commit -m "fix(payments): resolve transaction timeout"
# PR into main (fast-track review)
# After merge, tag and deploy
# Then merge main into develop
```
