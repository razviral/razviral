// ARCHIVO: apps/mobile/android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()

        // --- DIRECTIVA DE INTEGRACIÓN NATIVA ---
        // Se añade un repositorio 'flatDir'. Esto le ordena a Gradle buscar
        // dependencias de tipo .aar o .jar en el directorio especificado.
        // Es crucial para que el proyecto encuentre las librerías del SDK de Spotify
        // que no se distribuyen a través de Maven Central. La ruta '../libs' es
        // relativa a este archivo, apuntando correctamente a 'apps/mobile/libs/'.
        flatDir {
            dirs("../libs")
        }
    }
}

// --- CONFIGURACIÓN DEL WORKSPACE NX ---
// Estas directivas son parte de la integración con el monorepo de Nx
// y no deben ser modificadas. Redirigen el directorio de salida de la compilación.
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
