# Simple root-level Dockerfile for running the Quarkus app in JVM mode
# Build the application first:
#   ./gradlew build -Dquarkus.package.type=fast-jar
# Then build the image:
#   docker build -t simpleslideshow:latest .
# And run it (exposes 18181 as configured in application.properties):
#   docker run --rm -p 18181:18181 simpleslideshow:latest

FROM eclipse-temurin:21-jre-alpine

ENV LANGUAGE="en_US:en"
WORKDIR /work/

# Copy the quarkus app layout produced by the build into the image
# The project contains a `pom.xml`, so Maven builds create `target/quarkus-app`.
# If you build with Gradle instead, switch these back to `build/quarkus-app`.
COPY target/quarkus-app/lib/ /work/lib/
COPY target/quarkus-app/*.jar /work/
COPY target/quarkus-app/app/ /work/app/
COPY target/quarkus-app/quarkus/ /work/quarkus/

# Quarkus app port
EXPOSE 18181

# Ensure Quarkus binds to all interfaces inside the container
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

# Run the application
ENTRYPOINT ["java","-jar","/work/quarkus-run.jar"]
