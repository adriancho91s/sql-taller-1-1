-- =====================================================
-- SQL WORKSHOP SOLUTION
-- Universidad Tecnológica de Pereira
-- Database: hotel_management
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;

-- =====================================================
-- 1. CREATE TABLES (3 statements)
-- =====================================================

-- Table 1: ciudades (cities)
CREATE TABLE ciudades (
    Id_ciudad INT(11) NOT NULL AUTO_INCREMENT,
    Nombre_ciudad VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_ciudad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 2: clientes_hotel (hotel clients)
CREATE TABLE clientes_hotel (
    Id_ClienteHotel INT(11) NOT NULL AUTO_INCREMENT,
    Nombre_ClienteHotel VARCHAR(50) NOT NULL,
    Apellido_ClienteHotel VARCHAR(50) NOT NULL,
    Genero_ClienteHotel VARCHAR(50) NOT NULL,
    Id_ciudad INT(11) NOT NULL,
    PRIMARY KEY (Id_ClienteHotel),
    INDEX idx_ciudad (Id_ciudad),
    CONSTRAINT fk_cliente_ciudad FOREIGN KEY (Id_ciudad)
        REFERENCES ciudades(Id_ciudad)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table 3: telefonos_cliente_hotel (client phones)
CREATE TABLE telefonos_cliente_hotel (
    Id_TelefonoCliente INT(11) NOT NULL AUTO_INCREMENT,
    Numero_TelefonoCliente INT(11) NOT NULL,
    Id_ClienteHotel INT(11) NOT NULL,
    PRIMARY KEY (Id_TelefonoCliente),
    INDEX idx_cliente (Id_ClienteHotel),
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (Id_ClienteHotel)
        REFERENCES clientes_hotel(Id_ClienteHotel)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- 2. ALTER TABLE - Add column numerohab_ciudad (1 statement)
-- =====================================================

ALTER TABLE ciudades
ADD COLUMN numerohab_ciudad INT(11) NOT NULL DEFAULT 0;

-- =====================================================
-- 3. ALTER TABLE - Modify column Numero_TelefonoCliente (1 statement)
-- =====================================================

ALTER TABLE telefonos_cliente_hotel
MODIFY COLUMN Numero_TelefonoCliente VARCHAR(12) NOT NULL;

-- =====================================================
-- 4. ALTER TABLE - Delete column (ERROR) (1 statement)
-- This will generate an error because we're trying to delete a non-existent column
-- =====================================================

ALTER TABLE ciudades
DROP COLUMN columna_inexistente;

-- =====================================================
-- 5. CREATE TABLE - Error table with referential integrity (1 statement)
-- =====================================================

CREATE TABLE errores_sistema (
    Id_Error INT(11) NOT NULL AUTO_INCREMENT,
    Codigo_Error VARCHAR(20) NOT NULL,
    Descripcion_Error TEXT NOT NULL,
    Fecha_Error DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Id_ClienteHotel INT(11),
    PRIMARY KEY (Id_Error),
    INDEX idx_cliente_error (Id_ClienteHotel),
    CONSTRAINT fk_error_cliente FOREIGN KEY (Id_ClienteHotel)
        REFERENCES clientes_hotel(Id_ClienteHotel)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- 6. ALTER TABLE - Add column (ERROR) (1 statement)
-- This will generate an error because we're trying to add a duplicate column
-- =====================================================

ALTER TABLE errores_sistema
ADD COLUMN Id_Error INT(11) NOT NULL;

-- =====================================================
-- 7. ALTER TABLE - Add index (ERROR) (1 statement)
-- This will generate an error because we're trying to create a duplicate index
-- =====================================================

ALTER TABLE errores_sistema
ADD INDEX idx_cliente_error (Id_ClienteHotel);

-- =====================================================
-- 8. ALTER TABLE - Add foreign key (ERROR) (1 statement)
-- This will generate an error because we're trying to add a duplicate foreign key
-- =====================================================

ALTER TABLE errores_sistema
ADD CONSTRAINT fk_error_cliente FOREIGN KEY (Id_ClienteHotel)
    REFERENCES clientes_hotel(Id_ClienteHotel)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- =====================================================
-- INSERT SAMPLE DATA (Optional - for testing purposes)
-- =====================================================

-- Insert cities
INSERT INTO ciudades (Nombre_ciudad, numerohab_ciudad) VALUES
('Pereira', 100),
('Bogotá', 500),
('Medellín', 300),
('Cali', 250);

-- Insert clients
INSERT INTO clientes_hotel (Nombre_ClienteHotel, Apellido_ClienteHotel, Genero_ClienteHotel, Id_ciudad) VALUES
('Juan', 'Pérez', 'Masculino', 1),
('María', 'González', 'Femenino', 2),
('Carlos', 'Rodríguez', 'Masculino', 3),
('Ana', 'Martínez', 'Femenino', 1);

-- Insert phone numbers
INSERT INTO telefonos_cliente_hotel (Numero_TelefonoCliente, Id_ClienteHotel) VALUES
('3001234567', 1),
('3109876543', 2),
('3201112233', 3),
('3154445566', 4),
('3007778899', 1);

-- Insert error logs
INSERT INTO errores_sistema (Codigo_Error, Descripcion_Error, Id_ClienteHotel) VALUES
('ERR001', 'Error de conexión a base de datos', 1),
('ERR002', 'Timeout en consulta de disponibilidad', 2),
('ERR003', 'Error al procesar reserva', NULL);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Show all tables
SHOW TABLES;

-- Describe table structures
DESCRIBE ciudades;
DESCRIBE clientes_hotel;
DESCRIBE telefonos_cliente_hotel;
DESCRIBE errores_sistema;

-- Show foreign key relationships
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'hotel_management'
    AND REFERENCED_TABLE_NAME IS NOT NULL;
