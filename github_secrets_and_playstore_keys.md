# Guide Complet en Français : Configuration Mobile CI/CD depuis Windows

Ce guide détaille la procédure complète pour configurer vos secrets GitHub de déploiement (Android et iOS) depuis un PC sous Windows, y compris la génération des clés Apple sans Mac et le rétablissement d'une clé d'importation Google Play perdue.

---

## Partie 1 : Référence des Secrets GitHub et Commandes d'Encodage

Pour configurer vos pipelines, accédez à votre dépôt GitHub -> **Settings > Secrets and variables > Actions > New repository secret**.

Pour encoder vos fichiers sous Windows, utilisez la console **Git Bash** (installée par défaut avec Git) qui prend en charge les outils standards comme `base64` et `openssl`.

### 1. Secrets Communs & Staging

| Nom du Secret | Description / Origine | Commande Git Bash pour encoder en base64 |
| :--- | :--- | :--- |
| **`FIREBASE_OPTIONS_DART`** | Fichier de configuration `lib/firebase_options.dart`. | `base64 -w 0 lib/firebase_options.dart` |
| **`ENV_STAGING_BASE64`** | Contenu du fichier d'environnement staging `.env.staging`. | `base64 -w 0 .env.staging` |
| **`ENV_PROD_BASE64`** | Contenu du fichier d'environnement de production `.env.prod`. | `base64 -w 0 .env.prod` |
| **`FIREBASE_SERVICE_ACCOUNT`** | Clé JSON du compte de service Firebase. Obtenez-la dans : *Console Firebase -> Paramètres du projet -> Comptes de service -> Générer une clé*. | **Pas d'encodage.** Copiez/collez directement le texte JSON brut du fichier téléchargé. |
| **`SLACK_WEBHOOK_URL`** | *(Optionnel)* URL de Webhook pour notifications Slack. | **Pas d'encodage.** Collez l'URL brute (`https://hooks.slack.com/...`). |

### 2. Secrets Android

| Nom du Secret | Description / Origine | Commande Git Bash pour encoder |
| :--- | :--- | :--- |
| **`ANDROID_KEYSTORE_BASE64`** | Fichier keystore binaire `cliceat-release.keystore`. | `base64 -w 0 android/app/cliceat-release.keystore` |
| **`ANDROID_KEYSTORE_PASSWORD`** | Mot de passe de stockage keystore. | **Pas d'encodage.** Collez `cliceat2026` |
| **`ANDROID_KEY_ALIAS`** | Alias de la clé de signature. | **Pas d'encodage.** Collez `cliceat` |
| **`ANDROID_KEY_PASSWORD`** | Mot de passe de la clé. | **Pas d'encodage.** Collez `cliceat2026` |
| **`FIREBASE_ANDROID_APP_ID`** | Identifiant de l'application Android dans Firebase. | **Pas d'encodage.** Exemple : `1:224830319268:android:2197269aa3124b00c99431` |
| **`GOOGLE_PLAY_SERVICE_ACCOUNT`** | Clé JSON du compte de service de la Console Google Play. | **Pas d'encodage.** Copiez/collez directement le texte JSON brut. |

### 3. Secrets iOS (Apple)

