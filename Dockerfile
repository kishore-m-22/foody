# Stage 1: Build Java classes using OpenJDK 17
FROM openjdk:17-jdk-slim AS builder

WORKDIR /app

# Copy source files and libraries
COPY src ./src
COPY src/main/webapp/WEB-INF/lib /app/lib/

# Find all Java files and compile them into /app/classes
RUN mkdir -p /app/classes && \
    find src -name "*.java" > sources.txt && \
    javac -cp "/app/lib/*" -d /app/classes @sources.txt

# Stage 2: Deploy to Tomcat 9
FROM tomcat:9.0-jdk17

# Remove Tomcat default root app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy web assets (JSPs, CSS, JS, images, WEB-INF) into ROOT webapp directory
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copy compiled class files into WEB-INF/classes
COPY --from=builder /app/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

EXPOSE 8080
CMD ["catalina.sh", "run"]