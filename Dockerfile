# Stage 1: Build
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Sao chep Gradle Wrapper va cau hinh
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

# Xu ly xuong dong CRLF cua gradlew tren Windows va cap quyen thuc thi
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

# Sao chep ma nguon
COPY src src

# Build JAR bo qua test
RUN ./gradlew bootJar --no-daemon -x test

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Tao tai khoan appuser chay ung dung
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Sao chep JAR sang runtime
COPY --from=build /app/build/libs/*.jar /app/app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]