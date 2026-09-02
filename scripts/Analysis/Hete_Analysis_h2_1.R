# Analysis h2 = 1

library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)

# 1. Obtener la ruta base recibida desde Bash
args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  base_path <- args[1]
} else {
  base_path <- "/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/h2_1"
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
  f_region3   <- file.path(dir, paste0("Phen_vs_Regions_3.", num, ".csv"))
  f_region5   <- file.path(dir, paste0("Phen_vs_Regions_5.", num, ".csv"))
  f_region10   <- file.path(dir, paste0("Phen_vs_Regions_10.", num, ".csv"))
  f_freq_mut <- file.path(dir, paste0("Freq_vs_MutEffect.", num, ".csv"))
  f_qtl_ind  <- file.path(dir, paste0("Mutations_Carriers.", num, ".csv"))
  f_qtl_eff  <- file.path(dir, paste0("Summary_QTLs.", num, ".csv"))
  
  # Archivo PDF de salida
  pdf_filename <- file.path(dir, paste0("Analysis_", num, ".pdf"))
  
  # Validar que existan todos los archivos necesarios
  archivos_requeridos <- c(f_opt_phen, f_region3, f_region5, f_region10, f_freq_mut, f_qtl_ind, f_qtl_eff)
  if (!all(file.exists(archivos_requeridos))) {
    warning("Archivos ausentes en carpeta ", num, ". Saltando proceso...")
    next
  }
  
  # --------------------------------------------------
  # LECTURA DE DATOS
  # --------------------------------------------------
  data <- read.table(f_opt_phen, header = TRUE, sep = "\t")
  region_data3 <- read.table(f_region3, header = TRUE, sep = "\t")
  region_data5 <- read.table(f_region5, header = TRUE, sep = "\t")
  region_data10 <- read.table(f_region10, header = TRUE, sep = "\t")
  Freq_MutEff <- read.table(f_freq_mut, header = TRUE, sep = "\t")
  qtl_ind <- read.table(f_qtl_ind, header = TRUE, sep = "\t")
  qtl_effect <- read.table(f_qtl_eff, header = TRUE, sep = "\t")
  
  # Merge 1 (by IND_ID)
  datos_plot3 <- merge(data, region_data3[, c("IND_ID", "Region")], by = "IND_ID")
  datos_plot5 <- merge(data, region_data5[, c("IND_ID", "Region")], by = "IND_ID")
  datos_plot10 <- merge(data, region_data10[, c("IND_ID", "Region")], by = "IND_ID")

  # --------------------------------------------------
  # Abrir PDF
  # --------------------------------------------------
  pdf(pdf_filename, width = 8, height = 6)
  
  # ===============================================
  # Analysis 1 : Plot Phenotype vs Optimum (Regions)
  # ===============================================


  ##############################
  # 3 Regiones
  ##############################
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
    datos_plot3$Opt[datos_plot3$Region == 1],
    datos_plot3$Phen[datos_plot3$Region == 1],
    col = "yellow", pch = 19
  )
  points(
    datos_plot3$Opt[datos_plot3$Region == 2],
    datos_plot3$Phen[datos_plot3$Region == 2],
    col = "orange", pch = 19
  )
  points(
    datos_plot3$Opt[datos_plot3$Region == 3],
    datos_plot3$Phen[datos_plot3$Region == 3],
    col = "red", pch = 19
  )

  mean1 <- sprintf("%.3f", mean(datos_plot3$Phen[datos_plot3$Region == 1], na.rm = TRUE))
  mean2 <- sprintf("%.3f", mean(datos_plot3$Phen[datos_plot3$Region == 2], na.rm = TRUE))
  mean3 <- sprintf("%.3f", mean(datos_plot3$Phen[datos_plot3$Region == 3], na.rm = TRUE))

  legend(
    "topleft",
    legend = c(
      paste("Region 1 (Mean:", mean1, ")"),
      paste("Region 2 (Mean:", mean2, ")"),
      paste("Region 3 (Mean:", mean3, ")")
    ),
    col = c("yellow", "orange", "red"),
    pch = 19
  )


