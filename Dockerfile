# Stage 1: Build Java classes
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

# Copy the entire project repository
COPY . .

# Ensure lib directory exists and download Servlet API (required for Servlets/JSPs compilation)
RUN mkdir -p /app/lib && \
    echo "Downloading Servlet API..." && \
    apt-get update && apt-get install -y curl && \
    curl -L -o /app/lib/javax.servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar

# Find all Java files and list them
RUN echo "Searching for Java files..." && \
    find . -name "*.java" > sources.txt && \
    cat sources.txt

# Compile Java source files into /app/classes using the downloaded Servlet API and project libs
RUN mkdir -p /app/classes && \
    javac -cp "/app/lib/*:src/main/webapp/WEB-INF/lib/*:WebContent/WEB-INF/lib/*" -d /app/classes @sources.txt

# Stage 2: Deploy to Tomcat 9
FROM tomcat:9.0-jdk17

# Remove Tomcat default root app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy web assets (support both src/main/webapp and WebContent structures)
RUN if [ -d "src/main/webapp" ]; then cp -r src/main/webapp/. /usr/local/tomcat/webapps/ROOT/; \
    elif [ -d "WebContent" ]; then cp -r WebContent/. /usr/local/tomcat/webapps/ROOT/; \
    fi

# Copy compiled class files into WEB-INF/classes
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes
COPY --from=builder /app/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

EXPOSE 8080
CMD ["catalina.sh", "run"]