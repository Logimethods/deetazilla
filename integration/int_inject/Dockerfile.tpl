FROM maven:3-jdk-8-alpine as maven
COPY pom.xml .
RUN mvn dependency:copy-dependencies -DoutputDirectory=/libs

FROM ${gatling_image}:${gatling_version}
COPY --from=maven /libs/*.jar /opt/gatling/lib/
COPY conf /opt/gatling/conf
COPY user-files /opt/gatling/user-files
