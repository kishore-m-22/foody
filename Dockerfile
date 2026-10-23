# Use an official Tomcat server image with Java pre-installed
FROM tomcat:9.0-jdk17

# Remove default root applications in Tomcat to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your built WAR file from your project into Tomcat's webapps directory as ROOT.war
# (This ensures your app runs directly at the main URL without needing /foody)
COPY target/foody.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]