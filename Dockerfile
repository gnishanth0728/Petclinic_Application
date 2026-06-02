FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /java-app

COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

FROM jetty:11-jdk17

COPY --from=builder target/petclinic.war /var/lib/jetty/webapps/ROOT.war
