/*Erro 1:

---> Mensagem apresentada:

The supplied phased action failed with an exception.
A problem occurred configuring root project 'android'.
Build file 'D:\Docs\PUC-Backup\PUC Apresentações 2025-1\Flutter_App
\PI_1_DM\Sprint 1\TP_S1\android\build.gradle.kts' line: 16
A problem occurred configuring project ':app'.
Build file 'D:\Docs\PUC-Backup\PUC Apresentações 2025-1\Flutter_App\PI_1_DM\Sprint 1
\TP_S1\android\app\build.gradle.kts' line: 1
An exception occurred applying plugin request [id: 'com.android.application']
Failed to apply plugin 'com.android.internal.application'.
Your project path contains non-ASCII characters. This will most likely 
cause the build to fail on Windows. Please move your project to a different directory. 
See http://b.android.com/95744 for details. This warning can be disabled by 
adding the line 'android.overridePathCheck=true' to gradle.properties file in the project directory.
*/
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
/*Erro:

------> Mensagem apresentada:

The supplied phased action failed with an exception.
A problem occurred configuring root project 'android'.
Build file 'D:\Docs\PUC-Backup\PUC Apresentações 2025-1\
Flutter_App\PI_1_DM\Sprint 1\TP_S1\android\build.gradle.kts' line: 16
A problem occurred configuring project ':app'.
Build file 'D:\Docs\PUC-Backup\PUC Apresentações 2025-1\Flutter_App\PI_1_DM\
Sprint 1\TP_S1\android\app\build.gradle.kts' line: 1
An exception occurred applying plugin request [id: 'com.android.application']
Failed to apply plugin 'com.android.internal.application'.
Your project path contains non-ASCII characters. This will most likely 
cause the build to fail on Windows. Please move your project to a different directory. 
See http://b.android.com/95744 for details. 
This warning can be disabled by adding the line 'android.overridePathCheck=true' 
to gradle.properties file in the project directory.

*/
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
