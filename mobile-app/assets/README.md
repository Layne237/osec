# Assets

This folder holds the static assets bundled with the OSEC mobile app, as declared in [pubspec.yaml](../pubspec.yaml).

## Folders

### `images/`

App icons, illustrations, logos, and onboarding artwork.

- `app_icon.png` — source image for `flutter_launcher_icons` (see `flutter_launcher_icons` config in `pubspec.yaml`). Must be at least 1024x1024px.
- Prefer `.png` for icons/illustrations with transparency and `.webp` for large photographic assets to keep app size down.
- Use `2.0x` / `3.0x` suffixed variants (e.g. `logo.png`, `2.0x/logo.png`, `3.0x/logo.png`) for assets that need to look sharp on high-density screens.

### `fonts/`

OSEC brand typefaces, referenced by the `fonts:` section of `pubspec.yaml`:

- **Montserrat** — headings and display text (`Regular`, `Bold`, `SemiBold`).
- **Inter** — body text and UI labels (`Regular`, `Medium`, `SemiBold`).

Font files are `.ttf` and must match the exact filenames declared in `pubspec.yaml`.

### `videos/`

Local video assets bundled with the app (e.g. short preview clips, promotional trailers, or onboarding motion graphics). Full course content is streamed from the backend and is **not** stored here — this folder is for small, shippable assets only.

## Guidelines

- Keep individual assets as small as possible; large binary files bloat the app bundle and slow down CI.
- Do not commit copyrighted or licensed course video content to this repository.
- When adding a new asset folder, remember to declare it under `flutter: assets:` in `pubspec.yaml`.
