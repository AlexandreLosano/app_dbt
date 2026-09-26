# app_dbt — Estudo de dbt (Data Build Tool)

Projeto pessoal de estudo, montado do zero pra aprender dbt na prática. Não é um produto: é uma vendas fictícia pequena, transformada em camadas (staging → marts) com testes de qualidade, rodando em cima do Postgres do [`toolData_postgre`](../toolData_postgre).

## O que é dbt, resumido

dbt pega SQL que hoje viveria solto em scripts e organiza em um projeto versionado: cada tabela/view vira um "model" (um arquivo `.sql`), os models podem depender uns dos outros (`{{ ref('outro_model') }}`), e cada um pode ter testes de qualidade declarados em YAML (`not_null`, `unique`, `accepted_values`). Ele não processa dado — só gera e roda o SQL certo, na ordem certa, dentro do banco.

## Arquitetura deste projeto

```
seeds/vendas.csv                    → CSV de exemplo, carregado como tabela via `dbt seed`
  └─ models/staging/stg_vendas.sql  → normaliza tipos e calcula valor total por pedido
       └─ models/marts/fct_vendas_diarias.sql → receita e nº de pedidos concluídos, por dia e categoria
```

- **seeds/**: dado de exemplo (pedidos fictícios) carregado direto no banco
- **models/staging/**: uma view por fonte, só limpando/tipando — não agrega nada
- **models/marts/**: tabela final, agregada, pronta pra consumo (dashboard, análise)
- **macros/only_completed.sql**: macro reutilizável (`{{ only_completed('status') }}`) que gera a condição `status = 'completed'`, usada no mart
- **models/\*/schema.yml**: testes de qualidade em cada camada

## Pré-requisitos

- Docker + Docker Compose
- O [`toolData_postgre`](../toolData_postgre) rodando (`docker compose up -d` dentro dele) — este projeto se conecta nele pela rede `tooldata_postgre_postgres_network`

## Como rodar

```bash
cp .env.example .env
# edite .env com o mesmo POSTGRES_USER/PASSWORD/DB do toolData_postgre

docker compose build

docker compose run --rm dbt debug   # testa a conexão
docker compose run --rm dbt seed    # carrega seeds/vendas.csv no banco
docker compose run --rm dbt run     # constrói staging + marts
docker compose run --rm dbt test    # roda os testes de qualidade
```

Os dados ficam em 3 schemas no Postgres: `dbt_estudo_raw` (seed), `dbt_estudo_staging` (views), `dbt_estudo_marts` (tabela final).

### Ver a documentação/lineage gerada pelo dbt

```bash
docker compose run --rm dbt docs generate
docker compose run --rm -p 8080:8080 dbt docs serve --host 0.0.0.0 --port 8080
```

## O que este projeto exercita

- Seeds, models (view/table), `ref()` e ordem de execução por dependência
- Testes genéricos (`not_null`, `unique`, `accepted_values`)
- Macros Jinja reutilizáveis
- Configuração de schema/materialização por camada (`dbt_project.yml`)
- Empacotamento em Docker, sem instalar nada local (mesma linha dos outros projetos deste workspace)
