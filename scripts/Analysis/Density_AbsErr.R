# Analisis

# Cargar datos
base_path <- "/mnt/data/dortega/vcabrera/output/2_Heterogeneo_output/8"

# Leer datos
datos <- read.table(
    file.path(base_path, "Opt_Phen.8.csv"),
    header = TRUE,
    sep = "\t"
)

# Revisar columnas
print(names(datos))

# Revisar datos
print(head(datos))

# Abrir PDF
pdf(
    file.path(base_path, "Density_vs_AbsErr_8.pdf"),
    width = 8,
    height = 6
)

# Graficar Density vs Fitness
plot(
    datos$density,
    datos$AbsErr,
    xlab = "Densidad",
    ylab = "AbsErr",
    main = "AbsErr(Phen-Opt) vs Density (h2 = 0.5)",
    pch = 19
)

# Ajustar regresión lineal
modelo <- lm(AbsErr ~ density, data = datos)

# Añadir línea de regresión
abline(modelo, lty = 2)

modelo <- lm(AbsErr ~ density, data = datos)

sink(file.path(base_path, "Density_vs_AbsErr_model_8.txt"))

print(summary(modelo))

sink()

# Cerrar PDF
dev.off()#
