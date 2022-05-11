-- 1) Média salarial por departamento:
SELECT numero_departamento, CAST(AVG(salario) as decimal(10,2))
FROM elmasri.funcionario
GROUP BY numero_departamento;

-- 2) Média salarial dos homens e mulheres:
SELECT
CASE sexo
WHEN 'M' THEN 'Homens'
WHEN 'F' THEN 'Mulheres'
ELSE ''
END sexo,
CAST(AVG(salario) AS DECIMAL(10,2))
FROM elmasri.funcionario
GROUP BY sexo;


-- 3) Relatório dos departamentos com informações dos funcionários:
SELECT
	d.numero_departamento,
	d.nome_departamento,
	CONCAT(f.primeiro_nome,' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
	f.data_nascimento,
	date_part('year', age(data_nascimento))::int AS idade,
	f.salario
FROM elmasri.departamento d, elmasri.funcionario f;



-- 4) Relatório com o nome completo, idade, salario atual e salário com reajuste:
   -- Critério do reajuste: se o salário atual for inferior a 35 mil, recebe um reajuste de 20% e se o salário atual for igual ou superior a 35.000, recebe reajuste de 15%.
SELECT 
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
DATE_PART('year', age(data_nascimento))::int AS idade,
salario AS salario_atual, 
salario *1.20 AS salario_reajustado
 FROM elmasri.funcionario f
 WHERE salario < 35000 
 UNION
SELECT 
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_completo,
DATE_PART('year', age(data_nascimento))::int AS idade,
salario AS salario_atual,
salario *1.15 AS salario_reajustado
 FROM elmasri.funcionario f
 WHERE salario >= 35000;


-- 5) Relatório que liste, para cada departamento colocar nome do gerente e o nome dos funcionários. Ordenar por nome departamento (em ordem crescente) e por salário dos funcionários (em ordem decrescente).
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


-- 6) Relatório que mostra o nome completo dos funcionários que têm dependente dependentes, o departamento onde eles trabalham, e para cada funcionário, liste o nome completo dos dependentes, a idade em anos de cada dependente e o sexo (sexo deve ser "Masculino" e "Feminino).
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


-- 7)Relatório que mostre, para cada funcionário que NÃO TEM dependente, seu nome completo, departamento e salário.
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionario,
	f.numero_departamento AS departamento,
	f.salario AS salario
FROM elmasri.funcionario f
EXCEPT
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionario,
	f.numero_departamento AS departamento,
	f.salario AS salario
FROM elmasri.dependente dp
INNER JOIN elmasri.funcionario f ON (dp.cpf_funcionario=f.cpf);


-- 8) Relatório que mostre, para cada departamento os projetos e o nome completo dos funcionários alocados. Além de incluir o número de horas trabalhadas por cada um.
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

-- 9) Relatório que mostre a soma total das horas de cada projeto em cada departamento. Obs.: o relatório deve exibir o nome do departamento, o nome do projeto e a soma total das horas.
SELECT
	d.nome_departamento AS departamento,
	p.nome_projeto AS projeto,
	SUM(tm.horas) AS horas
FROM elmasri.trabalha_em tm
INNER JOIN elmasri.projeto p ON (p.numero_projeto=tm.numero_projeto)
INNER JOIN elmasri.departamento d ON (d.numero_departamento=p.numero_departamento)
GROUP BY d.numero_departamento, p.nome_projeto
ORDER BY d.nome_departamento;

-- 10)Relatório que mostre a média salarial dos funcionários de cada departamento.
SELECT
    d.nome_departamento,
    CAST(AVG(salario) as decimal(10,2))
FROM elmasri.departamento d, elmasri.funcionario f
WHERE f.numero_departamento=d.numero_departamento
GROUP BY d.nome_departamento;


-- 11) Considerando que o valor pago por hora trabalhada em um projeto é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas naquele projeto.
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionario,
	p.nome_projeto AS projeto,
	tm.horas*50 AS horas
FROM elmasri.trabalha_em tm
INNER JOIN elmasri.projeto p ON p.numero_projeto=tm.numero_projeto
INNER JOIN elmasri.funcionario f ON f.cpf=tm.cpf_funcionario
GROUP BY funcionario, p.nome_projeto, tm.horas
ORDER BY funcionario;


-- 12) Relatório que liste o nome do departamento, nome do projeto e o nome dos funcionários que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada.
SELECT
	d.nome_departamento AS departamento,
	p.nome_projeto AS porjeto,
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionario
FROM elmasri.funcionario f, elmasri.trabalha_em tm, elmasri.projeto p, elmasri.departamento d
WHERE 
	p.numero_departamento=d.numero_departamento
	AND
	tm.cpf_funcionario=f.cpf 
	AND 
	tm.horas is null
ORDER BY d.nome_departamento, p.nome_projeto;


-- 13) A empresa irá presentear todos os funcionários e todos os dependentes. Crie um relatório que liste o nome completo das pessoas a serem presenteadas (funcionários e dependeetes), sexo e a idade. O relatório deve estar ordenado pela idade, de forma descecente.
SELECT 
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome,
	CASE sexo
	WHEN 'M' THEN 'Homens'
	WHEN 'F' THEN 'Mulheres'
	ELSE ''
	END sexo,
	date_part('year', age(data_nascimento))::int AS idade
FROM elmasri.funcionario f
UNION
SELECT
	dp.nome_dependente AS nome,
	CASE sexo
	WHEN 'M' THEN 'Homens'
	WHEN 'F' THEN 'Mulheres'
	ELSE ''
	END sexo,
	date_part('year', age(data_nascimento))::int AS idade
FROM elmasri.dependente dp
ORDER BY idade DESC;


-- 14) Prepare um relatório que exiba quantos funcionários cada departamento tem.
SELECT
	d.numero_departamento AS departamento,
	COUNT(f.cpf) AS numero_funcionarios
FROM elmasri.departamento d
INNER JOIN elmasri.funcionario f ON (f.numero_departamento=d.numero_departamento)
GROUP BY d.numero_departamento
ORDER BY d.numero_departamento;


-- 15) Relatório que exiba o nome completo dos funcionarios que estão em mais de um projeto, departamento e o nome dos projetos em que está alocado.
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionarios,
	d.numero_departamento AS departamento,
	p.nome_projeto AS projeto
FROM elmasri.departamento d
INNER JOIN elmasri.funcionario f ON (f.numero_departamento=d.numero_departamento)
INNER JOIN elmasri.projeto p ON (p.numero_departamento=d.numero_departamento)
EXCEPT
SELECT
	CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS funcionarios,
	d.numero_departamento AS departamento,
	p.nome_projeto AS projeto
FROM elmasri.departamento d
INNER JOIN elmasri.funcionario f ON (f.numero_departamento='1')
INNER JOIN elmasri.projeto p ON (p.numero_departamento='1')
ORDER BY 1,3;
