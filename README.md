# SQL Workshop 1 - Hotel Management Database

Universidad Tecnológica de Pereira
Facultad de Ingenierías Eléctrica, Electrónica, Física y Ciencias de la Computación

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/adriancho91s/sql-taller-1-1)

## 📋 Overview

This project contains the complete solution for SQL Workshop 1, implementing a hotel management database system with the following tables:
- `ciudades` (cities)
- `clientes_hotel` (hotel clients)
- `telefonos_cliente_hotel` (client phone numbers)
- `errores_sistema` (system errors)

## 🗂️ Project Structure

```
sql-taller-1-1/
├── .devcontainer/
│   └── devcontainer.json       # GitHub Codespaces configuration
├── Dockerfile                   # MySQL container configuration
├── docker-compose.yml          # Docker Compose orchestration
├── solution.sql                # Complete SQL solution
├── init.sh                     # Initialization script
└── README.md                   # This file
```

## 🚀 Quick Start

### Option 1: GitHub Codespaces (Recommended)

1. **Open in Codespaces:**
   - Click the green "Code" button on GitHub
   - Select "Codespaces" tab
   - Click "Create codespace on main"

2. **Wait for initialization:**
   - The devcontainer will automatically build and start
   - MySQL will be ready on port 3306
   - Adminer web interface will open on port 8080

3. **Access the database:**
   - Open Adminer at `http://localhost:8080`
   - Or use the MySQL CLI: `mysql -h localhost -u hotel_admin -photel123 hotel_management`

### Option 2: Local Development

#### Prerequisites
- Docker and Docker Compose installed
- Git (optional)

#### Steps

1. **Clone or navigate to the project:**
   ```bash
   cd sql-taller-1-1
   ```

2. **Start the services:**
   ```bash
   docker-compose up -d
   ```

3. **Wait for MySQL to initialize:**
   ```bash
   docker-compose logs -f mysql
   # Wait for "ready for connections" message
   ```

4. **Access the database:**
   - **Web Interface (Adminer):** Open `http://localhost:8080`
     - System: MySQL
     - Server: mysql
     - Username: hotel_admin
     - Password: hotel123
     - Database: hotel_management

   - **MySQL CLI:**
     ```bash
     docker exec -it hotel_management_db mysql -u hotel_admin -photel123 hotel_management
     ```

5. **Stop the services:**
   ```bash
   docker-compose down
   ```

6. **Stop and remove all data:**
   ```bash
   docker-compose down -v
   ```

## 🔧 Using the Initialization Script

For automated setup, use the provided script:

```bash
chmod +x init.sh
./init.sh
```

The script will:
- Check Docker installation
- Build and start containers
- Wait for database readiness
- Display connection information
- Open Adminer in your browser (if available)

## 📝 Workshop Requirements

The `solution.sql` file includes all required SQL statements:

### ✅ 1. CREATE TABLES (3 statements)
- `ciudades`: Cities table
- `clientes_hotel`: Hotel clients table
- `telefonos_cliente_hotel`: Client phone numbers table

### ✅ 2. ALTER TABLE - Add Column
- Adds `numerohab_ciudad` column to `ciudades` table

### ✅ 3. ALTER TABLE - Modify Column
- Modifies `Numero_TelefonoCliente` to VARCHAR(12)

### ✅ 4. ALTER TABLE - Delete Column (ERROR)
- Attempts to delete non-existent column (generates error)

### ✅ 5. CREATE TABLE - Error Table
- Creates `errores_sistema` table with foreign key constraints

### ✅ 6. ALTER TABLE - Add Column (ERROR)
- Attempts to add duplicate column (generates error)

### ✅ 7. ALTER TABLE - Add Index (ERROR)
- Attempts to create duplicate index (generates error)

### ✅ 8. ALTER TABLE - Add Foreign Key (ERROR)
- Attempts to add duplicate foreign key (generates error)

## 🗄️ Database Schema

