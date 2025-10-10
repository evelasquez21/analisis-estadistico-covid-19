# 04_modelo.R
library(dplyr)
library(broom)
library(readr)

# Cargar la serie filtrada
serie <- readRDS("data/serie_filtrada.rds")

# Definir corte temporal: segundo semestre 2021
datos_modelo <- serie %>%
  filter(fecha >= as.Date("2021-07-01") & fecha <= as.Date("2021-12-31")) %>%
  group_by(pais) %>%
  summarise(
    casos_100k_prom = mean(casos_100k, na.rm = TRUE),
    vac_full_prom = mean(vacunacion_completa_100, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  na.omit()  # quitar filas con NA

# Ajustar modelo lineal simple
ajuste <- lm(casos_100k_prom ~ vac_full_prom, data = datos_modelo)

# Guardar resumen del modelo en archivo txt
write_lines(capture.output(summary(ajuste)), "report/regresion_lineal.txt")

# Extraer coeficientes y R2 con broom
res <- broom::tidy(ajuste)
diag <- broom::glance(ajuste)

# Imprimir resultados en consola (opcional)
print(res)
print(diag)

