library(dplyr)

base_path <- "/mnt/data/dortega/vcabrera/output/Phen_vs_Regions"

# Buscar archivos correctos
archivos <- list.files(
  path = base_path,
  pattern = "^Phen_vs_Regions_(3|5|10)\\.[0-9]+\\.csv$",
  full.names = TRUE
)

# Crear carpeta de salida
dir.create(file.path(base_path, "plots"), showWarnings = FALSE)

# Abrir PDF multipágina
pdf(file.path(base_path, "plots/Phen_vs_Regions_all.pdf"),
    width = 8, height = 6)

for (archivo in archivos) {

  datos <- read.table(
    archivo,
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
  )

  # Verificar columnas esperadas
  columnas_esperadas <- c("Ind_ID", "PosInd_X", "PosInd_Y", "MutEffect", "Region")
  if (!all(columnas_esperadas %in% colnames(datos))) {
    next
  }

  # Transformaciones
  datos$MutEffect <- abs(as.numeric(datos$MutEffect))
  datos$Region <- factor(datos$Region)

  # Resumen por región
  resumen <- datos %>%
    group_by(Region) %>%
    summarise(
      media_MutEffect = mean(MutEffect, na.rm = TRUE),
      n = n(),
      .groups = "drop"
    )

  cat("Archivo:", basename(archivo), "\n")
  print(resumen)

  # Boxplot
  boxplot(
    MutEffect ~ Region,
    data = datos,
    main = paste("Efecto mutacional por región\nArchivo:", basename(archivo)),
    xlab = "Región",
    ylab = "|Mutation Effect|",
    las = 2,
    cex.lab = 1.4,
    col = c("lightblue", "lightgreen", "pink")
  )

  # Añadir medias en rojo
  points(
    x = as.numeric(levels(datos$Region)),
    y = resumen$media_MutEffect,
    col = "red",
    pch = 19
  )
}

dev.off()
