CREATE DATABASE Oficina;
USE Oficina;

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL
);

CREATE TABLE EquipeMecanicos (
    idEquipeMecanicos INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    ListaMecanicos VARCHAR(255)
);

CREATE TABLE OS (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    Cliente_idCliente INT NOT NULL,
    EquipeMecanicos_idEquipeMecanicos INT,
    dataEmissao DATE NOT NULL,
    dataConclusao DATE,
    Status VARCHAR(45) DEFAULT 'Aberto',
    Valor FLOAT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (EquipeMecanicos_idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos)
);

CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Cliente_idCliente INT NOT NULL,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Especialidade VARCHAR(45),
    EquipeMecanicos_idEquipeMecanicos INT,
    FOREIGN KEY (EquipeMecanicos_idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos)
);

CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    Valor FLOAT NOT NULL,
    OS_idOS INT NOT NULL,
    EquipeMecanicos_idEquipeMecanicos INT,
    FOREIGN KEY (OS_idOS) REFERENCES OS(idOS),
    FOREIGN KEY (EquipeMecanicos_idEquipeMecanicos) REFERENCES EquipeMecanicos(idEquipeMecanicos)
);

CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Categoria VARCHAR(45),
    Descricao VARCHAR(255),
    Valor FLOAT NOT NULL,
    OS_idOS INT NOT NULL,
    FOREIGN KEY (OS_idOS) REFERENCES OS(idOS)
);

-- Inserção de dados fictícios

INSERT INTO Cliente (Nome) VALUES 
('João Silva'),
('Maria Oliveira'),
('Carlos Souza');

INSERT INTO Veiculo (Cliente_idCliente) VALUES 
(1),
(2),
(3);

INSERT INTO EquipeMecanicos (Nome, ListaMecanicos) VALUES 
('Equipe A', 'Carlos, João'),
('Equipe B', 'Maria, Pedro');

INSERT INTO OS (Cliente_idCliente, EquipeMecanicos_idEquipeMecanicos, dataEmissao, Status, Valor) VALUES 
(1, 1, '2025-01-01', 'Aberto', 500.00),
(2, 2, '2025-01-02', 'Concluído', 700.00);

INSERT INTO Mecanico (Nome, Endereco, Especialidade, EquipeMecanicos_idEquipeMecanicos) VALUES 
('Carlos Lima', 'Rua 1', 'Suspensão', 1),
('Maria Costa', 'Rua 2', 'Motor', 2);

INSERT INTO Servico (Descricao, Valor, OS_idOS, EquipeMecanicos_idEquipeMecanicos) VALUES 
('Troca de Óleo', 150.00, 1, 1),
('Reparo no Motor', 350.00, 2, 2);

INSERT INTO Peca (Nome, Categoria, Descricao, Valor, OS_idOS) VALUES 
('Filtro de Óleo', 'Motor', 'Filtro de Óleo para Motor', 50.00, 1),
('Velas de Ignição', 'Motor', 'Velas de Alta Performance', 100.00, 2);

-- Consultas

SELECT Cliente.Nome, Veiculo.idVeiculo
FROM Cliente
INNER JOIN Veiculo ON Cliente.idCliente = Veiculo.Cliente_idCliente;

SELECT * 
FROM OS 
WHERE Status = 'Aberto';

SELECT OS.idOS, 
       SUM(IFNULL(Servico.Valor, 0) + IFNULL(Peca.Valor, 0)) AS ValorTotal
FROM OS
LEFT JOIN Servico ON OS.idOS = Servico.OS_idOS
LEFT JOIN Peca ON OS.idOS = Peca.OS_idOS
GROUP BY OS.idOS;

SELECT * 
FROM Mecanico 
ORDER BY Especialidade ASC;

SELECT EquipeMecanicos.Nome, 
       SUM(OS.Valor) AS ValorTotal
FROM EquipeMecanicos
INNER JOIN OS ON EquipeMecanicos.idEquipeMecanicos = OS.EquipeMecanicos_idEquipeMecanicos
GROUP BY EquipeMecanicos.Nome
HAVING SUM(OS.Valor) > 600;

SELECT Mecanico.Nome AS NomeMecanico, 
       Servico.Descricao AS ServicoRealizado, 
       Servico.Valor AS ValorServico
FROM Mecanico
INNER JOIN EquipeMecanicos ON Mecanico.EquipeMecanicos_idEquipeMecanicos = EquipeMecanicos.idEquipeMecanicos
INNER JOIN Servico ON EquipeMecanicos.idEquipeMecanicos = Servico.EquipeMecanicos_idEquipeMecanicos;