| Nom du Secret | Description / Origine | Commande Git Bash pour encoder |
| :--- | :--- | :--- |
| **`IOS_CERTIFICATE_P12`** | Le certificat de distribution converti au format `.p12` (voir Partie 3 pour l'obtenir sur Windows). | `base64 -w 0 ios_distribution.p12` |
| **`IOS_CERTIFICATE_PASSWORD`** | Le mot de passe associé au fichier `.p12` lors de sa création. | **Pas d'encodage.** Collez le mot de passe choisi. |
| **`IOS_PROVISIONING_PROFILE_STAGING`** | Profil de provisionnement Ad-Hoc staging (`.mobileprovision`). | `base64 -w 0 profil_staging.mobileprovision` |
| **`IOS_PROVISIONING_PROFILE_PRODUCTION`** | Profil de provisionnement App Store production (`.mobileprovision`). | `base64 -w 0 profil_prod.mobileprovision` |
| **`FIREBASE_IOS_APP_ID`** | Identifiant de l'application iOS dans Firebase. | **Pas d'encodage.** Exemple : `1:224830319268:ios:461cb28be9312ea2c99431` |
| **`ASC_ISSUER_ID`** | Issuer ID de l'API App Store Connect. | **Pas d'encodage.** Copiez-le depuis la console App Store Connect. |
| **`ASC_KEY_ID`** | Key ID de l'API App Store Connect. | **Pas d'encodage.** Copiez-le depuis la console App Store Connect. |
| **`ASC_PRIVATE_KEY`** | Clé privée API App Store Connect (fichier `.p8`). | **Pas d'encodage.** Ouvrez le fichier `.p8` et collez-en l'intégralité (les balises incluses). |

---

## Partie 2 : Récupération de la Clé d'Importation Perdue (Google Play)

Si vous avez perdu le fichier keystore binaire d'origine, suivez cette procédure pour le réinitialiser auprès de Google :

### Étape 1 : Générer un nouveau fichier Keystore sous Windows (Git Bash)
```bash
keytool -genkeypair -v \
  -keystore cliceat-release.keystore \
  -alias cliceat \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass cliceat2026 \
  -keypass cliceat2026 \
  -dname "CN=ClicEat, OU=Mobile, O=TBG, L=Yaounde, S=Center, C=CM"
```

### Étape 2 : Exporter le certificat public au format PEM
```bash
keytool -export -rfc \
  -alias cliceat \
  -file upload_certificate.pem \
  -keystore cliceat-release.keystore \
  -storepass cliceat2026
```
Cela produit un fichier `upload_certificate.pem`.

### Étape 3 : Soumettre le certificat public à Google
1. Allez sur la [Console Google Play](https://play.google.com/console).
2. Choisissez votre application (**ClicEat**).
3. Dans le menu de gauche : **Configuration** > **Intégrité de l'application** > Onglet **Signature de l'application**.
4. Faites défiler jusqu'à la section **Clé d'importation** et cliquez sur **Demander la réinitialisation de la clé d'importation**, puis téléversez `upload_certificate.pem`.
5. *Alternative (si bouton manquant)* : Envoyez le fichier via le [Formulaire de support pour clés Google Play](https://support.google.com/googleplay/android-developer/contact/key) en sélectionnant *"J'ai un problème lié à ma clé d'importation"*.

Le traitement prend entre 12 et 24 heures. Vous recevrez un e-mail confirmant l'activation de la nouvelle clé d'importation. Il vous suffira ensuite d'encoder `cliceat-release.keystore` en base64 pour mettre à jour le secret `ANDROID_KEYSTORE_BASE64` sur GitHub.

---

## Partie 3 : Comment obtenir les clés Apple depuis Windows (Sans Mac)

La génération de certificats Apple nécessite habituellement Xcode ou l'application Trousseau d'accès sur Mac. Cependant, vous pouvez tout faire sur Windows en utilisant **OpenSSL** (intégré à Git Bash) et votre navigateur internet.

### 1. Obtenir les identifiants d'API App Store Connect (`ASC_ISSUER_ID`, `ASC_KEY_ID`, `ASC_PRIVATE_KEY`)
1. Connectez-vous sur [App Store Connect](https://appstoreconnect.apple.com/).
2. Allez dans **Utilisateurs et accès** > Onglet **Intégrations** > **Clés** (Keys).
3. Cliquez sur le bouton **+** pour ajouter une clé.
4. Donnez-lui un nom (ex: `GitHub Actions CI`) et sélectionnez le rôle **Administrateur** (Admin).
5. Cliquez sur **Générer**.
6. Copiez l'**ID de l'émetteur** (Issuer ID) -> Secret **`ASC_ISSUER_ID`**.
7. Copiez l'**ID de clé** (Key ID) -> Secret **`ASC_KEY_ID`**.
8. Cliquez sur **Télécharger la clé API** (bouton visible une seule fois) pour télécharger le fichier `.p8`.
9. Ouvrez le fichier `.p8` avec un éditeur de texte (Notepad) et copiez l'intégralité du texte -> Secret **`ASC_PRIVATE_KEY`**.

### 2. Générer le Certificat de Distribution iOS (`IOS_CERTIFICATE_P12`)
Sur Windows, nous allons simuler le comportement du trousseau d'accès Apple avec OpenSSL.

#### Étape A : Créer la clé privée locale et la demande de certificat (CSR)
Ouvrez **Git Bash** et lancez les commandes suivantes :

```bash
# 1. Générer une clé privée RSA 2048 bits
openssl genrsa -out ios_distribution.key 2048

# 2. Générer la demande de signature (CSR)
# Note : Sous Git Bash (Windows), l'utilisation du paramètre -subj "/..." provoque une erreur 
# de conversion de chemin d'accès ("req: subject name is expected to be in the format..."). 
# Pour éviter cela, lancez la commande en mode interactif. OpenSSL vous posera les questions une par une dans le terminal :
openssl req -new -key ios_distribution.key -out CertificateSigningRequest.certSigningRequest
```
Cela produit les fichiers `ios_distribution.key` (votre clé privée) et `CertificateSigningRequest.certSigningRequest` (le fichier de demande).

#### Étape B : Demander le certificat sur le portail Apple Developer
1. Allez sur le portail [Apple Developer](https://developer.apple.com/account).
2. Accédez à **Certificates, Identifiers & Profiles**.
3. Dans la section **Certificates**, cliquez sur le bouton **+**.
4. Cochez **Apple Distribution** (ou iOS Distribution) et cliquez sur **Continue**.
5. Téléversez le fichier `CertificateSigningRequest.certSigningRequest` généré à l'Étape A.
6. Cliquez sur **Generate**, puis téléchargez le fichier généré par Apple (`distribution.cer`).

#### Étape C : Créer le fichier d'échange binaire `.p12`
Placez le fichier `distribution.cer` téléchargé dans le même dossier que votre fichier `ios_distribution.key` créé à l'Étape A, puis lancez dans **Git Bash** :

```bash
# 1. Convertir le certificat d'Apple en format PEM textuel
openssl x509 -in distribution.cer -inform DER -out distribution.pem -outform PEM

# 2. Associer votre clé privée d'origine et le certificat PEM dans un fichier d'échange .p12
openssl pkcs12 -export -out ios_distribution.p12 -inkey ios_distribution.key -in distribution.pem \
  -passout pass:MotDePasseDeVotreChoix
```

* Le mot de passe que vous mettez à la place de `MotDePasseDeVotreChoix` sera votre secret **`IOS_CERTIFICATE_PASSWORD`** sur GitHub.
* Le fichier généré `ios_distribution.p12` est votre certificat iOS signé. Encodez-le en base64 pour obtenir votre secret **`IOS_CERTIFICATE_P12`** :
  ```bash
  base64 -w 0 ios_distribution.p12
  ```

---

### 3. Obtenir les Profils de Provisionnement (`IOS_PROVISIONING_PROFILE_STAGING` & `PRODUCTION`)
Ces fichiers font le lien entre votre application, votre certificat de distribution et vos appareils de test autorisés.

#### Étape A : Déclarer l'App ID (Bundle ID)
*Si ce n'est pas déjà fait :*
1. Sur le portail Apple Developer, allez dans **Identifiers** (Identifiants).
2. Cliquez sur **+**, sélectionnez **App IDs** et saisissez la description et le Bundle ID (ex: `com.tbg.cliceat`).
3. Cochez les capacités nécessaires (ex: Push Notifications) et enregistrez.

#### Étape B : Enregistrer les appareils de test (Uniquement pour le profil Staging Ad-Hoc)
*Le profil de production pour l'App Store ne nécessite pas d'appareils de test, mais le profil de staging (Ad-Hoc) en a besoin pour autoriser l'installation sur les téléphones des testeurs via Firebase.*
1. Allez sur la section **Devices** (Appareils) du portail Apple Developer.
2. Cliquez sur **+** et ajoutez les identifiants UDID des iPhones de vos testeurs.

##### Comment trouver l'UDID de son iPhone sous Windows :

Voici les trois méthodes les plus simples pour récupérer l'UDID depuis Windows :

* **Méthode 1 : Directement depuis l'iPhone avec Safari (La plus rapide)**
  1. Ouvrez **Safari** sur votre iPhone et accédez à [https://showmyudid.com](https://showmyudid.com).
  2. Appuyez sur **"Tap to show UDID"** et acceptez le téléchargement du profil temporaire.
  3. Allez dans les **Réglages** de l'iPhone, ouvrez **Profil téléchargé** tout en haut, puis cliquez sur **Installer** (saisissez votre code).
  4. Le site affichera votre UDID complet. Copiez-le.

* **Méthode 2 : Via iTunes ou l'application "Appareils Apple" sur Windows**
  1. Connectez l'iPhone au PC par USB et lancez **iTunes** (ou l'application *Appareils Apple*).
  2. Cliquez sur l'icône de l'appareil pour afficher son résumé.
  3. Cliquez sur le texte **"Numéro de série"** (sous le nom de l'appareil) jusqu'à ce qu'il devienne **UDID**.
  4. Faites un clic droit et sélectionnez **Copier**.

* **Méthode 3 : Via le Gestionnaire de périphériques Windows (Sans installer de logiciel)**
  1. Connectez l'iPhone au PC.
  2. Faites un clic droit sur le bouton Démarrer de Windows et ouvrez le **Gestionnaire de périphériques**.
  3. Déroulez la section **Périphériques USB** (ou *Contrôleurs de bus USB*).
  4. Double-cliquez sur **Apple Mobile Device USB Device**.
  5. Allez dans l'onglet **Détails**, puis sélectionnez la propriété **Chemin d'accès à l'instance du périphérique**.
  6. La valeur affichée se termine par votre UDID après le dernier antislash `\` (ex: `00008030-00123456789ABCDE`). Si le tiret `-` après les 8 premiers chiffres est absent, rajoutez-le.

#### Étape C : Générer et Télécharger les fichiers `.mobileprovision`
1. Allez dans **Profiles** sur le portail Apple Developer.
2. Cliquez sur **+** pour créer un profil.
3. **Pour le Staging (Ad-Hoc)** :
   * Cochez **Ad Hoc** dans la catégorie *Distribution*, puis cliquez sur *Continue*.
   * Sélectionnez votre App ID (`com.tbg.cliceat`).
   * Sélectionnez le certificat de distribution généré au point précédent.
   * Cochez tous les appareils de test enregistrés.
   * Nommez le profil (ex: `ClicEat Staging AdHoc`) et cliquez sur *Generate*.
   * Téléchargez le fichier (ex: `ClicEat_Staging_AdHoc.mobileprovision`).
4. **Pour la Production (App Store)** :
   * Cochez **App Store** dans la catégorie *Distribution*, puis cliquez sur *Continue*.
   * Sélectionnez votre App ID (`com.tbg.cliceat`).
   * Sélectionnez le même certificat de distribution.
   * Nommez le profil (ex: `ClicEat Production AppStore`) et cliquez sur *Generate*.
   * Téléchargez le fichier (ex: `ClicEat_Production_AppStore.mobileprovision`).
5. Encodez-les en base64 dans **Git Bash** pour créer vos secrets GitHub :
   ```bash
   # Pour le secret IOS_PROVISIONING_PROFILE_STAGING
   base64 -w 0 ClicEat_Staging_AdHoc.mobileprovision
   
   # Pour le secret IOS_PROVISIONING_PROFILE_PRODUCTION
   base64 -w 0 ClicEat_Production_AppStore.mobileprovision
   ```
