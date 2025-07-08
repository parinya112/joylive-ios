plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    compileSdk = 34
    ndkVersion = "27.0.12077973" // 👈 เพื่อรองรับ Agora SDK

    defaultConfig {
        applicationId = "com.example.joy_liveth"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.0")
}
