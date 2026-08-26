# Analisis

# Cargar datos
base_path <- "/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/11"

# Leer datos
datos <- read.table(
    file.path(base_path, "Opt_Phen.11.csv"),
    header = TRUE,
    sep = "\t"
)

# Revisar columnas
print(names(datos))

# Revisar datos
print(head(datos))

# Abrir PDF
pdf(
    file.path(base_path, "Density_vs_Fitness_11.pdf"),
    width = 8,
    height = 6
)

# Graficar Density vs Fitness
plot(
    datos$density,
    datos$Fitness,
    xlab = "Densidad",
    ylab = "Fitness",
    main = "Fitness vs. Densidad (h2 = 0.5)",
    pch = 19
)

# Ajustar regresión lineal
modelo <- lm(Fitness ~ density, data = datos)

# Añadir línea de regresión
abline(modelo, lty = 2)

modelo <- lm(Fitness ~ density, data = datos)

sink(file.path(base_path, "Density_vs_Fitness_model_11.txt"))

print(summary(modelo))

sink()

# Cerrar PDF
dev.off()