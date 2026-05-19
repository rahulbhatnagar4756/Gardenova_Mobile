plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}
dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))
    implementation("com.google.android.gms:play-services-auth:21.0.0")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics-ndk")
    implementation("com.facebook.android:facebook-login:latest.release")
    implementation("com.facebook.android:facebook-android-sdk:latest.release")

    // Add the dependencies for any other desired Firebase products
    // https://firebase.google.com/docs/android/setup#available-libraries
}
android {
    signingConfigs {
        create("release") {
            keyAlias = "gardenova"
            storeFile = file("D:\\live_projects\\Gardenova_Mobile\\android\\app\\gardenova.jks")
            storePassword = "12345678"
            keyPassword = "12345678"
        }
    }
    namespace = "com.gardenova.digisoft"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gardenova.digisoft"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

  /*  flavorDimensions.add("default")
      productFlavors.create("prod") {
          dimension = "default"
          resValue("string", "app_name", "Gardenova")
      }
      productFlavors.create("dev") {
          dimension = "default"
          applicationIdSuffix = ""
          resValue("string", "app_name", "Gardenova Dev")
          versionNameSuffix = ".dev"
      }*/
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release");
            isMinifyEnabled = false
            isShrinkResources = false

//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt")
//            )
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

        }
    }
}

flutter {
    source = "../.."
}
