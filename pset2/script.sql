-- 1) M�dia salarial por departamento:
SELECT numero_departamento, CAST(AVG(salario) as decimal(10,2))
FROM elmasri.funcionario
GROUP BY numero_departamento;

-- 2) M�dia salarial dos homens e mulheres:
SELECT
CASE sexo
WHEN 'M' THEN 'Homens'
WHEN 'F' THEN 'Mulheres'
ELSE ''
END sexo,
CAST(AVG(salario) AS DECIMAL(10,2))
FROM elmasri.funcionario
GROUP BY sexo;


-- 3) Relat�rio dos departamentos com informa��es dos funcion�rios:
SELECT
	d.numero_departamento,
	d.nome_departamento,
	CONCAT(f.primeiro_nome,' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
	f.data_nascimento,
	date_part('year', age(data_nascimento))::int AS idade,
	f.salario
FROM elmasri.departamento d, elmasri.funcionario f;



-- 4) Relat�rio com o nome completo, idade, salario atual e sal�rio com reajuste:
   -- Crit�rio do reajuste: se o sal�rio atual for inferior a 35 mil, recebe um reajuste de 20% e se o sal�rio atual for igual ou	superior a 35.000, recebe reajuste de 15%.
SELECT 
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
DATE_PART('year', age(data_nascimento))::int AS idade,
salario AS salario_atual, 
salario *1.20 AS salario_reajustado
 FROM elmasri.funcionario f
 WHERE salario < 35000 
 UNION
SELECT 
CONCAR(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
DATE_PART('year', age(data_nascimento))::int AS idade,
salario AS salario_atual,
salario *1.15 AS salario_reajustado
 FROM elmasri.funcionario f
 WHERE salario >= 35000;


-- 5) Relat�rio que liste, para cada departamento colocar nome do gerente e o nome dos funcion�rios. Ordenar por nome departamento (em ordem crescente) e por sal�rio dos funcion�rios (em ordem decrescente).
WITH gerente AS (SELECT
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome,
 	f.cpf 
FROM elmasri.funcionario f)
SELECT
d.nome_departamento,
g.nome AS nome_gerente,
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_funcionario,
 	salario
 FROM elmasri.departamento d
 INNER JOIN elmasri.funcionario f ON f.numero_departamento = d.numero_departamento
 INNER JOIN gerente g ON g.cpf = d.cpf_gerente
 ORDER BY d.nome_departamento ASC, f.salario DESC;


-- 6) Relat�rio que mostra o nome completo dos funcion�rios que t�m dependente dependentes, o departamento onde eles trabalham, e para cada funcion�rio, liste o nome completo dos dependentes, a idade em anos de cada dependente e o sexo (sexo deve ser "Masculino" e "Feminino).
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionario,
	d.nome_departamento AS departamento,
	dp.nome_dependente AS dependentes,
	date_part('year', age(dp.data_nascimento))::int AS idade,
	CASE dp.sexo
	WHEN 'M' THEN 'Homem'
	WHEN 'F' THEN 'Mulher'
	ELSE ''
	END sexo
FROM elmasri.funcionario f, elmasri.dependente dp, elmasri.departamento d
WHERE
	(f.cpf = dp.cpf_funcionario)
	AND
	(f.numero_departamento = d.numero_departamento);


-- 7)Relat�rio que mostre, para cada funcion�rio que N�O TEM dependente, seu nome completo, departamento e sal�rio.
SELECT DISTINCT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionarios,
	f.numero_departamento AS numero_d,
	d.nome_departamento AS departamento,
	f.salario AS salario
FROM elmasri.funcionario f, elmasri.dependente dp, elmasri.departamento d
WHERE EXISTS (SELECT *
      FROM elmasri.dependente dp, elmasri.funcionario f
      WHERE f.cpf!=dp.cpf_funcionario)
	AND
	f.numero_departamento=d.numero_departamento;


-- 8) Relat�rio que mostre, para cada departamento os projetos e o nome completo dos funcion�rios alocados. Al�m de incluir o n�mero de horas trabalhadas por cada um.
SELECT
    d.nome_departamento AS departamentos,
    p.nome_projeto as projetos,
    CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionarios,
    tm.horas AS horas_trab
FROM elmasri.departamento d, elmasri.projeto p, elmasri.funcionario f, elmasri.trabalha_em tm
WHERE
    d.numero_departamento=p.numero_departamento
    AND
    f.numero_departamento=p.numero_departamento
    AND
    p.numero_projeto=tm.numero_projeto
    AND
    f.cpf=tm.cpf_funcionario
ORDER BY p.numero_projeto, f.primeiro_nome;



