# Use official MySQL 8.0 image
FROM mysql:8.0

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=hotel_management
ENV MYSQL_USER=hotel_admin
ENV MYSQL_PASSWORD=hotel123

# Install additional utilities
RUN apt-get update && \
    apt-get install -y \
    vim \
    less \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy initialization script
COPY solution.sql /docker-entrypoint-initdb.d/

# Expose MySQL port
EXPOSE 3306

# The default command will start MySQL server
CMD ["mysqld"]
