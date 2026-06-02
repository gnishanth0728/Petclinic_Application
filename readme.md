# Spring Framework PetClinic with MySQL and Docker

## Overview

This project is a traditional Spring MVC PetClinic application packaged as a WAR file and deployed on Jetty. The application uses MySQL as the backend database and is containerized using Docker and Docker Compose.

## Architecture

```text
+-------------+
|   Browser   |
+------+------+
       |
       v
+-------------+
|    Jetty    |
|  ROOT.war   |
+------+------+
       |
       v
+-------------+
| Spring MVC  |
| Controllers |
+------+------+
       |
       v
+-------------+
| Spring Data |
|     JPA     |
+------+------+
       |
       v
+-------------+
| Hibernate   |
+------+------+
       |
       v
+-------------+
|   MySQL 8   |
+-------------+
```

## Technology Stack

* Java 17
* Spring Framework 7
* Spring MVC
* Spring Data JPA
* Hibernate
* MySQL 8
* Jetty 11
* Maven
* Docker
* Docker Compose

---

## Project Structure

```text
.
├── Dockerfile
├── docker-compose.yml
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   ├── resources
│   │   │   └── db
│   │   │       └── mysql
│   │   │           ├── schema.sql
│   │   │           └── data.sql
│   │   └── webapp
│   └── test
└── target
```

---

## Database Configuration

MySQL Profile:

```xml
<profile>
    <id>MySQL</id>

    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>

    <properties>
        <db.script>mysql</db.script>
        <jpa.database>MYSQL</jpa.database>
        <jdbc.driverClassName>com.mysql.cj.jdbc.Driver</jdbc.driverClassName>
        <jdbc.url>jdbc:mysql://mysql:3306/petclinic?useUnicode=true</jdbc.url>
        <jdbc.username>petclinic</jdbc.username>
        <jdbc.password>petclinic</jdbc.password>
    </properties>
</profile>
```

---

## Docker Architecture

```text
+----------------------+
|     PetClinic        |
|      Container       |
|----------------------|
| Jetty                |
| Spring MVC           |
| Hibernate            |
+----------+-----------+
           |
           |
           v
+----------------------+
|      MySQL 8         |
|      Container       |
+----------------------+
```

Containers communicate using a dedicated Docker bridge network.

---

## Docker Compose

```yaml
services:
  mysql:
    image: mysql:8.0

  petclinic:
    build: .
    depends_on:
      mysql:
        condition: service_healthy
```

---

## Running Locally Without Docker

### Start MySQL

```bash
docker run -d \
  --name petclinic-mysql \
  -e MYSQL_DATABASE=petclinic \
  -e MYSQL_USER=petclinic \
  -e MYSQL_PASSWORD=petclinic \
  -e MYSQL_ROOT_PASSWORD=root \
  -p 3306:3306 \
  mysql:8.0
```

### Run Application

```bash
mvn jetty:run-war
```

Open:

```text
http://localhost:8080
```

---

## Running with Docker Compose

### Build and Start

```bash
docker compose up --build
```

### Run Detached

```bash
docker compose up -d --build
```

### View Logs

```bash
docker compose logs -f
```

### Stop

```bash
docker compose down
```

---

## Build Docker Image

```bash
docker build -t petclinic .
```

Run:

```bash
docker run -d \
  --name petclinic \
  -p 8080:8080 \
  petclinic
```

---

## Verify MySQL

Connect:

```bash
docker exec -it petclinic-mysql mysql -upetclinic -ppetclinic petclinic
```

Show tables:

```sql
SHOW TABLES;
```

Count records:

```sql
SELECT COUNT(*) FROM owners;
SELECT COUNT(*) FROM pets;
SELECT COUNT(*) FROM vets;
SELECT COUNT(*) FROM visits;
```

---

## Health Checks

MySQL health check:

```yaml
healthcheck:
  test: ["CMD-SHELL", "mysqladmin ping -h localhost -uroot -proot || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 10
```

PetClinic starts only after MySQL becomes healthy.

---

## Build Commands

Package WAR:

```bash
mvn clean package -DskipTests
```

Run tests:

```bash
mvn test
```

Clean build:

```bash
mvn clean install
```

---

## Application URL

```text
http://localhost:8080
```
