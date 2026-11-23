# PCO207 - PCA de propriedades geotecnicas de solos
# Base: https://doi.org/10.5281/zenodo.20737271

pacotes <- c("FactoMineR", "factoextra", "ggplot2")
for (p in pacotes) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p, repos = "https://cloud.r-project.org")
  }
}

# Caminhos relativos a pasta do projeto
caminhos <- c(file.path("dados", "solos_CBR.csv"),
              file.path("..", "dados", "solos_CBR.csv"))
arquivo <- caminhos[file.exists(caminhos)][1]
if (is.na(arquivo)) stop("Arquivo dados/solos_CBR.csv nao encontrado.")

raiz <- normalizePath(file.path(dirname(arquivo), ".."), mustWork = TRUE)
saida <- file.path(raiz, "resultados")
dir.create(saida, recursive = TRUE, showWarnings = FALSE)

# Seleção inicial: registros inconsistentes de compactacao sao excluidos
dados <- read.csv(arquivo)
dados <- dados[!(dados$linha_excel %in% 179:198), ]

# Variaveis ativas: granulometria e compactacao
variaveis <- c("G", "FC", "MDD", "OMC")
matriz <- dados[, variaveis]
stopifnot(nrow(matriz) == 362, !anyNA(matriz))

# PCA com variaveis padronizadas
pca <- FactoMineR::PCA(matriz, scale.unit = TRUE, graph = FALSE)
eixos <- sprintf("PC%d (%.2f%%)", 1:2, pca$eig[1:2, 2])

tema <- ggplot2::theme_minimal(base_size = 13)
salvar <- function(grafico, nome) {
  ggplot2::ggsave(file.path(saida, nome), grafico,
                  width = 10, height = 7, dpi = 260, bg = "white")
  print(grafico)
}

# 1. Variancia explicada
g1 <- factoextra::fviz_eig(pca, addlabels = TRUE,
                          barfill = "#2563EB", barcolor = "#1D4ED8") +
  ggplot2::labs(title = "Variancia explicada",
                x = "Componente principal", y = "Variancia (%)") + tema
salvar(g1, "01_variancia.png")

# 2. Circulo de correlacoes das variaveis
g2 <- factoextra::fviz_pca_var(
  pca, axes = c(1, 2), col.var = "#164E63", repel = TRUE
) + ggplot2::labs(title = "Variaveis no plano PC1-PC2",
                  x = eixos[1], y = eixos[2]) + tema
salvar(g2, "02_variaveis.png")

# 3. Biplot inicial: amostras em cinza e setas das variaveis
g3 <- factoextra::fviz_pca_biplot(
  pca, axes = c(1, 2), geom.ind = "point", label = "var",
  col.ind = "grey65", col.var = "#164E63", repel = TRUE
) + ggplot2::labs(title = "Biplot inicial",
                  x = eixos[1], y = eixos[2]) + tema
salvar(g3, "03_biplot.png")

cat(sprintf("\nAmostras: %d | PC1: %.2f%% | PC2: %.2f%% | PC1+PC2: %.2f%%\n",
            nrow(matriz), pca$eig[1, 2], pca$eig[2, 2],
            pca$eig[2, 3]))
cat("Graficos salvos em:", saida, "\n")
