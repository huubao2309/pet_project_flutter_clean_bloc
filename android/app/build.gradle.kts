plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.clean.bloc.pet_project_flutter_clean_bloc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.clean.bloc.pet_project_flutter_clean_bloc"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Each product flavor maps 1:1 to a Dart entry point (lib/main_<flavor>.dart)
    // and an iOS scheme of the same name. `app_name` is exposed as a string
    // resource and referenced from AndroidManifest.xml via @string/app_name.
    flavorDimensions += "env"

    productFlavors {
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".stg"
            versionNameSuffix = "-stg"
            resValue("string", "app_name", "Pet Project Staging")
        }
        create("uat") {
            dimension = "env"
            applicationIdSuffix = ".uat"
            versionNameSuffix = "-uat"
            resValue("string", "app_name", "Pet Project UAT")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Pet Project")
        }
    }
}

flutter {
    source = "../.."
}
