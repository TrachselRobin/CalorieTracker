SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `User`
(
    id         INT UNSIGNED AUTO_INCREMENT NOT NULL,
    name       VARCHAR(50)                 NOT NULL,
    email      VARCHAR(255) UNIQUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Unit
(
    id         INT UNSIGNED AUTO_INCREMENT NOT NULL,
    name       VARCHAR(50)                 NOT NULL,
    symbol     VARCHAR(20)                 NOT NULL,
    type       VARCHAR(30)                 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_unit_symbol (symbol)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Ingredient
(
    id              INT UNSIGNED AUTO_INCREMENT NOT NULL,
    name            VARCHAR(100)                NOT NULL,
    default_unit_id INT UNSIGNED                NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_ingredient_name (name)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE NutrientContent
(
    id         INT UNSIGNED AUTO_INCREMENT NOT NULL,
    name       VARCHAR(100)                NOT NULL,
    unit_id    INT UNSIGNED                NOT NULL,
    category   VARCHAR(50)                 NULL,
    sort_order INT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_nutrient_name (name)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Ingredient_has_NutrientContent
(
    id                  INT UNSIGNED AUTO_INCREMENT NOT NULL,
    ingredient_id       INT UNSIGNED                NOT NULL,
    nutrient_content_id INT UNSIGNED                NOT NULL,
    amount_per_100g     DECIMAL(12, 4)              NOT NULL,
    is_visible          BOOLEAN   DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_ingredient_nutrient (ingredient_id, nutrient_content_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Recipe
(
    id          INT UNSIGNED AUTO_INCREMENT NOT NULL,
    user_id     INT UNSIGNED                NULL,
    name        VARCHAR(150)                NOT NULL,
    description TEXT                        NULL,
    servings    DECIMAL(8, 2) DEFAULT 1,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Recipe_has_Ingredient
(
    id            INT UNSIGNED AUTO_INCREMENT NOT NULL,
    recipe_id     INT UNSIGNED                NOT NULL,
    ingredient_id INT UNSIGNED                NOT NULL,
    amount        DECIMAL(12, 4)              NOT NULL,
    unit_id       INT UNSIGNED                NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


CREATE TABLE Ingredient_has_Unit
(
    id             INT UNSIGNED AUTO_INCREMENT NOT NULL,
    ingredient_id  INT UNSIGNED                NOT NULL,
    unit_id        INT UNSIGNED                NOT NULL,
    grams_per_unit DECIMAL(12, 4)              NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_ingredient_unit (ingredient_id, unit_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

ALTER TABLE Ingredient
    ADD CONSTRAINT fk_ingredient_default_unit
        FOREIGN KEY (default_unit_id) REFERENCES Unit (id)
            ON DELETE SET NULL;

ALTER TABLE NutrientContent
    ADD CONSTRAINT fk_nutrient_unit
        FOREIGN KEY (unit_id) REFERENCES Unit (id)
            ON DELETE RESTRICT;

ALTER TABLE Ingredient_has_NutrientContent
    ADD CONSTRAINT fk_ihnc_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES Ingredient (id)
            ON DELETE CASCADE,
    ADD CONSTRAINT fk_ihnc_nutrient
        FOREIGN KEY (nutrient_content_id) REFERENCES NutrientContent (id)
            ON DELETE CASCADE;

ALTER TABLE Recipe
    ADD CONSTRAINT fk_recipe_user
        FOREIGN KEY (user_id) REFERENCES `User` (id)
            ON DELETE SET NULL;

ALTER TABLE Recipe_has_Ingredient
    ADD CONSTRAINT fk_rhi_recipe
        FOREIGN KEY (recipe_id) REFERENCES Recipe (id)
            ON DELETE CASCADE,
    ADD CONSTRAINT fk_rhi_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES Ingredient (id)
            ON DELETE RESTRICT,
    ADD CONSTRAINT fk_rhi_unit
        FOREIGN KEY (unit_id) REFERENCES Unit (id)
            ON DELETE RESTRICT;

ALTER TABLE Ingredient_has_Unit
    ADD CONSTRAINT fk_ihu_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES Ingredient (id)
            ON DELETE CASCADE,
    ADD CONSTRAINT fk_ihu_unit
        FOREIGN KEY (unit_id) REFERENCES Unit (id)
            ON DELETE CASCADE;

INSERT INTO Unit (name, symbol, type)
VALUES ('Gramm', 'g', 'mass'),
       ('Kilogramm', 'kg', 'mass'),
       ('Milligramm', 'mg', 'mass'),
       ('Mikrogramm', 'µg', 'mass'),
       ('Milliliter', 'ml', 'volume'),
       ('Liter', 'l', 'volume'),
       ('Stück', 'pcs', 'count'),
       ('Kilokalorie', 'kcal', 'energy'),
       ('Kilojoule', 'kJ', 'energy');

INSERT INTO NutrientContent (name, unit_id, category, sort_order)
VALUES ('Kalorien', (SELECT id FROM Unit WHERE symbol = 'kcal'), 'energy', 10),
       ('Energie kJ', (SELECT id FROM Unit WHERE symbol = 'kJ'), 'energy', 20),
       ('Fett', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 30),
       ('Gesättigte Fettsäuren', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 40),
       ('Kohlenhydrate', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 50),
       ('Zucker', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 60),
       ('Ballaststoffe', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 70),
       ('Eiweiß', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 80),
       ('Salz', (SELECT id FROM Unit WHERE symbol = 'g'), 'macro', 90),
       ('Vitamin C', (SELECT id FROM Unit WHERE symbol = 'mg'), 'vitamin', 100),
       ('Vitamin A', (SELECT id FROM Unit WHERE symbol = 'µg'), 'vitamin', 110),
       ('Vitamin D', (SELECT id FROM Unit WHERE symbol = 'µg'), 'vitamin', 120),
       ('Vitamin B12', (SELECT id FROM Unit WHERE symbol = 'µg'), 'vitamin', 130),
       ('Calcium', (SELECT id FROM Unit WHERE symbol = 'mg'), 'mineral', 200),
       ('Eisen', (SELECT id FROM Unit WHERE symbol = 'mg'), 'mineral', 210),
       ('Magnesium', (SELECT id FROM Unit WHERE symbol = 'mg'), 'mineral', 220),
       ('Kalium', (SELECT id FROM Unit WHERE symbol = 'mg'), 'mineral', 230);
