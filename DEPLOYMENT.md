J'ai tous les éléments. Voici le document complet :

---

# 📋 GUIDE DE DÉPLOIEMENT EN PRODUCTION — ClicEat Mobile

> **Application** : ClicEat — Commande & Livraison (Cameroun)  
> **Stack** : Flutter 3.41.5 · Firebase · Mapbox · NotchPay · Socket.IO  
> **Package ID** : `cm.cliceat.app` (Android) · à corriger sur iOS (voir §5)  
> **Flavors** : `dev` · `staging` · `prod`

---

## TABLE DES MATIÈRES

1. [Prérequis & outils](#1-prérequis--outils)
2. [Secrets & fichiers sensibles](#2-secrets--fichiers-sensibles-ne-jamais-committer)
3. [Firebase — configuration complète](#3-firebase--configuration-complète)
4. [Mapbox — token de production](#4-mapbox--token-de-production)
5. [iOS — identité & signature](#5-ios--identité--signature)
6. [Android — clé de signature](#6-android--clé-de-signature)
7. [Deep Links & Universal Links](#7-deep-links--universal-links)
8. [Google Sign-In](#8-google-sign-in)
9. [Notifications push (FCM)](#9-notifications-push-fcm)
10. [Build de production](#10-build-de-production)
11. [Tests avant publication](#11-tests-avant-publication)
12. [Publication Google Play Store](#12-publication-google-play-store)
13. [Publication Apple App Store](#13-publication-apple-app-store)
14. [Post-déploiement & monitoring](#14-post-déploiement--monitoring)
15. [Checklist finale](#15-checklist-finale-ne-rien-publier-sans-cocher-chaque-case)

---

## 1. Prérequis & outils

### Sur ta machine de build

```bash
# Flutter stable
flutter --version   # doit afficher 3.41.5+
dart --version      # doit afficher 3.11.3+

# Android
java -version       # Java 17 requis (JavaVersion.VERSION_17 dans build.gradle.kts)
# Android SDK installé, ANDROID_HOME défini
flutter doctor      # tout doit être vert sauf ce que tu n'utilises pas

# iOS (Mac uniquement)
xcode-select --version  # Xcode 15+ recommandé
pod --version           # CocoaPods installé
```

### Comptes à avoir actifs

| Service | Pourquoi |
|---|---|
| Google Play Console | Publication Android |
| App Store Connect | Publication iOS |
| Firebase Console | FCM, Crashlytics, Analytics |
| Mapbox Dashboard | Token de prod |
| NotchPay Dashboard | Paiements en production |
| Apple Developer Program | Certificats, provisioning |

---

## 2. Secrets & fichiers sensibles (ne jamais committer)

Ces fichiers sont dans `.gitignore`. Tu dois les créer à la main sur chaque machine de build.

### 2.1 Fichier `.env` (racine du projet)

```bash
# À créer : /cliceat-mobile/.env
APP_ENV=prod
API_BASE_URL=https://api.cliceat.cm/api/v1
MAPBOX_ACCESS_TOKEN=pk.VOTRE_TOKEN_MAPBOX_PRODUCTION
WS_URL=wss://api.cliceat.cm
```

> ⚠️ Ce fichier est inclus dans le bundle Flutter (il est dans `assets:` du `pubspec.yaml`). En production, **le token Mapbox sera visible** dans l'APK/IPA si tu le mets ici. **Utilise `--dart-define` à la place** (voir §4).

### 2.2 `android/key.properties`

```properties
storeFile=../cliceat-release.jks
storePassword=MOT_DE_PASSE_DU_KEYSTORE
keyAlias=cliceat
keyPassword=MOT_DE_PASSE_DE_LA_CLÉ
```

> Le fichier `.jks` peut être n'importe où, l'important est que le chemin dans `storeFile` soit correct **relatif au dossier `android/`**.

### 2.3 `android/app/google-services.json`

Télécharger depuis Firebase Console → ton projet → Android → télécharger `google-services.json`.  
Le placer dans `android/app/google-services.json`.

### 2.4 `ios/Runner/GoogleService-Info.plist`

Télécharger depuis Firebase Console → ton projet → iOS → télécharger `GoogleService-Info.plist`.  
Le glisser dans Xcode dans le dossier `Runner/` (pas juste dans le système de fichiers).

---

## 3. Firebase — configuration complète

### 3.1 Créer les apps Firebase (si pas encore fait)

Dans Firebase Console → **Ajouter une application** :

**Android :**
- Package name : `cm.cliceat.app`
- Télécharger `google-services.json` → mettre dans `android/app/`

**iOS :**
- Bundle ID : `cm.cliceat.app` (⚠️ voir §5 — le bundle ID iOS doit d'abord être corrigé)
- Télécharger `GoogleService-Info.plist` → mettre dans `ios/Runner/`

### 3.2 Mettre à jour `lib/firebase_options.dart`

```bash
# Installer FlutterFire CLI si pas encore fait
dart pub global activate flutterfire_cli

# Configurer Firebase (régénère firebase_options.dart avec les vraies valeurs)
flutterfire configure \
  --project=TON_PROJECT_ID_FIREBASE \
  --platforms=android,ios
```

> Cela remplace le fichier `firebase_options.dart` existant avec les vraies clés Firebase. **Ne pas committer ce fichier si les clés sont sensibles** (elles le sont — ajoute-le au `.gitignore` ou utilise des secrets CI/CD).

### 3.3 Firebase Crashlytics — vérifier l'activation

Dans `lib/main_common.dart`, Crashlytics est activé hors debug :
```dart
if (!kDebugMode) {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
}
```
C'est déjà correct. Vérifie dans Firebase Console → Crashlytics que les rapports arrivent après le premier crash test.

### 3.4 SHA-1 & SHA-256 pour Android (Google Sign-In + App Links)

```bash
# Avec la clé de release
keytool -list -v \
  -keystore android/cliceat-release.jks \
  -alias cliceat \
  -storepass MOT_DE_PASSE

# Copier SHA-1 et SHA-256 → Firebase Console → Paramètres du projet → Android → Empreintes
```

> Sans le SHA-1 enregistré dans Firebase, **Google Sign-In ne fonctionnera pas** en production.

---

## 4. Mapbox — token de production

### 4.1 Token public (carte)

Dans le dashboard Mapbox, crée un token de production avec les scopes :
- `styles:read`
- `fonts:read`  
- `datasets:read`
- `vision:read` (si tu utilises la navigation)

Restreins-le à ton domaine/bundle ID si possible.

### 4.2 Passer le token au build (méthode recommandée)

Au lieu du `.env` (qui est bundlé dans l'APK), passe le token via `--dart-define` :

```bash
flutter build apk \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.TON_TOKEN_PROD \
  --release
```

> `main_prod.dart` lit déjà `const String.fromEnvironment('MAPBOX_ACCESS_TOKEN')` — c'est prêt.

### 4.3 Token secret (téléchargement des tuiles offline — si utilisé)

Si l'app télécharge des tuiles offline, un token secret est nécessaire côté serveur. Ne jamais l'inclure dans l'app mobile.

---

## 5. iOS — identité & signature

### 5.1 Corriger le Bundle ID iOS ⚠️ CRITIQUE

Le Bundle ID iOS est actuellement `com.example.cliceatApp` (valeur par défaut Flutter). Il **doit** être `cm.cliceat.app` pour correspondre à Android et à Firebase.

**Dans Xcode :**
1. Ouvrir `ios/Runner.xcworkspace` dans Xcode
2. Sélectionner le projet `Runner` → target `Runner`
3. Onglet `General` → `Bundle Identifier` → changer en `cm.cliceat.app`
4. Faire la même chose pour les targets `RunnerTests` si nécessaire

Ou directement dans le `.pbxproj` (remplacer toutes les occurrences de `com.example.cliceatApp` par `cm.cliceat.app`).

### 5.2 Configurer la signature automatique

Dans Xcode → target `Runner` → onglet `Signing & Capabilities` :
- `Automatically manage signing` : ✅ activé
- `Team` : sélectionner ton Apple Developer Team
- `Bundle Identifier` : `cm.cliceat.app`

### 5.3 Info.plist — REVERSED_CLIENT_ID (Google Sign-In)

Dans `ios/Runner/Info.plist`, il y a ce placeholder :
```xml
<string>REPLACE_WITH_REVERSED_CLIENT_ID</string>
```

Récupérer la vraie valeur :
1. Ouvrir `GoogleService-Info.plist`
2. Chercher la clé `REVERSED_CLIENT_ID` (ressemble à `com.googleusercontent.apps.XXXXXXXX-abcd`)
3. Remplacer `REPLACE_WITH_REVERSED_CLIENT_ID` dans `Info.plist`

> Sans ça, **Google Sign-In ne s'ouvrira pas** sur iOS — l'URL scheme ne sera pas reconnu.

### 5.4 Capabilities nécessaires

Dans `ios/Runner/Runner.entitlements`, ces capabilities sont déjà configurées :
- `aps-environment` = `production` ✅ (notifications push)
- `com.apple.developer.applesignin` ✅ (Sign In with Apple)
- `com.apple.developer.associated-domains` = `applinks:cliceat.cm` ✅ (Universal Links)

Vérifie qu'elles sont **bien activées** dans ton Apple Developer Account → Identifiers → `cm.cliceat.app` :
- ✅ Push Notifications
- ✅ Sign In with Apple
- ✅ Associated Domains

### 5.5 Provisioning Profile

```bash
# Nettoyer et regénérer
cd ios && pod install --repo-update && cd ..
```

Xcode gère automatiquement le provisioning profile si `Automatically manage signing` est activé (§5.2).

---

## 6. Android — clé de signature

### 6.1 Générer le keystore (une seule fois, à conserver précieusement)

```bash
keytool -genkey -v \
  -keystore android/cliceat-release.jks \
  -alias cliceat \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -dname "CN=ClicEat, OU=Mobile, O=ClicEat SAS, L=Douala, ST=Littoral, C=CM"
```

> ⚠️ **Ce fichier `.jks` est IRREMPLAÇABLE.** Si tu le perds, tu ne pourras plus mettre à jour l'app sur le Play Store. Sauvegarde-le dans un gestionnaire de mots de passe (1Password, Bitwarden) ET dans un stockage cloud chiffré.

### 6.2 Créer `android/key.properties`

```properties
storeFile=../cliceat-release.jks
storePassword=TON_MOT_DE_PASSE_STORE
keyAlias=cliceat
keyPassword=TON_MOT_DE_PASSE_CLÉ
```

> `build.gradle.kts` lit ce fichier automatiquement. S'il est absent, il utilise la clé debug (ne jamais publier avec la clé debug).

### 6.3 Vérifier la configuration ProGuard

`android/app/proguard-rules.pro` — vérifier que les règles couvrent :
- Chopper / Retrofit (keep des classes de réponse)
- Drift / SQLite
- Freezed
- Firebase Crashlytics (il ajoute ses règles automatiquement)
- Mapbox (il fournit les siennes)

Si des crashs apparaissent après minification avec un message `ClassNotFound` ou méthode manquante, c'est ProGuard qui a trop agressivement supprimé du code.

---

## 7. Deep Links & Universal Links

### 7.1 Android App Links — fichier `assetlinks.json`

Le manifest déclare `android:autoVerify="true"` pour `https://cliceat.cm`. Android va chercher automatiquement :

```
https://cliceat.cm/.well-known/assetlinks.json
```

Ce fichier doit être servi par ton serveur web. Son contenu :

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "cm.cliceat.app",
    "sha256_cert_fingerprints": [
      "AA:BB:CC:DD:..."
    ]
  }
}]
```

Récupérer le SHA-256 :
```bash
keytool -list -v -keystore android/cliceat-release.jks -alias cliceat | grep SHA256
```

> ⚠️ Si ce fichier n'est pas en place, les liens `https://cliceat.cm/...` n'ouvriront **pas** directement l'app — l'utilisateur aura une boîte de dialogue de choix.

### 7.2 iOS Universal Links — fichier `apple-app-site-association`

iOS cherche :
```
https://cliceat.cm/.well-known/apple-app-site-association
```

Contenu (à adapter aux routes de l'app) :
```json
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAMID.cm.cliceat.app",
      "paths": ["*"]
    }]
  }
}
```

Remplacer `TEAMID` par ton Apple Team ID (10 caractères, visible dans App Store Connect).

> Ce fichier doit être servi avec `Content-Type: application/json` et **sans redirection**. Apple le vérifie à l'installation de l'app.

---

## 8. Google Sign-In

### 8.1 Google Cloud Console

1. Aller sur [console.cloud.google.com](https://console.cloud.google.com)
2. Projet → APIs & Services → Identifiants
3. Créer un **ID client OAuth 2.0** de type "Application Android" :
   - Package : `cm.cliceat.app`
   - Empreinte SHA-1 du keystore de release (voir §3.4)
4. Créer un **ID client OAuth 2.0** de type "Application iOS" :
   - Bundle ID : `cm.cliceat.app`

> `GoogleSignIn.instance.authenticate()` (google_sign_in v7) utilise les credentials enregistrés dans Firebase/Google Cloud — les IDs OAuth doivent correspondre.

### 8.2 Vérification fonctionnelle

- Android : tester avec l'APK signé (le SHA-1 du keystore debug ≠ release, donc ça ne marchera qu'avec le bon APK)
- iOS : tester avec un TestFlight build

---

## 9. Notifications push (FCM)

### 9.1 Android

Firebase Messaging fonctionne automatiquement avec `google-services.json`. Pas d'action supplémentaire si le fichier est correct.

### 9.2 iOS — APNs (Apple Push Notification Service)

**Option A — Clé APNs (recommandé) :**
1. Apple Developer → Certificates → Keys → créer une clé avec "Apple Push Notifications service (APNs)"
2. Télécharger le fichier `.p8`
3. Dans Firebase Console → Paramètres du projet → Cloud Messaging → iOS app → téléverser la clé `.p8`
4. Renseigner le Key ID et le Team ID

**Option B — Certificat APNs (ancienne méthode) :**
- Crée un certificat Push (Development/Production) et téléverse le `.p12` dans Firebase.

> Dans `Runner.entitlements`, `aps-environment = production` est déjà configuré. Utilise la clé/certificat **Production** (pas Development) pour les builds App Store.

### 9.3 Test des notifications

```bash
# Récupérer le FCM token depuis l'app (loggué au démarrage en mode debug)
# Envoyer une notification de test depuis Firebase Console → Messaging
```

---

## 10. Build de production

### 10.1 Préparer l'environnement

```bash
# S'assurer que tout est propre
flutter clean
flutter pub get

# Régénérer les fichiers générés (si modifs depuis le dernier build)
dart run build_runner build --delete-conflicting-outputs
```

### 10.2 Build Android — APK ou AAB

```bash
# AAB (recommandé pour le Play Store — plus petit, Google fait le split)
flutter build appbundle \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.TON_TOKEN_PROD \
  --release

# APK split par ABI (si tu distribues l'APK directement)
flutter build apk \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.TON_TOKEN_PROD \
  --split-per-abi \
  --release
```

**Fichiers générés :**
- AAB : `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- APK : `build/app/outputs/apk/prod/release/app-prod-arm64-v8a-release.apk` (+ armeabi-v7a, x86_64)

### 10.3 Build iOS

```bash
# D'abord, installer les pods
cd ios && pod install --repo-update && cd ..

# Build iOS (nécessite macOS + Xcode)
flutter build ipa \
  --flavor prod \
  -t lib/main_prod.dart \
  --dart-define=MAPBOX_ACCESS_TOKEN=pk.TON_TOKEN_PROD \
  --release

# Fichier généré : build/ios/ipa/ClicEat.ipa
```

Ou ouvrir `ios/Runner.xcworkspace` dans Xcode → Product → Archive.

### 10.4 Vérifier le versionning

Dans `pubspec.yaml`, avant chaque release, incrémenter :
```yaml
version: 1.0.0+1
#         ↑ ↑
#         | buildNumber (versionCode Android / CFBundleVersion iOS)
#         versionName (versionName Android / CFBundleShortVersionString iOS)
```

> Le Play Store et l'App Store **refusent** un build avec un `versionCode` inférieur ou égal au précédent.

---

## 11. Tests avant publication

### 11.1 Tests automatisés

```bash
flutter test
```

### 11.2 flutter analyze — zéro erreur

```bash
flutter analyze --no-pub
# Doit afficher : "No issues found!" ou uniquement des warnings/infos
```

### 11.3 Checklist fonctionnelle manuelle

À tester sur un vrai appareil avec le **build release** (pas debug — le comportement peut différer) :

**Authentification :**
- [ ] Connexion email/mot de passe
- [ ] Google Sign-In (tester avec APK signé)
- [ ] Sign In with Apple (iOS uniquement)
- [ ] Déconnexion
- [ ] Session expirée → redirection vers login

**Carte & Géolocalisation :**
- [ ] La carte Mapbox s'affiche correctement (token valide)
- [ ] Les restaurants apparaissent sur la carte
- [ ] Clustering fonctionne (tap sur cluster → zoom)
- [ ] La géolocalisation de l'utilisateur fonctionne
- [ ] Permission localisation demandée correctement

**Commande :**
- [ ] Parcourir les restaurants
- [ ] Ajouter au panier (persistance locale Drift)
- [ ] Passer une commande
- [ ] Paiement NotchPay (WebView fonctionne)
- [ ] Suivi de commande en temps réel (WebSocket)

**Livraison (mode livreur) :**
- [ ] Voir les missions disponibles
- [ ] Accepter une mission
- [ ] GPS livreur actif en foreground
- [ ] Notification foreground active (ForegroundNotificationConfig)
- [ ] Partage de position en temps réel

**Notifications :**
- [ ] Notification reçue quand l'app est en foreground
- [ ] Notification reçue quand l'app est en background
- [ ] Tap sur notification → ouvre le bon écran (deep link)

**Deep Links :**
- [ ] `cliceat://...` ouvre l'app depuis un lien
- [ ] `https://cliceat.cm/...` ouvre l'app directement (sans boîte de dialogue)

**Hors ligne :**
- [ ] L'app ne crash pas si pas de réseau
- [ ] Le banner de connectivité s'affiche

**Sécurité :**
- [ ] Screenshots désactivés sur les écrans sensibles (SecureScreenMixin)
- [ ] Le token JWT est stocké dans FlutterSecureStorage (pas SharedPreferences)

---

## 12. Publication Google Play Store

### 12.1 Première publication

1. **Google Play Console** → Créer une application
2. Renseigner :
   - Nom : ClicEat
   - Langue par défaut : Français
   - Type : Application
   - Catégorie : Nourriture et boissons
3. **Fiche du Play Store** :
   - Description courte (80 caractères max)
   - Description longue (4000 caractères max)
   - Captures d'écran (au moins 2 pour chaque format requis)
   - Icône haute résolution 512×512 PNG
   - Image bannière 1024×500
4. **Évaluations du contenu** : remplir le questionnaire
5. **Politique de confidentialité** : lien obligatoire (héberger sur `cliceat.cm/privacy`)
6. **Distribution** : pays disponibles (Cameroun, etc.)

### 12.2 Téléverser l'AAB

Play Console → Production → Créer une nouvelle version → Téléverser l'AAB :
```
build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

### 12.3 Releases internes / Alpha / Beta avant production

```
Play Console → Test → Tests internes → Créer une version
```
Tester avec l'équipe avant de basculer en production.

### 12.4 Mise à jour

Incrémenter `versionCode` dans `pubspec.yaml` → rebuilder → téléverser le nouvel AAB.

---

## 13. Publication Apple App Store

### 13.1 App Store Connect — Créer l'app

1. App Store Connect → Mes apps → `+`
2. Renseigner :
   - Nom : ClicEat
   - Bundle ID : `cm.cliceat.app`
   - SKU : `cliceat-mobile`
3. **Fiche App Store** :
   - Description (4000 caractères max)
   - Captures d'écran (iPhone 6.9", 6.5", 5.5" — iPad si tu supportes)
   - Icône 1024×1024 PNG (sans coins arrondis — App Store les arrondit)
   - Mots-clés (100 caractères max)
4. **Informations de confidentialité** : déclarer les données collectées
5. **Évaluations** : classification par âge (obligatoire)

### 13.2 Téléverser l'IPA

Utiliser **Transporter** (macOS, gratuit sur l'App Store) ou Xcode :
```bash
xcrun altool --upload-app \
  --type ios \
  --file "build/ios/ipa/ClicEat.ipa" \
  --username "apple@cliceat.cm" \
  --password "@keychain:AC_PASSWORD"
```

Ou directement depuis Xcode → Product → Archive → Distribute App → App Store Connect.

### 13.3 TestFlight avant production

Après upload, le build apparaît dans TestFlight.  
Envoyer aux testeurs internes → valider → soumettre à la revue Apple.

### 13.4 Revue Apple — points d'attention

Apple est strict sur :
- **Sign In with Apple** : si tu as Google Sign-In, Sign In with Apple **est obligatoire** (déjà implémenté ✅)
- **Permissions** : chaque `NSUsageDescription` doit justifier l'usage (localisation, caméra, notifications)
- **Politique de confidentialité** : lien obligatoire et accessible depuis l'app
- **Paiements** : si des achats in-app existent, utiliser Apple IAP (les paiements NotchPay via WebView pour des services externes sont généralement acceptés)

### 13.5 Info.plist — ajouter les NSUsageDescription manquantes

Vérifier que ces clés sont présentes dans `ios/Runner/Info.plist` :
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>ClicEat utilise votre position pour afficher les restaurants proches et suivre votre livraison.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>ClicEat utilise votre position en arrière-plan pour le suivi en temps réel des livraisons.</string>

<key>NSCameraUsageDescription</key>
<string>ClicEat utilise votre caméra pour prendre une photo de confirmation de livraison.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>ClicEat accède à vos photos pour mettre à jour votre photo de profil.</string>
```

> Sans ces descriptions, Apple **rejettera** l'app immédiatement.

---

## 14. Post-déploiement & monitoring

### 14.1 Firebase Crashlytics

- Surveiller les crashs dans Firebase Console → Crashlytics
- Les crashs sont automatiquement remontés (déjà configuré dans `main_common.dart`)
- Mettre une alerte email pour les nouveaux crashs

### 14.2 Firebase Analytics

- Vérifier que les événements arrivent (connexion, commande, livraison)
- Firebase Console → Analytics → Temps réel → vérifier après le premier vrai utilisateur

### 14.3 Monitoring backend

- Surveiller l'API `https://api.cliceat.cm/api/v1`
- Les WebSockets `wss://api.cliceat.cm`
- Les erreurs réseau remontent dans Crashlytics via `runZonedGuarded`

### 14.4 Forcer une mise à jour (si besoin urgent)

L'app n'a pas de mécanisme de force-update visible. Si tu dois forcer une mise à jour (bug critique) :
- Côté serveur : retourner un code d'erreur spécifique (ex: `426 Upgrade Required`)
- L'intercepteur Chopper peut intercepter ce code et afficher une dialog de mise à jour

---

## 15. Checklist finale (ne rien publier sans cocher chaque case)

### Secrets & fichiers

- [ ] `.env` contient les vraies valeurs de production (`APP_ENV=prod`)
- [ ] `android/app/google-services.json` : fichier de production (pas de placeholder)
- [ ] `ios/Runner/GoogleService-Info.plist` : fichier de production
- [ ] `android/key.properties` : pointe vers le bon keystore
- [ ] `android/cliceat-release.jks` : keystore sauvegardé en lieu sûr
- [ ] `lib/firebase_options.dart` : généré avec les vraies clés Firebase (`flutterfire configure`)

### iOS — corrections obligatoires

- [ ] Bundle ID iOS changé de `com.example.cliceatApp` → `cm.cliceat.app` (§5.1)
- [ ] `REVERSED_CLIENT_ID` dans `Info.plist` remplacé par la vraie valeur (§5.3)
- [ ] `NSLocationWhenInUseUsageDescription` et autres descriptions dans `Info.plist` (§13.5)
- [ ] Capabilities activées dans Apple Developer : Push, Sign In with Apple, Associated Domains (§5.4)

### Android

- [ ] SHA-1 du keystore release enregistré dans Firebase Console (§3.4)
- [ ] `assetlinks.json` en ligne sur `https://cliceat.cm/.well-known/assetlinks.json` (§7.1)
- [ ] ProGuard ne casse rien (tester le build release sur un vrai appareil) (§6.3)

### iOS / Deep Links

- [ ] `apple-app-site-association` en ligne sur `https://cliceat.cm/.well-known/apple-app-site-association` (§7.2)

### Build

- [ ] `flutter analyze` → 0 erreur
- [ ] `flutter test` → tous les tests passent
- [ ] `version` incrémenté dans `pubspec.yaml`
- [ ] Build avec `--flavor prod -t lib/main_prod.dart` (pas avec le flavor dev ou staging)
- [ ] Token Mapbox de production passé via `--dart-define=MAPBOX_ACCESS_TOKEN=...`
- [ ] Testé sur vrai appareil physique (pas seulement émulateur)

### Fonctionnel

- [ ] Google Sign-In fonctionne (avec l'APK/IPA signé de production)
- [ ] Notifications push reçues (foreground + background)
- [ ] Paiement NotchPay fonctionne de bout en bout
- [ ] Carte Mapbox s'affiche (token valide)
- [ ] Deep links ouvrent l'app directement
- [ ] Pas de crash au démarrage froid

### Stores

- [ ] Politique de confidentialité en ligne et accessible
- [ ] Captures d'écran aux bonnes dimensions
- [ ] Description et métadonnées renseignées
- [ ] Classification par âge complétée
- [ ] Testé via TestFlight / Play Internal Testing avant release publique

---

> **En cas de problème après publication** : Ne pas mettre à jour à chaud sans tester. Passer par une release "patch" avec le correctif, incrementer le versionCode, et passer par le cycle normal de review (App Store) ou déploiement progressif (Play Store).