import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingProperties = Properties()
val signingPropertiesFile = rootProject.file("key.properties")
if (signingPropertiesFile.exists()) {
    signingPropertiesFile.inputStream().use(signingProperties::load)
}

fun signingValue(propertyName: String, environmentName: String): String? =
    (signingProperties.getProperty(propertyName)
        ?: System.getenv(environmentName))
        ?.takeIf { it.isNotBlank() }

val releaseStoreFile = signingValue("storeFile", "ORVIKA_UPLOAD_STORE_FILE")
val releaseStorePassword = signingValue("storePassword", "ORVIKA_UPLOAD_STORE_PASSWORD")
val releaseKeyAlias = signingValue("keyAlias", "ORVIKA_UPLOAD_KEY_ALIAS")
val releaseKeyPassword = signingValue("keyPassword", "ORVIKA_UPLOAD_KEY_PASSWORD")

val hasReleaseSigning = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { it != null }

if (gradle.startParameter.taskNames.any { task ->
        task.contains("assembleRelease", ignoreCase = true) ||
            task.contains("bundleRelease", ignoreCase = true)
    } && !hasReleaseSigning
) {
    throw GradleException(
        "ORVIKA release signing is not configured. Add android/key.properties " +
            "or provide ORVIKA_UPLOAD_STORE_FILE, ORVIKA_UPLOAD_STORE_PASSWORD, " +
            "ORVIKA_UPLOAD_KEY_ALIAS and ORVIKA_UPLOAD_KEY_PASSWORD. " +
            "Never commit signing credentials or keystores."
    )
}

android {
    namespace = "com.orvika.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.orvika.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(requireNotNull(releaseStoreFile))
                storePassword = requireNotNull(releaseStorePassword)
                keyAlias = requireNotNull(releaseKeyAlias)
                keyPassword = requireNotNull(releaseKeyPassword)
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
