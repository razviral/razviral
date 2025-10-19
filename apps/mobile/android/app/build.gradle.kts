// ARCHIVO: apps/mobile/android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // --- DIRECTIVA DE FIRMA PARA PRODUCCIÓN ---
    // Para publicar en Google Play, debes crear una keystore y referenciarla aquí.
    // Consulta la documentación de Flutter sobre cómo firmar tu app.
    // https://docs.flutter.dev/deployment/android#signing-the-app
    signingConfigs {
        create("release") {
            // Se recomienda almacenar estas credenciales de forma segura
            // en el archivo 'key.properties' y no directamente en el código.
            // keyAlias = System.getenv("KEY_ALIAS")
            // keyPassword = System.getenv("KEY_PASSWORD")
            // storeFile = file(System.getenv("KEYSTORE_PATH"))
            // storePassword = System.getenv("STORE_PASSWORD")
        }
    }

    defaultConfig {
        // TODO: Especifica tu propio Application ID único.
        applicationId = "com.example.mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Le indica a Gradle que use la configuración de firma que definimos arriba.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

// --- DIRECTIVA DE DEPENDENCIAS NATIVAS ---
// Este bloque es esencial para la funcionalidad de Spotify.
dependencies {
    // 1. SDK de Autenticación (se descarga de Maven Central):
    // Maneja el flujo de login y la obtención de tokens.
    implementation("com.spotify.android:auth:2.1.2")

    // 2. SDK App Remote (librería local):
    // Permite la comunicación y control de la app de Spotify instalada en el dispositivo.
    implementation(files("../../libs/spotify-app-remote-release-0.8.0.aar"))

    // 3. SDK de Almacenamiento de Autenticación (librería local):
    // Ayuda a guardar de forma segura los tokens para que el usuario no inicie sesión repetidamente.
    implementation(files("../../libs/spotify-auth-store-release-2.1.0.aar"))

    // Nota: El archivo spotify-auth-release-2.1.0.aar no es estrictamente necesario
    // aquí porque la implementación remota 'com.spotify.android:auth:2.1.2' ya lo provee.
    // Incluirlo localmente podría causar conflictos de duplicados.
}
