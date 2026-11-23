# PCA de propriedades geotecnicas de solos

Aplicacao inicial de Analise de Componentes Principais (PCA) com R, desenvolvida para a disciplina PCO207.

## Dados e variaveis

A base contem propriedades geotecnicas de solos e esta disponivel em [Zenodo](https://doi.org/10.5281/zenodo.20737271).

A analise utiliza 362 amostras e quatro variaveis ativas:

- **G:** teor de pedregulho
- **FC:** teor de finos
- **MDD:** massa especifica seca maxima
- **OMC:** teor de umidade otima

Os registros de identificacao 179 a 198 foram excluidos por apresentarem valores de compactacao inconsistentes com o restante da base. A base CSV original permanece preservada. As variaveis sao padronizadas antes da PCA.

## Executar

1. Abrir o projeto no RStudio (pasta raiz do repositorio).
2. Executar o arquivo `scripts/analise_pca.R`.

Os pacotes `FactoMineR`, `factoextra` e `ggplot2` sao instalados automaticamente quando necessario.

## Resultados

Os arquivos PNG sao gerados na pasta `resultados/`:

- `01_variancia.png` — percentual de variancia explicada por componente.
- `02_variaveis.png` — circulo de correlacoes das variaveis.
- `03_biplot.png` — amostras e vetores das variaveis no plano PC1-PC2.

O CBR consta na base, mas nao e utilizado nesta primeira PCA. O script nao gera resultados de comparacao de cenarios nem de analise de sensibilidade.
