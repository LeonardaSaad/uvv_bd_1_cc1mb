
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
COMMENT ON TABLE elmasri.funcionario IS 'Tabela ''funcionario'' contém todas as informações dos funcionários, como o cpf, nome, data de nascimento, endereço, sexo, salário, cpf do supervisor que nesse caso também está na tabela funcionário, além do número do departamento em que ele trabalha.';


CREATE TABLE elmasri.departamento (
                numero_departamento NUMBER NOT NULL,
                nome_departamento VARCHAR2(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT DEPARTAMENTO_PK PRIMARY KEY (numero_departamento)
);
COMMENT ON TABLE elmasri.departamento IS 'Tabela ''departamento'' contém informações sobre o departamento, sendo elas o número e o nome dele, cpf do gerente, data que começou o gerente.';


CREATE TABLE elmasri.projeto (
                numero_projeto NUMBER NOT NULL,
                nome_projeto VARCHAR2(15) NOT NULL,
                local_projeto VARCHAR2(150),
                numero_departamento NUMBER NOT NULL,
                CONSTRAINT PROJETO_PK PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE elmasri.projeto IS 'Tabela ''projeto'' nele tem as informações sobre os projetos desenvolvidos, como o número, nome, local do projeto, além do departamento responsável por ele.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Criação da UNIQUE KEY ou ALTERNATE KEY no atributo ''nome_projeto''.';


CREATE UNIQUE INDEX elmasri.projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento NUMBER NOT NULL,
                local VARCHAR2(15) NOT NULL,
                CONSTRAINT LOCALIZACOES_DEPARTAMENTO_PK PRIMARY KEY (numero_departamento, local)
);
COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela ''localizacoes_departamento'' contém o número do departamento e o local.';


CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto NUMBER NOT NULL,
                horas NUMBER(3,1) NOT NULL,
                CONSTRAINT TRABALHA_EM_PK PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela ''trabalha_em'' é responsável por armazenar em que projeto cada funcionário trabalha, sendo os atributos o cpf do funcionário, o nome do projeto que ele trabalha e as horas.';


CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR2(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR2(15),
                CONSTRAINT DEPENDENTE_PK PRIMARY KEY (cpf_funcionario, nome_dependente)
);
COMMENT ON TABLE elmasri.dependente IS 'Tabela ''dependente'' mostra os dependentes associados a cada funcionário. Os atributos da tabela são cpf do funcionário, nome, sexo, data de nascimento e parentesco dos dependentes.';


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
