# 🍔 ClicEat Mobile Application

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%5E3.10.8-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%5E3.0.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-Min%20SDK%2021-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-Min%2012.0-000000?style=for-the-badge&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)

**ClicEat — Plateforme de commande et livraison de repas au Cameroun (Douala & Yaoundé).**

[![Google Play](https://img.shields.io/badge/Google_Play-Available-green?style=flat-square&logo=google-play)](https://play.google.com/store/apps/details?id=cm.cliceat.app)
[![App Store](https://img.shields.io/badge/App_Store-Available-blue?style=flat-square&logo=app-store)](https://apps.apple.com/app/cliceat/idXXXXXXXXX)
[![Bugs](https://img.shields.io/badge/Reporter_un_Bug-Jira-blue?style=flat-square)](https://jira.cliceat.cm)

</div>

---

## 📋 Table des matières

1. [Aperçu de l'application](#-aperçu-de-lapplication)
2. [Architecture & Vue d'ensemble](#-architecture--vue-densemble)
3. [Dépendances & Packages](#-dépendances--packages)
4. [Prérequis](#-prérequis)
5. [Configuration de l'environnement](#-configuration-de-lenvironnement)
6. [Installation & Lancement](#-installation--lancement)
7. [Intégration API](#-intégration-api)
8. [Tests](#-tests)
9. [Design System & Assets](#-design-system--assets)
10. [Sécurité Mobile](#-sécurité-mobile)
11. [Performance & Optimisation](#-performance--optimisation)
12. [Contribution](#-contribution)
13. [Débogage & Problèmes Connus](#-débogage--problèmes-connus)
14. [License & Crédits](#-license--crédits)

---

## 📱 Aperçu de l'application

**ClicEat** est l'application mobile leader de livraison de repas au Cameroun. Elle connecte les clients, les restaurants partenaires et les livreurs en temps réel. L'application offre une expérience fluide, de la recherche de plats au suivi en direct de la commande, en passant par le paiement sécurisé via mobile money (NotchPay).

### ✨ Fonctionnalités principales
- **Navigation Géolocalisée :** Recherche de restaurants à proximité via Mapbox.
- **Menu & Panier :** Personnalisation des repas et gestion du panier avec persistance locale hors-ligne.
- **Paiements Mobiles :** Intégration de NotchPay pour MTN Mobile Money, Orange Money, et Cartes Bancaires.
- **Suivi en temps réel :** Tracking GPS en direct du livreur via WebSocket.
- **Programme de parrainage (Referral) :** Système de récompenses.
- **Portefeuille intégré (Wallet) :** Gestion des fonds et remboursements.

### 📲 Plateformes supportées
- **Android :** Version minimale SDK 21 (Lollipop, Android 5.0). Optimisé pour Android 14.
- **iOS :** Version minimale iOS 12.0. Optimisé pour iOS 17+.

### 📸 Captures d'écran

| Accueil | Menu Restaurant | Panier | Suivi Commande |
| :---: | :---: | :---: | :---: |
| <img src="docs/assets/screenshots/home.png" width="200"/> | <img src="docs/assets/screenshots/menu.png" width="200"/> | <img src="docs/assets/screenshots/cart.png" width="200"/> | <img src="docs/assets/screenshots/tracking.png" width="200"/> |

*(Note: Ajoutez vos captures dans `docs/assets/screenshots/`)*

---

## 🏗️ Architecture & Vue d'ensemble

L'application repose sur la **Clean Architecture** couplée au pattern de gestion d'état **BLoC / Cubit**. Ce choix asure une séparation claire des préoccupations, facilite les tests unitaires et garantit une grande scalabilité.

### 🛠️ Stack Technique
- **Framework :** Flutter (SDK `^3.10.8`)
- **Langage :** Dart
- **State Management :** `flutter_bloc`
- **Injection de Dépendances (DI) :** `get_it` + `injectable`
- **Networking :** `chopper` (Génération d'API REST robuste)
- **Base de données Locale :** `drift` (SQLite réactif et typesafe) + `shared_preferences`

### 🗺️ Schéma d'Architecture

```text
UI (Widgets / Pages)
       ↓ (Events)
State Management (BLoCs / Cubits)  ←→ Local Storage (Drift / Secure Storage)
       ↓ (State)
Domain (UseCases / Entities)
       ↓
Data Repositories
       ↓
Services (Network / Chopper / WebSockets / Mapbox)  ←→ API Externe
```

### 📂 Arborescence du Projet

L'architecture est découpée par fonctionnalités (*Feature-Driven*) :

```text
lib/
├── core/                   # Logique partagée dans toute l'application
│   ├── config/             # Injection d'environnement (env_config.dart), Saveurs (Flavors)
│   ├── data/               # Configuration de Drift
│   ├── di/                 # Configuration Injectable (Dependency Injection)
│   ├── errors/             # Exceptions et Failure models
│   ├── network/            # Clients HTTP Chopper, Intercepteurs (Token, Logging)
│   ├── services/           # Services techniques (Websocket, Analytics, Push, Location)
│   ├── theme/              # Couleurs, Typographie, Thème clair/sombre
│   ├── utils/              # Extensions, Formatters, Helpers
│   └── widgets/            # Composants UI réutilisables (Boutons, Inputs, Dialogs)
├── features/               # Modules fonctionnels indépendants
│   ├── auth/               # Authentification (Login, Register, OTP)
│   ├── cart/               # Gestion du panier
│   ├── client/             # Interface principale client
│   ├── delivery/           # Interface livreur (Dashboard, Maps)
│   ├── home/               # Page d'accueil client
│   ├── profile/            # Profil utilisateur, adresses
│   ├── restaurant/         # Détail d'un restaurant et menus
│   └── wallet/             # Portefeuille et transactions
└── main_*.dart             # Points d'entrée (dev, staging, prod)
```

Chaque feature (`lib/features/...`) possède ses propres sous-dossiers :
- `presentation/` : UI (Pages, Widgets) + State (`bloc`/`cubit`).
- `domain/` : Entités métier (Models) et cas d'usage (`usecases`).
- `data/` : Implémentations des Repositories, Data Sources.

---

## 📦 Dépendances & Packages

Toutes les dépendances sont strictement gérées dans le fichier `pubspec.yaml`.

### 🚀 Production

| Package | Version | Rôle / Utilisation | Lien |
|---------|---------|--------------------|------|
| **flutter_bloc** | `^9.1.1` | Pattern de gestion d'état principal | [pub.dev](https://pub.dev/packages/flutter_bloc) |
| **get_it** / **injectable** | `^9.2.1` / `^2.7.1` | Injection de dépendances avec génération de code | [pub.dev](https://pub.dev/packages/get_it) |
| **chopper** | `^8.5.0` | Client REST API généré (similaire à Retrofit) | [pub.dev](https://pub.dev/packages/chopper) |
| **freezed_annotation** | `^3.1.0` | Création de classes immuables / Data classes fortes | [pub.dev](https://pub.dev/packages/freezed) |
| **drift** | `^2.32.0` | Base de données locale SQLite type-safe | [pub.dev](https://pub.dev/packages/drift) |
| **mapbox_maps_flutter**| `^2.19.1` | Affichage des cartes et suivi de livraison | [pub.dev](https://pub.dev/packages/mapbox_maps_flutter) |
| **firebase_core/messaging** | `^4.5.0` | Push notifications et Analytiques | [pub.dev](https://pub.dev/packages/firebase_core) |
| **socket_io_client** | `^3.1.4` | Tracking en temps réel des livreurs au client | [pub.dev](https://pub.dev/packages/socket_io_client) |
| **flutter_secure_storage** | `^10.0.0` | Stockage sécurisé (Keychain / Keystore) des Tokens | [pub.dev](https://pub.dev/packages/flutter_secure_storage) |
| **http_certificate_pinning**| `^3.0.1` | Sécurité native SHA-256 contre les attaques MITM | [pub.dev](https://pub.dev/packages/http_certificate_pinning) |

### 🛠️ Dev Dependencies (Build Runner)

| Package | Version | Rôle / Utilisation |
|---------|---------|--------------------|
| **build_runner** | `^2.12.2` | Exécution des générateurs de code |
| **chopper_generator** | `^8.6.0` | Générateur de requêtes pour notre client API Chopper |
| **freezed** / **json_serializable** | `^3.2.5` | Parsing JSON, génération des `copyWith` et unions |
| **drift_dev** | `^2.32.0` | Génération du mapping de base de données locale |
| **injectable_generator** | `^2.12.1` | Génération de l'arbre d'injection GetIt |

---

## 📋 Prérequis

Pour compiler ce projet, votre environnement de développement doit inclure :

- **Flutter SDK :** `^3.10.8` *(Utiliser [FVM - Flutter Version Management](https://fvm.app/) est recommandé pour bloquer la version).*
- **Dart SDK :** Inclus avec Flutter.
- **Android Studio :** Flamingo ou ultérieur (avec SDK v34 et JDK 17).
- **Xcode :** Version 15.0 ou supérieure (pour la compilation iOS).
- **CocoaPods :** Version `1.14.0` ou supérieure.
- **Accès API Externe :** Clé Mapbox (Obligatoire pour l'UI de la carte) et NotchPay.

---

## ⚙️ Configuration de l'environnement

L'application ClicEat utilise une compilation **sécurisée** (Compile-Time Environment Variables). Aucune clé n'est hardcodée dans le code source.

Nous utilisons `String.fromEnvironment()` (dans `lib/core/config/env_config.dart`) qui est alimenté nativement au démarrage via la commande Flutter `--dart-define-from-file`.

### Étape 1 : Fichiers d'environnement
À la racine de votre projet, dupliquez le fichier d'exemple :
```bash
cp .env.example .env
```
*(Le fichier `.env` est ignoré par Git pour des raisons de sécurité).*

Ouvrez `.env` et définissez vos variables locales :
```properties
APP_ENV=dev
API_BASE_URL=https://dev-api.cliceat.cm/api/v1
MAPBOX_ACCESS_TOKEN=pk.VOTRE_CLE_PUB_MAPBOX_ICI
WS_URL=wss://dev-api.cliceat.cm
NOTCHPAY_PUBLIC_KEY=pk.VOTRE_CLE_NOTCHPAY
SSL_FINGERPRINT=...
```

**⚠️ Attention :** L'application crashera à l'ouverture de la carte si la clé `MAPBOX_ACCESS_TOKEN` est manquante, car le SDK natif l'exige au lancement.

### Étape 2 : Fichiers de Configuration Tiers
Ces fichiers ne sont pas commités. Vous devez les obtenir de la console (Firebase/NotchPay) :
- **Android:** Placez `google-services.json` dans `android/app/`.
- **iOS:** Placez `GoogleService-Info.plist` dans `ios/Runner/`.

### Configuration natif (*App ID & Permissions*) :
- **Android (`build.gradle`) :** L'applicationId est `cm.cliceat.app`. Les permissions de géolocalisation (`ACCESS_FINE_LOCATION`) sont demandées dans l'App Manifest.
- **iOS (`Info.plist`) :** Le Bundle Identifier est `cm.cliceat.app`. L'autorisation GPS est demandée via `NSLocationWhenInUseUsageDescription`.

---

## 🚀 Installation & Lancement

Les instructions suivantes garantissent l'injection correcte des variables d'environnement dans le code Dart.

### 8a. Premier lancement (Setup)

1. **Récupérez les paquets :**
   ```bash
   flutter clean
   flutter pub get
   ```
2. **Générez le code (`freezed`, `drift`, `chopper`, `injectable`) :**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   *Note : Cette commande peut prendre entre 1 et 3 minutes sur les grosses machines.*
3. **Installez les dépendances natives iOS (Mac uniquement) :**
   ```bash
   cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
   ```

### 8b. Développement Local (DEV)

Pour lancer l'application en mode développement en injectant les variables contenues dans `.env` :

- **Via la ligne de commande :**
  ```bash
  flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=.env
  ```
- **Configuration VS Code (`launch.json`) :**
  Si vous développez avec VS Code, créez un fichier `.vscode/launch.json` :
  ```json
  {
      "version": "0.2.0",
      "configurations": [
          {
              "name": "ClicEat (Dev)",
              "request": "launch",
              "type": "dart",
              "program": "lib/main_dev.dart",
              "args": [
                  "--flavor",
                  "dev"
              ],
              "toolArgs": [
                  "--dart-define-from-file",
                  ".env"
              ]
          }
      ]
  }
  ```

### 8c. Mode Staging (Déploiement QA)

Pour la recette (Quality Assurance), utiliser la cible de staging (avec un potentiel fichier `.env.staging`) :

```bash
flutter build apk -t lib/main_staging.dart --flavor staging --dart-define-from-file=.env.staging
```
*(Utilisez `flutter run` au lieu de `flutter build` pour le tester en live sur votre émulateur).*

### 8d. Build Production — Android

La publication Google Play exige :
1. Un fichier `key.properties` dans le dossier `android/` avec votre configuration *Keystore* :
   ```properties
   storePassword=MOT_DE_PASSE_KEYSTORE
   keyPassword=MOT_DE_PASSE_KEY
   keyAlias=cliceat
   storeFile=../cliceat_keystore.jks
   ```
2. Compiler un **Android App Bundle (.aab)** avec obfuscation du code :
   ```bash
   flutter build appbundle -t lib/main_prod.dart --flavor prod --dart-define-from-file=.env.prod --obfuscate --split-debug-info=./build/app/outputs/symbols
   ```

### 8e. Build Production — iOS

La publication App Store exige :
1. De configurer les certificats de distribution de votre compte Développeur Apple via *Xcode*.
2. Exécuter un **Build IPA** avec obfuscation :
   ```bash
   flutter build ipa -t lib/main_prod.dart --flavor prod --dart-define-from-file=.env.prod --obfuscate --split-debug-info=./build/ios/symbols
   ```
3. Uploadez le fichier généré sur Transporter ou utilisez la fenêtre *Organizer* de Xcode.

---

## 🔗 Intégration API

L'application communique avec le backend Node.js ClicEat. Les appels HTTP sont gérés par le package **Chopper**.

- **Génération / Mapping :** Chaque service API dans `lib/core/network/services/` (ex: `user_service.dart`) définit ses headers. `build_runner` crée ensuite le fichier caché `.chopper.dart` rattaché.
- **Authentification & Intercepteurs :** Nous utilisons un `HeaderInterceptor` global (`lib/core/network/interceptors/`) qui vérifie l'état de l'utilisateur. Si connecté, le Token Bearer JWT est lu depuis `flutter_secure_storage` et injecté silencieusement, avec logiques automatiques de déconnexion si 401.
- **WebSocket (Live Tracking) :** Une fois le Token JWT valide, le service WebSocket se connecte à `WS_URL` via `socket_io_client`.

---

## 🧪 Tests

Nous mettons l'accent sur les tests unitaires (*Cubit / Bloc / Repositories*).

- **Exécuter les tests locaux :**
  ```bash
  flutter test
  ```
- **Vérifier la couverture (Coverage) :**
  ```bash
  flutter test --coverage
  ```
  Ouvrez ensuite le rapport dans un explorateur web. Nous visons à maintenir une couverture d'au moins **70%** sur la couche `domain/` et les états de l'application.
- **Mocking :** Le package `mocktail` est utilisé pour simuler (*stubber*) les appels Chopper afin d'isoler l'interface de la couche réseau externe.

---

## 🎨 Design System & Assets

- **Polices et Typographie :** Piloté globalement par `Google Fonts` dans le fichier Theming (`lib/core/theme/`).
- **Icons :** FontAwesome et Cupertino Icons.
- **Images distantes :** Les photos des plats passent par `cached_network_image`. En attendant leur chargement, un `flutter_blurhash` (préchargement léger flouté transféré du backend) garantit un visuel premium.
- **Splash Screen / App Icon :**
  Automatiquement gérés selon les standards des OS via les libs Flutter natives :
  ```bash
  dart run flutter_native_splash:create
  dart run flutter_launcher_icons
  ```

---

## 🔒 Sécurité Mobile

Application déployée pour une fintech alimentaire, la sécurité est de rigueur :

1. **Variables Isolées :** `.env` stocké strictement hors du contrôle de version. Injection via compilation (Jamais hardcodée dans une constante).
2. **Stockage Chiffré :** SharedPreferences n'est utilisé que pour les préférences UI. JWT, Tokens Refresh sont hébergés sur le **KeyChain/KeyStore natif** via `flutter_secure_storage`.
3. **Certificate Pinning (SHA-256) :** Nativement branché via `http_certificate_pinning` pour empêcher la substitution de requêtes SSL (Man-in-the-Middle).
4. **Log Bridé :** En `--flavor prod`, le logger intégré (`package:logger`) bascule en mode furtif, s'assurant qu'aucune donnée de livraison ou de Mobile Money ne transparaisse dans les logs systèmes.

---

## 📊 Performance & Optimisation

- Tous les Widgets d'UI statique doivent être définis en `const` pour éviter les redessins de frame inutiles.
- **Génération de Taille (DevTools) :**
  Si vous intégrez une grosse bibliothèque, vérifiez l'impact système :
  ```bash
  flutter build apk --analyze-size --flavor prod --dart-define-from-file=.env.prod
  ```

---

## 🤝 Contribution

Nous suivons le format **Git Flow** couplé aux conventions classiques *(Conventional Commits)* :

1. **Branches :**
   - `feat/nom-ticket` : Nouvelles fonctionnalités.
   - `fix/nom-ticket` : Corrections de bugs.
2. **Commits (exemples) :**
   - `feat(cart): add offline local storage drift feature`
   - `fix(auth): fix token renewal interceptor loop`
3. **Review :** PR requise. Aucune erreur d'analyse statique (`flutter analyze` sans warning) avant approbation du merge.

---

## 🐛 Débogage & Problèmes Connus

- **Erreur `Unterminated string literal` ou conflits de build_runner :**
  Des erreurs de syntaxe dans vos modèles `freezed` peuvent crasher le générateur au milieu. Nettoyez le cache :
  ```bash
  flutter clean
  flutter pub get
  dart run build_runner clean
  dart run build_runner build --delete-conflicting-outputs
  ```
- **Écran Noir ou Crash Mapbox (Log Android `InvalidAccessToken`) :**
  Vérifiez que `--dart-define-from-file=.env` est bien passé à `flutter run`, et que votre variable `.env` `MAPBOX_ACCESS_TOKEN` est valide.
- **Problème de Dépendances iOS XCode :**
  Le dossier build iOS peut se bloquer après une mise à jour mineure de Flutter.
  ```bash
  cd ios
  rm -rf Pods Podfile.lock build
  pod install --repo-update
  ```

---

## 📄 License & Crédits

- **License :** Copyright © 2026 ClicEat Cameroon. Projet propriétaire pour la gestion de livraisons. Reproduction non autorisée.
- **Dépendances Open Source :** L'application intègre des bibliothèques externes ; leurs mentions légales respectives sont disponibles intégrées au logiciel (menu Paramètres > Mentions) via la page native `LicensePage()`.
