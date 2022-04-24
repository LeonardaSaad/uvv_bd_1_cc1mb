CREATE USER leonardas@localhost;

create database uvv;

create schema elmasri;

grant all privileges on *.* to leonardas@localhost with grant option;

flush privileges;

exit;

mysql -u leonardas@localhost

use uvv;

CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);

ALTER TABLE funcionario COMMENT 'Tabela "funcionario" cont�m todas as informa��es dos funcion�rios, como o cpf, nome, data de nascimento, endere�o, sexo, sal�rio, cpf do supervisor que nesse caso tamb�m est� na tabela funcion�rio, al�m do n�mero do departamento em que ele trabalha.';


CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);

ALTER TABLE departamento COMMENT 'Tabela "departamento" cont�m informa��es sobre o departamento, sendo elas o n�mero e o nome dele, cpf do gerente, data que come�ou o gerente.';


CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(150),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);

ALTER TABLE projeto COMMENT 'Tabela "projeto" nele tem as informa��es sobre os projetos desenvolvidos, como o n�mero, nome, local do projeto, al�m do departamento respons�vel por ele.';

ALTER TABLE projeto MODIFY COLUMN nome_projeto VARCHAR(15) COMMENT 'Cria��o da UNIQUE KEY ou ALTERNATE KEY no atributo "nome_projeto".';


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);

ALTER TABLE localizacoes_departamento COMMENT 'Tabela "localizacoes_departamento" cont�m o n�mero do departamento e o local.';


CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto)
);

ALTER TABLE trabalha_em COMMENT 'Tabela "trabalha_em" � respons�vel por armazenar em que projeto cada funcion�rio trabalha, sendo os atributos o cpf do funcion�rio, o nome do projeto que ele trabalha e as horas.';


CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                PRIMARY KEY (cpf_funcionario, nome_dependente)
);

ALTER TABLE dependente COMMENT 'Tabela "dependente" mostra os dependentes associados a cada funcion�rio. Os atributos da tabela s�o cpf do funcion�rio, nome, sexo, data de nascimento e parentesco dos dependentes.';

INSERT INTO funcionario
VALUES 
(88866555576,'Jorge','E','Brito','10-11-1937','R. do Horto,35,S�o Paulo,SP','M',55000,NULL,1),
(33344555587,'Fernando','T','Wong','08-12-1955','R. da Lapa,34,S�o Paulo,SP','M',40000,88866555576,5),
(12345678966,'Jo�o','B','Silva','09-01-1965','R. das flores,751,S�o Paulo,SP','M',30000,33344555587,5),
(98765432168,'Jennifer','S','Souza','06-20-1941','Av.Arthur de L.,54,Santo A.,SP','F',43000,88866555576,4),
(99988777767,'Alice','J','Zelaya','01-19-1968','R.Souza Lima,35,Curitiba,PR','F',25000,98765432168,4),
(6688444476,'Ronaldo','K','Lima','09-15-1962','R.Rebou�as,65, Piracaba,SP','M',38000,33344555587,5),
(45345345376,'Joice','A','Leite','07-31-1972','Av.Lucas Obes,74,SP,SP','F',25000,33344555587,5),
(98798798733,'Andr�','V','Pereira','03-29-1969','R.Timbira,35,SP,SP','M',25000,98765432168,4);

INSERT INTO departamento
VALUES
(5,'Pesquisa',33344555587,'05-22-1988'),
(4,'Administra��o',98765432168,'01-01-1995'),
(1,'Matriz',88866555576,'06-19-1981');

INSERT INTO localizacoes_departamento
VALUES
(5,'Santo Andr�'),
(5,'Itu'),
(5,'S�o Paulo'),
(4,'Mau�'),
(1,'S�o Paulo');

INSERT INTO projeto
VALUES
(1,'ProdutoX','Santo Andr�',5),
(2,'ProdutoY','Itu',5),
(3,'ProdutoZ','S�o Paulo',5),
(10,'Informatiza��o','Mau�',4),
(20,'Reorganiza��o','S�o Paulo',1),
(30,'Novosbenef�cios','Mau�',4);

INSERT INTO dependente
VALUES
(33344555587,'Alicia','F','05-04-1986','Filha'),
(33344555587,'Tiago','M','10-25-1983','Filho'),
(33344555587,'Jana�na','F','03-05-1958','Esposa'),
(98765432168,'Antonio','M','02-28-1942','Marido'),
(12345678966,'Michael','M','04-01-1988','Filho'),
(12345678966,'Alicia','F','12-30-1988','Filha'),
(12345678966,'Elizabeth','F','05-05-1967','Esposa');

INSERT INTO trabalha_em
VALUES
(12345678966,1,32.5),
(12345678966,2,7.5),
(6688444476,3,40.0),
(45345345376,1,20.0),
(45345345376,2,20.0),
(33344555587,2,10.0),
(33344555587,3,10.0),
(33344555587,10,10.0),
(33344555587,20,10.0),
(99988777767,30,30.0),
(99988777767,10,10.0),
(98798798733,10,35.0),
(98798798733,30,5.0),
(98765432168,30,20.0),
(98765432168,20,15.0),
(88866555576,20,NULL);

ALTER TABLE funcionario ADD CONSTRAINT funcionario_ph_funcionario_ph_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE dependente ADD CONSTRAINT funcionario_ph_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_ph_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionaro_ph_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;