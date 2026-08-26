# Analisis

# Cargar datos
base_path <- "/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/12"

# Leer datos
datos <- read.table(
    file.path(base_path, "Opt_Phen.12.csv"),
    header = TRUE,
    sep = ","
)

# Revisar que las columnas existan
print(names(datos))

# Revisar las primeras filas
print(head(datos))

# Abrir PDF
pdf(
    file.path(base_path, "Opt_vs_Phen_12.pdf"),
    width = 8,
    height = 6
)

# Graficar Opt vs Phen
plot(
    datos$Opt,
    datos$Phen,
    xlab = "Óptimo ambiental (Opt)",
    ylab = "Fenotipo (Phen)",
    main = "Fenotipo vs. Óptimo ambiental h2 = 1",
    pch = 19,
    xlim = range(datos$Opt),
    ylim = range(datos$Phen)
)

abline(a = 0, b = 1, lty = 2)

# Línea de adaptación perfecta: Phen = Opt
abline(
    a = 0,
    b = 1,
    lty = 2
)

# Líneas de referencia
abline(h = 0, lty = 3)
abline(v = 0, lty = 3)

# Cerrar PDF
dev.off()