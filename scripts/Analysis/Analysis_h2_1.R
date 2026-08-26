# Analysis h2 = 1

library(dplyr)
library(ggplot2)

# 1. Obtener la ruta base recibida desde Bash
args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  base_path <- args[1]
} else {
  base_path <- "/mnt/data/dortega/vcabrera/output/1_Homogeneo_output/h2_1/"
}

message("Procesando directorio base: ", base_path)

# 2. Detectar carpetas numéricas (1, 2, ..., N)
carpetas <- list.dirs(base_path, recursive = FALSE, full.names = TRUE)
carpetas_numericas <- carpetas[grepl("/[1-9]+$", carpetas)]

# Ordenar numéricamente (1, 2, 3...)
ids <- as.numeric(basename(carpetas_numericas))
carpetas_numericas <- carpetas_numericas[order(ids)]

message("Carpetas encontradas: ", length(carpetas_numericas))

# 3. Iterar sobre cada carpeta
for (dir in carpetas_numericas) {
  num <- basename(dir)
  message("\n----------------------------------------")
  message("Procesando Carpeta ", num, "...")
  
  # Construir rutas completas a los archivos
  f_opt_phen <- file.path(dir, paste0("Opt_Phen.", num, ".csv"))
  f_region   <- file.path(dir, paste0("Phen_vs_Regions_3.", num, ".csv"))
  f_freq_mut <- file.path(dir, paste0("Freq_vs_MutEffect.", num, ".csv"))
  f_qtl_ind  <- file.path(dir, paste0("Mutations_Carriers.", num, ".csv"))
  f_qtl_eff  <- file.path(dir, paste0("Summary_QTLs.", num, ".csv"))
  
  # Archivo PDF de salida
  pdf_filename <- file.path(dir, paste0("Analysis_", num, ".pdf"))
  
  # Validar que existan todos los archivos necesarios
  archivos_requeridos <- c(f_opt_phen, f_region, f_freq_mut, f_qtl_ind, f_qtl_eff)
  if (!all(file.exists(archivos_requeridos))) {
    warning("Archivos ausentes en carpeta ", num, ". Saltando proceso...")
    next
  }
  
  # --------------------------------------------------
  # LECTURA DE DATOS
  # --------------------------------------------------
  data <- read.table(f_opt_phen, header = TRUE, sep = "\t")
  region_data <- read.table(f_region, header = TRUE, sep = "\t")
  Freq_MutEff <- read.table(f_freq_mut, header = TRUE, sep = "\t")
  qtl_ind <- read.table(f_qtl_ind, header = TRUE, sep = "\t")
  qtl_effect <- read.table(f_qtl_eff, header = TRUE, sep = "\t")
  
  # Merge 1 (by IND_ID)
  datos_plot <- merge(data, region_data[, c("IND_ID", "Region")], by = "IND_ID")
  
  # --------------------------------------------------
  # ABRIR DISPOSITIVO PDF
  # --------------------------------------------------
  pdf(pdf_filename, width = 8, height = 6)
  
  # ===============================================
  # Analysis 1 : Plot Phenotype vs Optimum (Regions)
  # ===============================================
  plot(
    data$Opt,
    data$Phen,
    xlab = "Environmental optimum (Opt)",
    ylab = "Phenotype (Phen)",
    main = paste0("Relationship Between Phenotype and Its Optimum (h2 = 1)\nReplica ", num),
    pch = 19,
    col = "lightgray",
    xlim = range(data$Opt, na.rm = TRUE),
    ylim = range(data$Phen, na.rm = TRUE)
  )
  abline(a = 0, b = 1, lty = 2)

  points(
    datos_plot$Opt[datos_plot$Region == 1],
    datos_plot$Phen[datos_plot$Region == 1],
    col = "red", pch = 19
  )
  points(
    datos_plot$Opt[datos_plot$Region == 2],
    datos_plot$Phen[datos_plot$Region == 2],
    col = "orange", pch = 19
  )
  points(
    datos_plot$Opt[datos_plot$Region == 3],
    datos_plot$Phen[datos_plot$Region == 3],
    col = "yellow", pch = 19
  )

  mean1 <- sprintf("%.3f", mean(datos_plot$Phen[datos_plot$Region == 1], na.rm = TRUE))
  mean2 <- sprintf("%.3f", mean(datos_plot$Phen[datos_plot$Region == 2], na.rm = TRUE))
  mean3 <- sprintf("%.3f", mean(datos_plot$Phen[datos_plot$Region == 3], na.rm = TRUE))

  legend(
    "topleft",
    legend = c(
      paste("Region 1 (Mean:", mean1, ")"),
      paste("Region 2 (Mean:", mean2, ")"),
      paste("Region 3 (Mean:", mean3, ")")
    ),
    col = c("red", "orange", "yellow"),
    pch = 19
  )

  # ===============================================
  # Analysis 2 : Box plots
  # ===============================================
  p_box <- ggplot(datos_plot, aes(x = factor(Region), y = Phen, fill = factor(Region))) +
    geom_boxplot(color = "black") +
    scale_fill_manual(
      values = c("1" = "red", "2" = "orange", "3" = "yellow")
    ) +
    labs(
      title = paste0("Average phenotypic value by region (Replica ", num, ")"),
      x = "Region",
      y = "Phenotypic value",
      fill = "Region"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.title = element_text(size = 16),
      axis.text = element_text(size = 16)
    )
  print(p_box)

  # ===============================================
  # Analysis 3: Frequency of Mutational Effects
  # ===============================================
  Freq_MutEff_clean <- Freq_MutEff[Freq_MutEff$Freq != 1, ]

  p_freq1 <- ggplot(Freq_MutEff_clean, aes(x = MutEffect, y = Freq, color = MutEffect > 0)) +
    geom_point() +
    labs(
      x = "Mutational effect",
      y = "Frequency",
      color = "Effect > 0",
      title = paste0("Frequency of Mutational Effects (Replica ", num, ")")
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.title = element_text(size = 16),
      axis.text = element_text(size = 16)
    )
  print(p_freq1)

  Freq_MutEff_clean$Effect_group <- cut(
    Freq_MutEff_clean$MutEffect,
    breaks = c(-Inf, -0.05, 0.05, Inf),
    labels = c("Negative", "Small", "Positive")
  )

  p_freq2 <- ggplot(Freq_MutEff_clean, aes(x = Effect_group, y = Freq)) +
    geom_boxplot() +
    labs(
      x = "Mutational effect",
      y = "Frequency",
      title = paste0("Frequency of Mutational Effects by Group (Replica ", num, ")")
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
      axis.title = element_text(size = 16),
      axis.text = element_text(size = 16)
    )
  print(p_freq2)

  # ==================================
  # Z_m ADAPTATION SIGNAL
  # ===================================
  merge1 <- qtl_ind %>%
    left_join(region_data %>% select(IND_ID, Region), by = "IND_ID") %>%
    select(-any_of(c("PosInd_X", "PosInd_Y", "Genomes")))

  merge2 <- merge1 %>%
    left_join(qtl_effect %>% select(QTL_ID, PosInGenome, MutEffect), by = c("QTL_ID", "PosInGenome")) %>%
    arrange(Region, QTL_ID, PosInGenome) %>%
    filter(!is.na(Region))

  # Z for all individuals
  Z_individuos <- data.frame(IND_ID = unique(merge2$IND_ID), Z = NA)

  for (i in seq_along(Z_individuos$IND_ID)) {
    individuo <- Z_individuos$IND_ID[i]
    ind <- merge2[merge2$IND_ID == individuo, ]
    Z_individuos$Z[i] <- sum(ind$MutEffect * ind$Copies)
  }

  Z_Phen <- Z_individuos %>%
    left_join(datos_plot %>% select(IND_ID, Phen), by = "IND_ID")

  plot(
    Z_Phen$Phen,
    Z_Phen$Z,
    xlab = "Phenotype",
    ylab = "Z individual",
    main = paste0("Phenotype-genotype relationship (h2 = 1)\nReplica ", num),
    pch = 19,
    col = "black",
    xlim = range(Z_Phen$Phen, na.rm = TRUE),
    ylim = range(Z_Phen$Z, na.rm = TRUE),
    cex.lab = 1.3,
    cex.axis = 1.1,
    cex.main = 1.5
  )
  abline(a = 0, b = 1)

  # CERRAR Y GUARDAR PDF DE LA CARPETA
  dev.off()
  
  message("PDF guardado en: ", pdf_filename)
}

message("\n¡Analisis completado exitosamente para todas las carpetas!")