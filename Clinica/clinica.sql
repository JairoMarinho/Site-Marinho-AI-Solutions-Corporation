-- Criando o banco de dados
CREATE DATABASE IF NOT EXISTS Clinica;
USE Clinica;

-- Criando as tabelas
CREATE TABLE IF NOT EXISTS Ambulatorios (
    nroa INT PRIMARY KEY,
    andar NUMERIC(3) NOT NULL,
    capacidade SMALLINT
);

CREATE TABLE IF NOT EXISTS Medicos (
    codm INT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    idade SMALLINT NOT NULL,
    especialidade CHAR(20),
    CPF NUMERIC(11) UNIQUE,
    cidade VARCHAR(30),
    nroa INT,
    FOREIGN KEY (nroa) REFERENCES Ambulatorios(nroa)
);

CREATE TABLE IF NOT EXISTS Pacientes (
    codp INT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    idade SMALLINT NOT NULL,
    cidade CHAR(30),
    CPF NUMERIC(11) UNIQUE,
    doenca VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS Funcionarios (
    codf INT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    idade SMALLINT,
    CPF NUMERIC(11) UNIQUE,
    cidade VARCHAR(30),
    salario NUMERIC(10)
);

CREATE TABLE IF NOT EXISTS Consultas (
    codm INT,
    codp INT,
    data DATE,
    hora TIME,
    PRIMARY KEY (codm, codp, data, hora),
    FOREIGN KEY (codm) REFERENCES Medicos(codm),
    FOREIGN KEY (codp) REFERENCES Pacientes(codp)
);

-- Garantindo que estamos no banco correto
USE Clinica;

-- Verificando e adicionando coluna nroa em Funcionarios se não existir
ALTER TABLE Funcionarios ADD COLUMN nroa INT;


-- Criando índices
CREATE UNIQUE INDEX IF NOT EXISTS idx_medicos_cpf ON Medicos (CPF);
CREATE INDEX IF NOT EXISTS idx_pacientes_doenca ON Pacientes (doenca);

-- Removendo índice doenca em Pacientes, se existir
DROP INDEX IF EXISTS idx_pacientes_doenca ON Pacientes;

-- Removendo colunas cargo e nroa de Funcionarios, se existirem
ALTER TABLE Funcionarios DROP COLUMN IF EXISTS nroa;

-- Inserindo dados nas tabelas
INSERT INTO Ambulatorios VALUES
(1, 1, 30),
(2, 1, 50),
(3, 2, 40),
(4, 2, 25),
(5, 2, 55)
ON DUPLICATE KEY UPDATE andar=VALUES(andar), capacidade=VALUES(capacidade);

INSERT INTO Medicos VALUES
(1, 'Joao', 40, 'ortopedia', 10000100000, 'Florianopolis', 1),
(2, 'Maria', 42, 'traumatologia', 10000110000, 'Blumenau', 2),
(3, 'Pedro', 51, 'pediatria', 11000100000, 'São José', 2),
(4, 'Carlos', 28, 'ortopedia', 11000110000, 'Joinville', NULL),
(5, 'Marcia', 33, 'neurologia', 11000111000, 'Biguacu', 3)
ON DUPLICATE KEY UPDATE nome=VALUES(nome), idade=VALUES(idade), especialidade=VALUES(especialidade), CPF=VALUES(CPF), cidade=VALUES(cidade), nroa=VALUES(nroa);

INSERT INTO Funcionarios VALUES
(1, 'Rita', 32, 20000100000, 'Sao Jose', 1200),
(2, 'Maria', 55, 30000110000, 'Palhoca', 1220),
(3, 'Caio', 45, 41000100000, 'Florianopolis', 1100),
(4, 'Carlos', 44, 51000110000, 'Florianopolis', 1200),
(5, 'Paula', 33, 61000111000, 'Florianopolis', 2500)
ON DUPLICATE KEY UPDATE nome=VALUES(nome), idade=VALUES(idade), CPF=VALUES(CPF), cidade=VALUES(cidade), salario=VALUES(salario);

INSERT INTO Pacientes VALUES
(1, 'Ana', 20, 'Florianopolis', 20000200000, 'gripe'),
(2, 'Paulo', 24, 'Palhoca', 20000220000, 'fratura'),
(3, 'Lucia', 30, 'Biguacu', 22000200000, 'tendinite'),
(4, 'Carlos', 28, 'Joinville', 11000110000, 'sarampo')
ON DUPLICATE KEY UPDATE nome=VALUES(nome), idade=VALUES(idade), cidade=VALUES(cidade), CPF=VALUES(CPF), doenca=VALUES(doenca);

INSERT INTO Consultas VALUES
(1, 1, '2006-06-12', '14:00:00'),
(1, 4, '2006-06-13', '10:00:00'),
(2, 1, '2006-06-13', '09:00:00'),
(2, 2, '2006-06-13', '11:00:00'),
(2, 3, '2006-06-14', '14:00:00'),
(2, 4, '2006-06-14', '17:00:00')
ON DUPLICATE KEY UPDATE data=VALUES(data), hora=VALUES(hora);

-- Atualizações no banco de dados
UPDATE Pacientes SET cidade = 'Ilhota' WHERE nome = 'Paulo';
UPDATE Consultas SET hora = '12:00:00', data = '2006-07-04' WHERE codm = 1 AND codp = 4;
UPDATE Pacientes SET idade = idade + 1, doenca = 'cancer' WHERE nome = 'Ana';
UPDATE Consultas SET hora = ADDTIME(hora, '01:30:00') WHERE codm = 3 AND codp = 4;
DELETE FROM Funcionarios WHERE codf = 4;
DELETE FROM Consultas WHERE hora > '19:00:00';
DELETE FROM Pacientes WHERE doenca = 'cancer' OR idade < 10;
DELETE FROM Medicos WHERE cidade IN ('Biguacu', 'Palhoca');