plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

android {
    namespace = "com.tbg.cliceat"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.tbg.cliceat"
        // Explicit SDK versions for auditability
        minSdk = flutter.minSdkVersion                            // Android 6.0 (flutter_secure_storage requirement)
        targetSdk = 35     // Mandatory for Play Store (Aug 2024)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions.add("environment")
    productFlavors {
        create("dev") {
            dimension = "environment"
            // applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("staging") {
            dimension = "environment"
            // applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
        }
        create("prod") {
            dimension = "environment"
            // No suffix for production
        }
    }

    signingConfigs {
        // Release signing — keys loaded from android/key.properties (gitignored).
        // Create key.properties with: storeFile, storePassword, keyAlias, keyPassword.
        // Run: keytool -genkey -v -keystore cliceat-release.jks -alias cliceat -keyalg RSA
        val keyPropsFile = rootProject.file("key.properties")
        if (keyPropsFile.exists()) {
            create("release") {
                val props = Properties()
                props.load(keyPropsFile.inputStream())
                keyAlias = props["keyAlias"] as String
                keyPassword = props["keyPassword"] as String
                storeFile = file(props["storeFile"] as String)
                storePassword = props["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            val keyPropsFile = rootProject.file("key.properties")
            if (keyPropsFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
