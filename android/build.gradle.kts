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

    // Fix for legacy plugins missing namespace
    plugins.withId("com.android.library") {
        val androidExt = project.extensions.findByName("android")
        androidExt?.let {
            try {
                val getNamespace = it.javaClass.getMethod("getNamespace")
                val currentNamespace = getNamespace.invoke(it) as? String
                if (currentNamespace == null) {
                    val manifestFile = project.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val content = manifestFile.readText()
                        val packageRegex = """package="([^"]*)"""".toRegex()
                        val match = packageRegex.find(content)
                        if (match != null) {
                            val setNamespace = it.javaClass.getMethod("setNamespace", String::class.java)
                            setNamespace.invoke(it, match.groupValues[1])
                        }
                    }
                }
            } catch (e: Exception) {
                // Ignore
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
