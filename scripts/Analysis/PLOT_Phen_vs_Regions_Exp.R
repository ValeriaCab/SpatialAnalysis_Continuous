library(dplyr)

base_path <- "/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/Phen_vs_Region"

archivos <- list.files(
  path = base_path,
  pattern = "^Exp_Phen_vs_Regions_(3|5|10)\\.[12]+\\.csv$",
  full.names = TRUE
)

dir.create(
  file.path(base_path, "plots_exp"),
  showWarnings = FALSE
)

pdf(
  file.path(base_path, "plots_exp/Phen_vs_Regions_exp_12.pdf"),
  width = 8,
  height = 6
)

for (archivo in archivos) {

  datos <- read.table(
    archivo,
    header = TRUE,
    sep = "\t",
    stringsAsFactors = FALSE
  )

  columnas_esperadas <- c(
    "Ind_ID",
    "PosInd_X",
    "PosInd_Y",
    "PhenValue",
    "Region"
  )

  if (!all(columnas_esperadas %in% colnames(datos))) {
    next
  }

  datos$PhenValue <- as.numeric(datos$PhenValue)
  datos$Region <- factor(datos$Region)

  # Promedio de PhenValue por región
  resumen <- datos %>%
    group_by(Region) %>%
    summarise(
      media_Phen = mean(PhenValue, na.rm = TRUE),
      n = n(),
      .groups = "drop"
    )

  cat("Archivo:", basename(archivo), "\n")
  print(resumen)

  # Boxplot
  boxplot(
    PhenValue ~ Region,
    data = datos,
    main = paste(
      "Fenotipo por región\nArchivo:",
      basename(archivo)
    ),
    xlab = "Region",
    ylab = "Phenotipo",
    las = 2,
    cex.lab = 1.4,
    col = c("lightblue", "lightgreen", "pink")
  )

  # Añadir medias en rojo
  points(
    x = seq_along(resumen$Region),
    y = resumen$media_Phen,
    col = "red",
    pch = 19
  )
}

dev.off()