##############################
  # 5 Regiones
  ##############################
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

  # Graficar todos los puntos superpuestos asignando el color según la Región (1 a 5)
# Genera 5 colores repartidos desde el rojo pasando por el naranja hasta el amarillo
col_gradiente <- colorRampPalette(c("yellow", "orange", "red3"))(5)

points(
  datos_plot5$Opt,
  datos_plot5$Phen,
  col = col_gradiente[datos_plot5$Region],
  pch = 19
)

  mean1 <- sprintf("%.3f", mean(datos_plot5$Phen[datos_plot5$Region == 1], na.rm = TRUE))
  mean2 <- sprintf("%.3f", mean(datos_plot5$Phen[datos_plot5$Region == 2], na.rm = TRUE))
  mean3 <- sprintf("%.3f", mean(datos_plot5$Phen[datos_plot5$Region == 3], na.rm = TRUE))
  mean4 <- sprintf("%.3f", mean(datos_plot5$Phen[datos_plot5$Region == 4], na.rm = TRUE))
  mean5 <- sprintf("%.3f", mean(datos_plot5$Phen[datos_plot5$Region == 5], na.rm = TRUE))


  legend(
    "topleft",
    legend = c(
      paste("Region 1 (Mean:", mean1, ")"),
      paste("Region 2 (Mean:", mean2, ")"),
      paste("Region 3 (Mean:", mean3, ")"),
      paste("Region 4 (Mean:", mean4, ")"),
      paste("Region 5 (Mean:", mean5, ")")
    ),
    col = col_gradiente,
    pch = 19
  )


##############################
  # 10 Regiones
##############################
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

 col_gradiente <- colorRampPalette(c("yellow", "orange", "red3"))(10)

