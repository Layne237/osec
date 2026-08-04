# OSEC Coding Standards

## General Principles

- **Readability first** — Code is written for humans first, machines second.
- **Consistency** — Follow existing patterns in the codebase.
- **SOLID principles** — Apply where practical, especially single responsibility and dependency inversion.
- **Testability** — Design code to be easily testable (dependency injection, pure functions).

## Dart / Flutter Style Guide

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | `snake_case` | `user_repository.dart` |
| Classes | `PascalCase` | `class UserRepository` |
| Methods/Functions | `camelCase` | `fetchUserData()` |
| Variables | `camelCase` | `final userName` |
| Constants | `camelCase` | `static const baseUrl` |
| Private members | Prefix with `_` | `_getInternalData()` |
| Directories | `snake_case` | `course_detail/` |
| Route names | `snake_case` | `/course_detail` |

### Dart Formatting

- Use `dart format` — the project enforces a single style.
- Maximum line length: 80 characters.
- Use trailing commas for collections and function parameters.
- Always specify types for public APIs.
- Use `final` by default; use `var` only when type is obvious from assignment.

### State Management (Provider)

```dart
// providers extend ChangeNotifier
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> login(String phone, String password) async {
    _currentUser = await _authRepository.login(phone, password);
    notifyListeners();
  }
}
```

### Widget Structure

```dart
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const _Header(),
              const _LoginForm(),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Private widgets for screen-specific components
class _Header extends StatelessWidget { ... }
```

### Imports Order

1. Dart SDK (`dart:async`, `dart:io`)
2. Flutter SDK (`package:flutter/...`)
3. Third-party packages (`package:dio/...`)
4. Project imports (`package:osec/...`)
5. Relative imports (`../...`)

Separate groups with a blank line.

## Node.js Style Guide

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | `camelCase` | `authController.js` |
| Classes | `PascalCase` | `class AuthService` |
| Functions | `camelCase` | `generateToken()` |
| Constants | `UPPER_SNAKE_CASE` | `const JWT_SECRET` |
| Directories | `kebab-case` | `payment-services/` |
| Routes | `kebab-case` | `/api/v1/user-profile` |

### Express.js Patterns

```js
// controllers handle request/response
// services handle business logic
// models handle data access

const authService = require('../services/auth/authService');

exports.register = async (req, res, next) => {
  try {
    const user = await authService.register(req.body);
    res.status(201).json({ success: true, data: user });
  } catch (error) {
    next(error);
  }
};
```

### Error Handling

Use a centralized error handler middleware:

```js
const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    error: {
      code: err.code || 'INTERNAL_ERROR',
      message: err.message
    }
  });
};
```

## Comment Practices

- **DO NOT** add comments that state the obvious (`// increment counter`).
- **DO** add comments explaining WHY, not WHAT.
- **DO** document public APIs with DartDoc or JSDoc.
- **DO** mark TODOs with the responsible developer's name: `// TODO(jane): Refactor this when API v2 is released`
- **DO** use `FIXME` for known issues: `// FIXME: Memory leak on orientation change`

## Testing Standards

- **Unit tests:** Test one unit of behavior in isolation. Mock dependencies.
- **Widget tests:** Test UI rendering and interaction for each widget.
- **Integration tests:** Test critical user flows end-to-end.
- **Coverage target:** Minimum 80% for new code.

```dart
// Test file mirrors source structure
// Source: lib/data/repositories/user_repository.dart
// Test:   test/data/repositories/user_repository_test.dart
```

## Linting

- Flutter: Use the project's `analysis_options.yaml`.
- Node.js: Use ESLint with the provided config.
- All linting errors must be resolved before committing.
- Warnings should be reviewed and addressed.

## Security Practices

- Never log sensitive data (passwords, tokens, API keys).
- Never commit `.env` files or secrets to version control.
- Validate and sanitize all user inputs.
- Use parameterized queries / prepared statements for databases.
- Apply principle of least privilege for API tokens.
- Rate-limit authentication endpoints.
