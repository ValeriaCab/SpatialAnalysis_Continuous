library(ggplot2)
library(dplyr)

# Ruta base
base_path <- "/mnt/data/dortega/vcabrera/output/Freq_vs_MutEffect"

# Buscar solo archivos numerados
archivos <- list.files(
  path = base_path,
  pattern = "^Freq_vs_MutEffect\\.[0-9]+\\.csv$",
  full.names = TRUE
)

# Ordenar 1–50 correctamente
archivos <- archivos[
  order(as.numeric(sub(".*\\.(\\d+)\\.csv", "\\1", archivos)))
]

# Crear carpeta de salida
dir.create(file.path(base_path, "plots"), showWarnings = FALSE)

# Abrir PDF
pdf(file.path(base_path, "plots/Freq_vs_MutEffect_all.pdf"), width = 8, height = 6)

for (archivo in archivos) {

  datos <- read.table(
    archivo,
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
  )

  # Verificar que existan columnas correctas
  if (!all(c("Freq", "MutEffect") %in% colnames(datos))) {
    next
  }

  # Quitar Freq = 1
  datos <- datos %>% filter(Freq != 1)

  if (nrow(datos) == 0) next

  # Valor absoluto solo del efecto
  datos <- datos %>%
    mutate(MutEffect = abs(MutEffect))

  # Crear bins dinámicos
  max_effect <- max(datos$MutEffect, na.rm = TRUE)

  datos$region <- cut(
    datos$MutEffect,
    breaks = c(0, 0.05, 0.1, 0.2, max_effect),
    labels = c("0–0.05", "0.05–0.1", "0.1–0.2", ">0.2"),
    include.lowest = TRUE
  )

  datos <- datos %>% filter(!is.na(region))

  p <- ggplot(datos, aes(x = region, y = Freq)) +
    geom_boxplot(fill = "red", alpha = 0.7, outlier.alpha = 0.3) +
    labs(
      title = paste0("Archivo: ", basename(archivo)),
      x = "|Mutation Effect|",
      y = "Frequency"
    ) +
    theme_minimal(base_size = 15) +
    theme(
      axis.title = element_text(face = "bold")
    )

  print(p)
}

dev.off()
