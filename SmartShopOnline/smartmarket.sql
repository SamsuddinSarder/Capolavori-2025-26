DROP DATABASE IF EXISTS smartmarket;
CREATE DATABASE smartmarket CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE smartmarket;

-- ==========================================
-- UTENTI (LOGIN SISTEMA)
-- ==========================================

CREATE TABLE utenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    ruolo ENUM('admin','cassiere','cliente') DEFAULT 'cliente',
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- CLIENTI CON CARTA FEDELTA'
-- ==========================================

CREATE TABLE clienti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codice_tessera VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    punti_fedelta INT DEFAULT 0,
    data_registrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- CATEGORIE
-- ==========================================

CREATE TABLE categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- ==========================================
-- PRODOTTI
-- ==========================================

CREATE TABLE prodotti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    barcode VARCHAR(30) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    prezzo_netto DECIMAL(10,2) NOT NULL,
    iva DECIMAL(5,2) NOT NULL,
    giacenza INT DEFAULT 0,
    immagine VARCHAR(255),
    categoria_id INT,
    attivo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (categoria_id)
    REFERENCES categorie(id)
);

-- ==========================================
-- CASSE
-- ==========================================

CREATE TABLE casse (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    attiva BOOLEAN DEFAULT TRUE
);

-- ==========================================
-- SCONTRINI
-- ==========================================

CREATE TABLE scontrini (
    id INT AUTO_INCREMENT PRIMARY KEY,

    cliente_id INT NULL,
    cassa_id INT NOT NULL,

    data_scontrino TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    totale_netto DECIMAL(10,2) DEFAULT 0,
    totale_iva DECIMAL(10,2) DEFAULT 0,
    totale_lordo DECIMAL(10,2) DEFAULT 0,

    FOREIGN KEY (cliente_id)
    REFERENCES clienti(id),

    FOREIGN KEY (cassa_id)
    REFERENCES casse(id)
);

-- ==========================================
-- RIGHE SCONTRINO
-- ==========================================

CREATE TABLE righe_scontrino (
    id INT AUTO_INCREMENT PRIMARY KEY,

    scontrino_id INT NOT NULL,
    prodotto_id INT NOT NULL,

    quantita INT NOT NULL DEFAULT 1,

    prezzo_unitario DECIMAL(10,2) NOT NULL,
    iva DECIMAL(5,2) NOT NULL,

    FOREIGN KEY (scontrino_id)
    REFERENCES scontrini(id)
    ON DELETE CASCADE,

    FOREIGN KEY (prodotto_id)
    REFERENCES prodotti(id)
);

-- ==========================================
-- DATI DI TEST
-- ==========================================

INSERT INTO categorie(nome) VALUES
('Pasta'),
('Bevande'),
('Dolci'),
('Latticini'),
('Conserve');

INSERT INTO casse(nome) VALUES
('Cassa 1'),
('Cassa 2'),
('Cassa 3');

INSERT INTO clienti
(codice_tessera,nome,cognome,telefono,email,punti_fedelta)
VALUES
('100001','Mario','Rossi','3331111111','mario@email.it',50),
('100002','Giulia','Bianchi','3332222222','giulia@email.it',20),
('100003','Luca','Verdi','3333333333','luca@email.it',100);

INSERT INTO prodotti
(barcode,nome,descrizione,prezzo_netto,iva,giacenza,categoria_id)
VALUES
('800100000001','Penne Rigate','Pasta di semola di grano duro',1.20,10,120,1),
('800100000002','Spaghetti','Pasta lunga trafilata al bronzo',1.50,10,200,1),
('800100000003','Latte Intero','Latte fresco pastorizzato 1L',1.30,4,80,4),
('800100000004','Coca Cola','Bibita gassata 1.5L',2.10,22,60,2),
('800100000005','Nutella','Crema alle nocciole 400g',4.80,10,40,3),
('800100000006','Passata di Pomodoro','Conserva di pomodoro 700g',1.70,10,70,5),
('800100000007','Fusilli','Pasta corta a spirale',1.10,10,150,1),
('800100000008','Acqua Naturale','Acqua minerale naturale 2L',0.50,22,300,2),
('800100000009','Biscotti Integrali','Biscotti con cereali 500g',2.40,10,90,3),
('800100000010','Yogurt Bianco','Yogurt intero 500g',1.60,4,60,4);

-- Utente admin con password: admin123
-- Hash generato con password_hash('admin123', PASSWORD_DEFAULT)
INSERT INTO utenti
(nome,cognome,email,password_hash,ruolo)
VALUES
(
  'Admin',
  'SmartMarket',
  'admin@smartmarket.it',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'admin'
),
(
  'Mario',
  'Cassiere',
  'cassa@smartmarket.it',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'cassiere'
);

-- Nota: la password hash sopra corrisponde a "password" (hash standard di Laravel/PHP)
-- Per usare admin123 registrati tramite l'interfaccia oppure aggiorna manualmente

-- ==========================================
-- VISTA PRODOTTI CON CATEGORIA
-- ==========================================

CREATE VIEW vista_prodotti AS
SELECT
    p.id,
    p.barcode,
    p.nome,
    p.descrizione,
    p.prezzo_netto,
    p.iva,
    ROUND(p.prezzo_netto + (p.prezzo_netto * p.iva / 100), 2) AS prezzo_ivato,
    p.giacenza,
    c.nome AS categoria
FROM prodotti p
LEFT JOIN categorie c ON p.categoria_id = c.id
WHERE p.attivo = 1;
