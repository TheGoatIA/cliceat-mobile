# ClicEat — Application Mobile

Plateforme de commande et livraison de repas opérant à Douala et Yaoundé, Cameroun.

## Aperçu

ClicEat connecte les clients avec des restaurants locaux et des livreurs, offrant une expérience de commande fluide avec paiement via Orange Money, MTN MoMo ou en espèces.

| Rôle | Fonctionnalités |
|------|----------------|
| **Client** | Découverte restaurants, panier, commande, suivi en temps réel, historique |
| **Livreur** | Dashboard missions, navigation GPS, confirmation livraison avec photo |

## Stack Technique

- **Framework** : Flutter 3.x (Dart 3)
- **Architecture** : Clean Architecture + BLoC (`flutter_bloc`, `freezed`)
- **DI** : `get_it` + `injectable`
- **HTTP** : `chopper` avec retry (×3), refresh JWT automatique
- **Base de données locale** : `drift` (SQLite) — schéma v2
- **Cartes** : `mapbox_maps_flutter` — clusters GeoJSON, navigation externe
- **Push notifications** : `firebase_messaging` + déduplication
- **Paiement** : NotchPay via WebView sécurisée (`FLAG_SECURE`)
- **i18n** : `easy_localization` — Français (FR) et Anglais (EN)
- **Offline** : `OfflineSyncService` avec file d'attente Drift

## Prérequis

- Flutter SDK ≥ 3.x (`flutter --version`)
- Dart SDK ≥ 3.0
- Android Studio / Xcode pour les builds natifs
- Compte Firebase avec projet configuré
- Token Mapbox

## Installation

```bash
# Cloner le dépôt
git clone https://github.com/TheGoatIA/cliceat-mobile.git
cd cliceat-mobile

# Installer les dépendances
flutter pub get

# Générer le code (freezed, injectable, drift, chopper)
dart run build_runner build --delete-conflicting-outputs
```

## Configuration

### 1. Variables d'environnement

Copier `.env.example` vers `.env` et renseigner les valeurs :

```bash
cp .env.example .env
```

```env
APP_ENV=dev
API_BASE_URL=https://api.cliceat.cm/api/v1
MAPBOX_ACCESS_TOKEN=pk.eyJ1IjoiY2xpY2VhdCIsImEiOi...
WS_URL=wss://api.cliceat.cm
NOTCHPAY_PUBLIC_KEY=pk_...
```

### 2. Firebase

1. Créer un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com)
2. Exécuter `flutterfire configure` pour générer `firebase_options.dart`
3. Placer `google-services.json` dans `android/app/`
4. Placer `GoogleService-Info.plist` dans `ios/Runner/`
5. Remplacer `REPLACE_WITH_REVERSED_CLIENT_ID` dans `ios/Runner/Info.plist` avec la valeur `REVERSED_CLIENT_ID` de `GoogleService-Info.plist`

### 3. Signing Android (release)

```bash
# Générer le keystore
keytool -genkey -v -keystore android/cliceat-release.jks \
  -alias cliceat -keyalg RSA -keysize 2048 -validity 10000

# Créer android/key.properties (gitignored)
cat > android/key.properties <<EOF
storeFile=cliceat-release.jks
storePassword=VOTRE_MOT_DE_PASSE
keyAlias=cliceat
keyPassword=VOTRE_MOT_DE_PASSE
EOF
```

## Lancer l'application

```bash
# Mode développement
flutter run -t lib/main_dev.dart

# Mode staging
flutter run -t lib/main_staging.dart

# Mode production
flutter run -t lib/main_prod.dart
```

## Builds de distribution

```bash
# Android APK
flutter build apk --release -t lib/main_prod.dart

# Android App Bundle (Play Store)
flutter build appbundle --release -t lib/main_prod.dart

# iOS (requires macOS + Xcode)
flutter build ipa --release -t lib/main_prod.dart
```

## Tests

```bash
# Tous les tests
flutter test

# Tests avec couverture
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Structure du projet

```
lib/
├── core/
│   ├── config/          # FlavorConfig, AppConstants, EnvConfig
│   ├── data/local/      # Drift database, DAOs, tables
│   ├── di/              # get_it + injectable registration
│   ├── errors/          # AppError, Failure types
│   ├── mixins/          # SecureScreenMixin (FLAG_SECURE)
│   ├── models/          # Shared models (freezed)
│   ├── network/         # Chopper client, intercepteurs (retry, refresh, timeout)
│   ├── repositories/    # OrderRepository, UserRepository, DriverRepository
│   ├── router/          # GoRouter + guards par rôle
│   ├── services/        # WebSocket, Notifications, Analytics, OfflineSync
│   └── widgets/         # ConnectivityBanner, AppNetworkImage
├── features/
│   ├── auth/            # BLoC auth, pages login/register/OTP
│   ├── client/          # Home, panier, checkout, paiement, historique
│   ├── delivery/        # Dashboard livreur, missions, navigation
│   └── legal/           # CGU, Politique de confidentialité
├── main_dev.dart
├── main_staging.dart
├── main_prod.dart
└── main_common.dart     # Bootstrap commun (Firebase, DI, runApp)
```

## Sécurité

- Tokens JWT stockés dans `flutter_secure_storage` (Keychain iOS / Keystore Android)
- Token FCM révoqué à la déconnexion (`FirebaseMessaging.instance.deleteToken()`)
- Écran de paiement protégé contre les captures d'écran (`FLAG_SECURE`)
- Refresh token via mutex (un seul appel `/auth/refresh` en parallèle)
- Whitelist stricte des statuts de paiement valides

## Identifiants applicatifs

| Plateforme | Identifiant |
|-----------|-------------|
| Android | `cm.cliceat.app` |
| iOS | `cm.cliceat.app` |

## Contribution

1. Créer une branche depuis `develop` : `git checkout -b feat/ma-fonctionnalite`
2. Committer avec des messages clairs en français ou anglais
3. Ouvrir une Pull Request vers `develop`

## Contact

- **Support** : support@cliceat.cm
- **Site web** : https://cliceat.cm
