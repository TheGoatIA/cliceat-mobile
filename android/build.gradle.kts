allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.buildDir = rootProject.projectDir.parentFile.resolve("build").resolve(project.name)
}

// Utilisation du dossier de build par défaut de Flutter

subprojects {
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
