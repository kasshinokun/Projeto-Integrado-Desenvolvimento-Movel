// android/build.gradle.kts
buildscript {
    repositories {
        // Repositório Maven do Google, onde o plugin do Google Services é hospedado.
        google()
        // Repositório Maven Central.
        mavenCentral()
    }
    dependencies {
        // A classpath do plugin Android Gradle.
        classpath("com.android.tools.build:gradle:8.1.0") // Verifique a versão mais recente compatível com seu Flutter
        // A classpath do plugin Kotlin Gradle.
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.0") // Verifique a versão compatível com seu Kotlin
        // A classpath do plugin Google Services (Firebase).
        // Esta é a linha crucial que estava faltando ou com versão incorreta.
        classpath("com.google.gms:google-services:4.4.1") // Use a versão mais recente do Google Services plugin
    }
}

allprojects {
    repositories {
        // Repositório Maven do Google.
        google()
        // Repositório Maven Central.
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Limpa o diretório de build.
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

