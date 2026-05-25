allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
  // ...

  // Add the dependency for the Google services Gradle plugin
  id("com.google.gms.google-services") apply false

}

// dependencies {

// //   Import the Firebase BoM
//   implementation(platform("com.google.firebase:firebase-bom:34.13.0"))

//   // When using the BoM, you don't specify versions in Firebase library dependencies

//   // Add the dependency for the Firebase SDK for Google Analytics
//   implementation("com.google.firebase:firebase-analytics")

//   // TODO: Add the dependencies for any other Firebase products you want to use
//   // See https://firebase.google.com/docs/android/setup#available-libraries
//   // For example, add the dependencies for Firebase Authentication and Cloud Firestore
//   implementation("com.google.firebase:firebase-auth")
//   implementation("com.google.firebase:firebase-firestore")
//   implementation("com.google.firebase:firebase-storage")
// }

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
