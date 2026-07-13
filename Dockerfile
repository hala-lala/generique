ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-jre-alpine

LABEL maintainer="hala"
LABEL description="Image de l'application java-maven-generique"

ENV APP_HOME=/app
ENV JAVA_OPTS=""

WORKDIR $APP_HOME

# ---- Flexible : n'importe quel nom/version de jar dans target/ ----
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

RUN echo "Build termine" > /app/build-info.txt

EXPOSE 8080

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

HEALTHCHECK --interval=30s --timeout=5s \
  CMD wget -q --spider http://localhost:8080/ || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]