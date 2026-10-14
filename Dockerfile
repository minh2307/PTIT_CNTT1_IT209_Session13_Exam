# Stage 1: Build Spring Boot executable JAR using Gradle
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copy Gradle wrapper and configuration files
COPY backend/gradle/ gradle/
COPY backend/gradlew backend/build.gradle backend/settings.gradle ./
RUN chmod +x gradlew

# Copy backend source code and build executable JAR
COPY backend/src/ src/
RUN ./gradlew bootJar -x test --no-daemon

# Stage 2: Lightweight runtime image
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy Spring Boot executable JAR produced by Gradle builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose default HTTP port
EXPOSE 8080

# Run the packaged application
ENTRYPOINT ["java", "-jar", "app.jar"]

