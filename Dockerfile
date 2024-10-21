# Use a base image with OpenJDK
FROM openjdk:17-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot JAR file into the container
COPY target/cart-service-0.0.1-SNAPSHOT.jar /app/m-cart-service.jar

# Expose the port that the application runs on
EXPOSE 9008

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/m-cart-service.jar"]
