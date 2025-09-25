import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// キーストア設定を読み込み
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.kotoba.kakurenbo"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.kotoba.kakurenbo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // リリース用署名設定（keystore.propertiesから読み込み）
            if (keystoreProperties.containsKey("storeFile")) {
                storeFile = file("../${keystoreProperties["storeFile"]}")
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    flavorDimensions += "environment"
    
    productFlavors {
        create("production") {
            dimension = "environment"
            applicationId = "com.kotoba.kakurenbo"
            versionNameSuffix = ""
        }
        
        create("staging") {
            dimension = "environment"
            applicationId = "com.kotoba.kakurenbo.stg"
            versionNameSuffix = "-stg"
        }
        
        create("development") {
            dimension = "environment"
            applicationId = "com.kotoba.kakurenbo.dev"
            versionNameSuffix = "-dev"
        }
    }

    buildTypes {
        release {
            // AABファイル作成用の最適化設定（ディスク容量を考慮して一時的に無効化）
            isMinifyEnabled = false
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            // 本番用署名設定を使用する場合は以下をコメントアウト
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
