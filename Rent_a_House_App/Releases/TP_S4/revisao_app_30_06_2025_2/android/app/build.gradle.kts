// android/app/build.gradle.kts
plugins {
    // Aplica o plugin Android Application para configurar um projeto Android.
    id("com.android.application")
    // Aplica o plugin Kotlin Android para habilitar o uso de Kotlin no seu projeto.
    id("org.jetbrains.kotlin.android")
    // Aplica o plugin Google Services para processar o arquivo google-services.json
    // e configurar o Firebase.
    id("com.google.gms.google-services")
    // Aplica o plugin Flutter para integrar o projeto Flutter.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Configura a versão de compilação do SDK Android.
    // Usando flutter.compileSdkVersion para garantir compatibilidade com a versão do Flutter SDK.
    // Garante que seja Android 12 (API 31) ou superior, conforme solicitado.
    compileSdk = flutter.compileSdkVersion // Este geralmente já aponta para a versão mais recente suportada pelo Flutter.

    // Configura as opções de Java para o projeto.
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    // Configura as opções do Kotlin.
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Configura o namespace do aplicativo Android.
    namespace = "com.grupo.rentahouse.rent_a_house" // Atualizado conforme sua solicitação

    // Configura a versão do NDK.
    ndkVersion = "27.0.12077973" // Atualizado para NDK 27+ conforme sua solicitação

    // Configura a configuração padrão para todas as variantes de build.
    defaultConfig {
        // ID da aplicação (nome do pacote Android).
        applicationId = "com.grupo.rentahouse.rent_a_house" // Atualizado para corresponder ao namespace
        // Versão mínima do SDK Android suportada.
        minSdk = 23
        // Versão do SDK Android alvo.
        targetSdk = flutter.targetSdkVersion
        // Código da versão da aplicação.
        versionCode = flutter.versionCode
        // Nome da versão da aplicação.
        versionName = flutter.versionName
        // Habilita o suporte a múltiplas densidades de tela.
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    // Configura as variantes de build (e.g., debug, release).
    buildTypes {
        release {
            // Habilita a otimização do código e a remoção de código não utilizado.
            signingConfig = signingConfigs.getByName("debug") // Em produção, use sua própria signingConfig
            isMinifyEnabled = true
            // Arquivo de regras ProGuard para otimização e ofuscação.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // Configura o asset dir do Flutter para as variantes de build.
    flutter {
        source = "../.."
    }
}

dependencies {
    // Dependência padrão do Kotlin para o Android.
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:1.8.0")) // Versão pode variar, use a recomendada pelo Android Studio/Firebase

    // Firebase Android BoM (Bill of Materials) para gerenciar as versões das bibliotecas Firebase.
    // Isso garante que todas as suas bibliotecas Firebase sejam compatíveis entre si.
    implementation(platform("com.google.firebase:firebase-bom:32.7.4")) // Use a versão mais recente do Firebase BoM

    // Dependência para Firebase Authentication.
    implementation("com.google.firebase:firebase-auth")
    // Dependência para Cloud Firestore.
    implementation("com.google.firebase:firebase-firestore")
    // Se você ainda precisar de Firebase Storage para outras funcionalidades, adicione aqui.
    // implementation("com.google.firebase:firebase-storage")


    // Dependências de teste, se necessário.
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}