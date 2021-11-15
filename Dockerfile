FROM gradle:7.3-jdk11-alpine AS build
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
RUN ./gradlew build --no-daemon || return 0

COPY . .
RUN ./gradlew build

FROM openjdk:11-jre-slim

ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME

EXPOSE 8080

ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME

COPY --from=build $APP_HOME/build/libs/*.jar /app/

ENTRYPOINT ["java","-jar","/app/demo-0.0.1-SNAPSHOT.jar"]