```
ciudades
├── Id_ciudad (PK)
├── Nombre_ciudad
└── numerohab_ciudad

clientes_hotel
├── Id_ClienteHotel (PK)
├── Nombre_ClienteHotel
├── Apellido_ClienteHotel
├── Genero_ClienteHotel
└── Id_ciudad (FK → ciudades)

telefonos_cliente_hotel
├── Id_TelefonoCliente (PK)
├── Numero_TelefonoCliente
└── Id_ClienteHotel (FK → clientes_hotel)

errores_sistema
├── Id_Error (PK)
├── Codigo_Error
├── Descripcion_Error
├── Fecha_Error
└── Id_ClienteHotel (FK → clientes_hotel)
```

## 📊 Sample Data

The solution includes sample data for testing:
- 4 cities (Pereira, Bogotá, Medellín, Cali)
- 4 hotel clients
- 5 phone numbers
- 3 system error logs

## 🔍 Verification Queries

After initialization, verify the setup:

```sql
-- Show all tables
SHOW TABLES;

-- Describe table structure
DESCRIBE ciudades;
DESCRIBE clientes_hotel;
DESCRIBE telefonos_cliente_hotel;
DESCRIBE errores_sistema;

-- View foreign key relationships
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME,
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'hotel_management'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- View sample data
SELECT * FROM ciudades;
SELECT * FROM clientes_hotel;
SELECT * FROM telefonos_cliente_hotel;
SELECT * FROM errores_sistema;
```

## 🛠️ Useful Commands

### Docker Commands

```bash
# View running containers
docker ps

# View container logs
docker-compose logs mysql
docker-compose logs adminer

# Restart services
docker-compose restart

# Rebuild containers
docker-compose up -d --build

# Access MySQL shell
docker exec -it hotel_management_db mysql -u root -prootpassword

# Execute SQL file
docker exec -i hotel_management_db mysql -u root -prootpassword hotel_management < solution.sql

# Backup database
docker exec hotel_management_db mysqldump -u root -prootpassword hotel_management > backup.sql

# Restore database
docker exec -i hotel_management_db mysql -u root -prootpassword hotel_management < backup.sql
```

### MySQL Commands

```sql
-- Show current database
SELECT DATABASE();

-- Show all databases
SHOW DATABASES;

-- Use specific database
USE hotel_management;

-- Show all tables
SHOW TABLES;

-- Show table structure
DESCRIBE table_name;

-- Show create statement
SHOW CREATE TABLE table_name;

-- Show foreign keys
SHOW CREATE TABLE clientes_hotel;
```

## 🔐 Credentials

### MySQL Root User
- Username: `root`
- Password: `rootpassword`

### MySQL Application User
- Username: `hotel_admin`
- Password: `hotel123`
- Database: `hotel_management`

### Adminer Web Interface
- URL: `http://localhost:8080`
- System: MySQL
- Server: mysql (or localhost)
- Username: hotel_admin
- Password: hotel123

## 🐛 Troubleshooting

### Port Already in Use

If port 3306 or 8080 is already in use:

1. **Edit `docker-compose.yml`** and change the ports:
   ```yaml
   ports:
     - "3307:3306"  # MySQL
     - "8081:8080"  # Adminer
   ```

2. **Restart services:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

### Database Not Initializing

If the database doesn't initialize properly:

```bash
# Remove volumes and restart
docker-compose down -v
docker-compose up -d

# Check logs
docker-compose logs -f mysql
```

### Cannot Connect to Database

1. **Check if container is running:**
   ```bash
   docker ps | grep hotel_management_db
   ```

2. **Check database is ready:**
   ```bash
   docker-compose logs mysql | grep "ready for connections"
   ```

3. **Test connection:**
   ```bash
   docker exec -it hotel_management_db mysqladmin ping -u root -prootpassword
   ```

## 📚 Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [Adminer Documentation](https://www.adminer.org/)

## 📄 License

This project is created for educational purposes as part of the Universidad Tecnológica de Pereira database course.

## 👥 Author

Adrián Fernando Gaitán Londoño
Universidad Tecnológica de Pereira
Facultad de Ingenierías - Database Course

---

**Note:** This solution demonstrates all required SQL statements including intentional error cases for educational purposes.