points(
  datos_plot5$Opt,
  datos_plot5$Phen,
  col = col_gradiente[datos_plot10$Region],
  pch = 19
)

  mean1 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 1], na.rm = TRUE))
  mean2 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 2], na.rm = TRUE))
  mean3 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 3], na.rm = TRUE))
  mean4 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 4], na.rm = TRUE))
  mean5 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 5], na.rm = TRUE))
  mean6 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 6], na.rm = TRUE))
  mean7 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 7], na.rm = TRUE))
  mean8 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 8], na.rm = TRUE))
  mean9 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 9], na.rm = TRUE))
  mean10 <- sprintf("%.3f", mean(datos_plot10$Phen[datos_plot10$Region == 10], na.rm = TRUE))

  legend(
    "topleft",
    legend = c(
      paste("Region 1 (Mean:", mean1, ")"),
      paste("Region 2 (Mean:", mean2, ")"),
      paste("Region 3 (Mean:", mean3, ")"),
      paste("Region 4 (Mean:", mean4, ")"),
      paste("Region 5 (Mean:", mean5, ")"),
      paste("Region 6 (Mean:", mean6, ")"),
      paste("Region 7 (Mean:", mean7, ")"),
      paste("Region 8 (Mean:", mean8, ")"),
      paste("Region 9 (Mean:", mean9, ")"),
      paste("Region 10 (Mean:", mean10, ")")
    ),
    col = col_gradiente,
    pch = 19
  )

  # ===============================================
  # Analysis 2 : Box plots
  # ===============================================
  
  #####################
  # 3 Regiones
  #####################

  p_box <- ggplot(datos_plot3, aes(x = factor(Region), y = Phen, fill = factor(Region))) +
    geom_boxplot(color = "black") +
    scale_fill_manual(
      values = c("1" = "yellow", "2" = "orange", "3" = "red")
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


  #####################
  # 5 Regiones
  #####################

  p_box <- ggplot(datos_plot5, aes(x = factor(Region), y = Phen, fill = factor(Region))) +
    geom_boxplot(color = "black") +
    scale_fill_manual(values = colorRampPalette(c("yellow", "orange", "red"))(5)) +
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

  #####################
  # 10 Regiones
  #####################
  
  p_box <- ggplot(datos_plot10, aes(x = factor(Region), y = Phen, fill = factor(Region))) +
    geom_boxplot(color = "black") +
        scale_fill_manual(values = colorRampPalette(c("yellow", "orange", "red"))(10)) +
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
    left_join(region_data3 %>% select(IND_ID, Region), by = "IND_ID") %>%
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
    left_join(datos_plot3 %>% select(IND_ID, Phen), by = "IND_ID")

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



  # ============================
  # Calculo de Z por region
  # ============================


  ##############################
  # Z en 3 regiones
  ##############################

  # Inicializar la tabla de resultados 
  resultados_Z3 <- data.frame(
  Region = integer(),
  Z = numeric()
  )

  # Unir region_data3 con qtl_effect para asegurar que las columnas existen en sub_region
  region_data3_full <- region_data3 %>%
    left_join(qtl_ind, by = "IND_ID") %>%
    left_join(qtl_effect, by = c("QTL_ID", "PosInGenome")) %>%
    filter(!is.na(Region))

  for (m in unique(region_data3_full$Region)) {
      print(paste("Regions:", m))
      sub_region <- region_data3_full[region_data3_full$Region == m, ]
      n_total <- length(unique(sub_region$IND_ID))
      productos_p_effect <- c()
  
      qtls_unicos <- unique(sub_region[, c("QTL_ID", "PosInGenome")])
  
      for (i in seq_len(nrow(qtls_unicos))) {
          qtl_actual <- qtls_unicos$QTL_ID[i]
          pos_actual <- qtls_unicos$PosInGenome[i]
    
          sub_mut <- sub_region[sub_region$QTL_ID == qtl_actual & 
                            sub_region$PosInGenome == pos_actual, ]
    
          suma_copias <- sum(sub_mut$Copies, na.rm = TRUE)
          p <- suma_copias / (2 * n_total)
          mut_effect <- sub_mut$MutEffect[1]
    
          productos_p_effect <- c(productos_p_effect, p * mut_effect)
      }
  
      z_region3 <- 2 * sum(productos_p_effect, na.rm = TRUE)
      resultados_Z3 <- rbind(resultados_Z3, data.frame(Region = m, Z = z_region3))
  }

  print(resultados_Z3)
  message("Resultados Z3 calculados correctamente.")

  ##############################
  # Z en 5 regiones
  ##############################
  resultados_Z5 <- data.frame(
    Region = integer(),
    Z = numeric()
  )

  region_data5_full <- region_data5 %>%
    left_join(qtl_ind, by = "IND_ID") %>%
    left_join(qtl_effect, by = c("QTL_ID", "PosInGenome")) %>%
    filter(!is.na(Region))

  for (m in unique(region_data5_full$Region)) {
      print(paste("Regions:", m))
      sub_region <- region_data5_full[region_data5_full$Region == m, ]
      n_total <- length(unique(sub_region$IND_ID))
      productos_p_effect <- c()
  
      qtls_unicos <- unique(sub_region[, c("QTL_ID", "PosInGenome")])
  
      for (i in seq_len(nrow(qtls_unicos))) {
          qtl_actual <- qtls_unicos$QTL_ID[i]
          pos_actual <- qtls_unicos$PosInGenome[i]
    
          sub_mut <- sub_region[sub_region$QTL_ID == qtl_actual & 
                            sub_region$PosInGenome == pos_actual, ]
    
          suma_copias <- sum(sub_mut$Copies, na.rm = TRUE)
          p <- suma_copias / (2 * n_total)
          mut_effect <- sub_mut$MutEffect[1]
    
          productos_p_effect <- c(productos_p_effect, p * mut_effect)
      }
  
      z_region5 <- 2 * sum(productos_p_effect, na.rm = TRUE)
      resultados_Z5 <- rbind(resultados_Z5, data.frame(Region = m, Z = z_region5))
  }

  print(resultados_Z5)
  message("resultados Z en 5 regiones calculados correctamente.")

  ##############################
  # Z en 10 regiones
  ##############################
  resultados_Z10 <- data.frame(
    Region = integer(),
    Z = numeric()
  )

  region_data10_full <- region_data10 %>%
    left_join(qtl_ind, by = "IND_ID") %>%
    left_join(qtl_effect, by = c("QTL_ID", "PosInGenome")) %>%
    filter(!is.na(Region))

  for (m in unique(region_data10_full$Region)) {
      print(paste("Regions:", m))
      sub_region <- region_data10_full[region_data10_full$Region == m, ]
      n_total <- length(unique(sub_region$IND_ID))
      productos_p_effect <- c()
  
      qtls_unicos <- unique(sub_region[, c("QTL_ID", "PosInGenome")])
  
      for (i in seq_len(nrow(qtls_unicos))) {
          qtl_actual <- qtls_unicos$QTL_ID[i]
          pos_actual <- qtls_unicos$PosInGenome[i]
    
          sub_mut <- sub_region[sub_region$QTL_ID == qtl_actual & 
                            sub_region$PosInGenome == pos_actual, ]
    
          suma_copias <- sum(sub_mut$Copies, na.rm = TRUE)
          p <- suma_copias / (2 * n_total)
          mut_effect <- sub_mut$MutEffect[1]
    
          productos_p_effect <- c(productos_p_effect, p * mut_effect)
      }
  
      z_region10 <- 2 * sum(productos_p_effect, na.rm = TRUE)
      resultados_Z10 <- rbind(resultados_Z10, data.frame(Region = m, Z = z_region10))
  }

  print(resultados_Z10)
  message("resultados Z en 10 regiones calculados correctamente.")

  # IMPRIMIR TABLAS Z DENTRO DEL PDF
  #grid.newpage()
  grid.arrange(
    tableGrob(resultados_Z10, rows = NULL),
    tableGrob(resultados_Z5, rows = NULL),
    tableGrob(resultados_Z3, rows = NULL),
    ncol = 2,
    top = textGrob(paste("Estimation of genetic values (Z) by region 
                         - Replica", num), gp = gpar(fontsize = 16, fontface = "bold"))
  )


#==================================
  # Lectura de archivos FST
# =================================

  f_fst3  <- file.path(dir, paste0("FST_3.", num, ".csv"))
  f_fst5  <- file.path(dir, paste0("FST_5.", num, ".csv"))  # Ajustado al patrón FST_5.#.csv
  f_fst10 <- file.path(dir, paste0("FST_10.", num, ".csv"))

  fst_data3  <- read.table(f_fst3, header = TRUE)
  fst_data5  <- read.table(f_fst5, header = TRUE)
  fst_data10 <- read.table(f_fst10, header = TRUE)

  grid.arrange(
  textGrob("FST - 3 Regions", gp = gpar(fontface = "bold", fontsize = 14)),
  tableGrob(fst_data3, rows = NULL),
  ncol = 1,
  heights = c(0.1, 0.9), # <-- Esto controla la proporción del espacio vertical
  top = textGrob(paste("FST Values - Replica", num), gp = gpar(fontsize = 16, fontface = "bold"))
)

# --- HOJA 2: 5 Regiones ---
grid.arrange(
  textGrob("FST - 5 Regions", gp = gpar(fontface = "bold", fontsize = 14)),
  tableGrob(fst_data5, rows = NULL),
  ncol = 1,
  heights = c(0.1, 0.9),
  top = textGrob(paste("FST Values - Replica", num), gp = gpar(fontsize = 16, fontface = "bold"))
)

# --- HOJA 3: 10 Regiones ---
grid.arrange(
  textGrob("FST - 10 Regions", gp = gpar(fontface = "bold", fontsize = 14)),
  tableGrob(fst_data10, rows = NULL),
  ncol = 1,
  heights = c(0.1, 0.9),
  top = textGrob(paste("FST Values - Replica", num), gp = gpar(fontsize = 10, fontface = "bold"))
)

  # CERRAR Y GUARDAR PDF DE LA CARPETA
  dev.off()
  
  message("PDF guardado en: ", pdf_filename)
}

message("\n¡Analisis completado exitosamente para todas las carpetas!")## 
