# app_dbt — Guia de Desenvolvimento

Projeto de estudo de dbt. Tudo containerizado, nada roda local (mesma regra dos outros projetos deste workspace).

## Pré-requisito
`toolData_postgre` precisa estar de pé (`docker compose up -d` dentro dele) — este projeto se conecta nele pela rede externa `tooldata_postgre_postgres_network`.

## Comandos
```bash
docker compose build
docker compose run --rm dbt debug
docker compose run --rm dbt seed
docker compose run --rm dbt run
docker compose run --rm dbt test
docker compose run --rm dbt docs generate
docker compose run --rm -p 8080:8080 dbt docs serve --host 0.0.0.0 --port 8080
```

## Estrutura
- `seeds/` — CSV de exemplo carregado como tabela
- `models/staging/` — views de limpeza/tipagem (1 por fonte)
- `models/marts/` — tabelas finais agregadas
- `macros/` — Jinja reutilizável entre models
- cada pasta de `models/` tem seu `schema.yml` com os testes

## Ao adicionar um novo model
1. Criar o `.sql` na camada certa (`staging` só limpa, `marts` agrega/serve)
2. Adicionar a descrição e os testes no `schema.yml` da mesma pasta
3. Rodar `dbt run` + `dbt test` antes de considerar pronto
