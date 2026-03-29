FROM maven:latest
WORKDIR /app
COPY . /app
RUN cd /app && mvn install -Dskiptests
CMD ["java","-jar","/app/target/spring-petclinic-2.7.0-SNAPSHOT.jar"]
