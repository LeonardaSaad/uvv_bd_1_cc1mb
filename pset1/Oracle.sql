
CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR2(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR2(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR2(30),
                sexo CHAR(1),
                salario NUMBER(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento NUMBER NOT NULL,
                CONSTRAINT FUNCIONARIO__PK PRIMARY KEY (cpf)
);
COMMENT ON TABLE elmasri.funcionario IS 'Tabela ''funcionario'' cont�m todas as informa��es dos funcion�rios, como o cpf, nome, data de nascimento, endere�o, sexo, sal�rio, cpf do supervisor que nesse caso tamb�m est� na tabela funcion�rio, al�m do n�mero do departamento em que ele trabalha.';


CREATE TABLE elmasri.departamento (
                numero_departamento NUMBER NOT NULL,
                nome_departamento VARCHAR2(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT DEPARTAMENTO_PK PRIMARY KEY (numero_departamento)
);
COMMENT ON TABLE elmasri.departamento IS 'Tabela ''departamento'' cont�m informa��es sobre o departamento, sendo elas o n�mero e o nome dele, cpf do gerente, data que come�ou o gerente.';


CREATE TABLE elmasri.projeto (
                numero_projeto NUMBER NOT NULL,
                nome_projeto VARCHAR2(15) NOT NULL,
                local_projeto VARCHAR2(150),
                numero_departamento NUMBER NOT NULL,
                CONSTRAINT PROJETO_PK PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE elmasri.projeto IS 'Tabela ''projeto'' nele tem as informa��es sobre os projetos desenvolvidos, como o n�mero, nome, local do projeto, al�m do departamento respons�vel por ele.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Cria��o da UNIQUE KEY ou ALTERNATE KEY no atributo ''nome_projeto''.';


CREATE UNIQUE INDEX elmasri.projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento NUMBER NOT NULL,
                local VARCHAR2(15) NOT NULL,
                CONSTRAINT LOCALIZACOES_DEPARTAMENTO_PK PRIMARY KEY (numero_departamento, local)
);
COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela ''localizacoes_departamento'' cont�m o n�mero do departamento e o local.';


CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto NUMBER NOT NULL,
                horas NUMBER(3,1) NOT NULL,
                CONSTRAINT TRABALHA_EM_PK PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela ''trabalha_em'' � respons�vel por armazenar em que projeto cada funcion�rio trabalha, sendo os atributos o cpf do funcion�rio, o nome do projeto que ele trabalha e as horas.';


CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR2(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR2(15),
                CONSTRAINT DEPENDENTE_PK PRIMARY KEY (cpf_funcionario, nome_dependente)
);
COMMENT ON TABLE elmasri.dependente IS 'Tabela ''dependente'' mostra os dependentes associados a cada funcion�rio. Os atributos da tabela s�o cpf do funcion�rio, nome, sexo, data de nascimento e parentesco dos dependentes.';


ALTER TABLE elmasri.funcionario ADD CONSTRAINT FUNCIONARIO_PH_FUNCIONARIO_717
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
NOT DEFERRABLE;

ALTER TABLE elmasri.dependente ADD CONSTRAINT FUNCIONARIO_PH_DEPENDENTE_FK
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT FUNCIONARIO_PH_TRABALHA_EM_FK
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
NOT DEFERRABLE;

ALTER TABLE elmasri.departamento ADD CONSTRAINT FUNCIONARO_PH_DEPARTAMENTO_FK
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
NOT DEFERRABLE;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT DEPARTAMENTO_LOCALIZACOES_D323
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
NOT DEFERRABLE;

ALTER TABLE elmasri.projeto ADD CONSTRAINT DEPARTAMENTO_PROJETO_FK
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT PROJETO_TRABALHA_EM_FK
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
NOT DEFERRABLE;
