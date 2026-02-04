# ===============================
# Graficar Freq_vs_MutEffect.*.csv en un solo PDF
# ===============================

library(ggplot2)
library(dplyr)

# Ruta base (ajústala a la tuya)
base_path <- "/mnt/data/dortega/vcabrera/output/Freq_vs_MutEffect"

# Archivos en subcarpetas 1..100
archivos <- sprintf("%s/%d/Freq_vs_MutEffect.%d.csv", base_path, 1:31, 1:31)

# Carpeta de salida
dir.create(file.path(base_path, "plots"), showWarnings = FALSE)

# Abrir un PDF multipágina
pdf(file.path(base_path, "plots/Freq_vs_MutEffect_all.pdf"), width = 8, height = 6)

# Bucle sobre cada archivo
for (archivo in archivos) {
  if (file.exists(archivo)) {
    datos <- read.csv(file = archivo, header = FALSE, sep = "\t")
    
    # Asigna nombres a las columnas
    colnames(datos) <- c("Mutation_Effect", "Frequency")
    
    # Convierte a valores absolutos
    datos <- datos %>%
      mutate(across(where(is.numeric), abs))
    
    # Genera la gráfica
    p <- ggplot(datos, aes(x = Mutation_Effect, y = Frequency)) +
      geom_point(color = "red", alpha = 0.7) +
      labs(title = paste0("Archivo: ", basename(archivo)),
           x = "S (Mutation Effect)",
           y = "Frequency") +
      theme_minimal(base_size = 10)
    
    print(p)  # imprime la gráfica en el PDF
  } else {
    cat("No se encontró:", archivo, "\n")
  }
}

dev.off()  # cierra el PDF
