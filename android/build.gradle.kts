allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Fix for plugins missing namespace (common in Isar 3.1.0+1 with AGP 8+)
subprojects {
    val project = this
    project.plugins.whenPluginAdded {
        if (this.javaClass.name.contains("com.android.build.gradle.LibraryPlugin") ||
            this.javaClass.name.contains("com.android.build.gradle.AppPlugin")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    if (getNamespace.invoke(android) == null) {
                        val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                        val namespace = if (project.name == "isar_flutter_libs") {
                            "dev.isar.isar_flutter_libs"
                        } else {
                            "com.example.${project.name.replace("-", "_")}"
                        }
                        setNamespace.invoke(android, namespace)
                    }
                } catch (e: Exception) {
                    // Fallback
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
