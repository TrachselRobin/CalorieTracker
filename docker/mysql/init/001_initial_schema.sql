-- Initial database bootstrap for a fresh MySQL volume.
--
-- MySQL executes files in /docker-entrypoint-initdb.d only once, when the
-- database volume is empty. Define the first application schema or seed data
-- here if the app needs a SQL bootstrap before Doctrine migrations exist.
--
-- Example:
--
-- CREATE TABLE example (
--     id INT UNSIGNED AUTO_INCREMENT NOT NULL,
--     name VARCHAR(255) NOT NULL,
--     created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     PRIMARY KEY (id)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
--
-- For later schema changes, create Doctrine migrations in ./migrations and run:
--   make docker-migrate-local
--   make docker-migrate-live

CREATE TABLE User (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)
