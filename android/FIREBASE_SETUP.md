# Firebase Setup per Flavor (Android)

Each build flavor requires its own `google-services.json` file placed in the corresponding source folder.

## Required file locations

| Flavor   | Path                                          | Package name        |
|----------|-----------------------------------------------|---------------------|
| dev      | `android/app/src/dev/google-services.json`    | com.tbg.cliceat     |
| staging  | `android/app/src/staging/google-services.json`| com.tbg.cliceat     |
| prod     | `android/app/src/prod/google-services.json`   | com.tbg.cliceat     |

> Note: `applicationIdSuffix` is intentionally commented out in `build.gradle.kts` so all flavors share the same package name `com.tbg.cliceat`. Register separate Android apps in each Firebase project (dev / staging / prod) using the same package name.

## How to generate google-services.json

1. Open [Firebase Console](https://console.firebase.google.com)
2. Select (or create) the Firebase project for the target environment (dev / staging / prod)
3. Go to **Project Settings** → **Your apps** → **Add app** → Android
4. Use package name: `com.tbg.cliceat`
5. Download `google-services.json`
6. Place it in the correct path listed above

## Security

These files contain API keys and project IDs and **must not be committed** to version control.
Add them to `.gitignore`:

```
android/app/src/dev/google-services.json
android/app/src/staging/google-services.json
android/app/src/prod/google-services.json
```

## iOS

For iOS, place `GoogleService-Info.plist` files in the corresponding scheme-specific build phase or use a pre-build script to copy the correct file based on the active scheme (dev / staging / prod). The bundle ID is `com.tbg.cliceat` for all environments.
