# Stage 1: Build Java classes using Eclipse Temurin Java 17
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

# Copy the entire project repository
COPY . .

# Find all Java files and list them for debugging
RUN echo "Searching for Java files..." && \
    find . -name "*.java" > sources.txt && \
    cat sources.txt

# Compile Java source files into /app/classes using available JAR libraries
RUN mkdir -p /app/classes && \
    javac -cp "src/main/webapp/WEB-INF/lib/*:WebContent/WEB-INF/lib/*" -d /app/classes @sources.txt

# Stage 2: Deploy to Tomcat 9
FROM tomcat:9.0-jdk17

# Remove Tomcat's default root app
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