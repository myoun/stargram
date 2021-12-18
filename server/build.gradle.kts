plugins {
    kotlin("jvm") version "1.6.0"
    application
}

val ktor_version: String by project

group = "live.myoun"
version = "1.0.0"

application {
    mainClass.set("live.myoun.stargram.server.ApplicationKt")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
    implementation("io.ktor:ktor-server-core:$ktor_version")
    implementation("io.ktor:ktor-server-netty:$ktor_version")
    implementation("org.neo4j.driver:neo4j-java-driver:4.4.2")
    implementation("io.ktor:ktor-gson:$ktor_version")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.0")
    implementation("com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.13.0")
}
