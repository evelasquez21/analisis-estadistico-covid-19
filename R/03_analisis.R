# 03_analisis.R
library(dplyr)
library(ggplot2)
library(lubridate)
library(broom)
library(readr)

# Cargar la serie filtrada
serie <- readRDS("data/serie_filtrada.rds")

# Promedio móvil 7 días de casos_100k sin usar paquetes extra
serie <- serie %>%
  group_by(pais) %>%
  arrange(fecha, .by_group = TRUE) %>%
  mutate(
    casos_100k_ma7 = stats::filter(casos_100k, rep(1/7, 7), sides = 1)
  )

# Crear carpeta report si no existe
dir.create("report", showWarnings = FALSE)

# Gráfico de curvas epidémicas
g1 <- ggplot(serie, aes(x = fecha, y = casos_100k_ma7, group = pais)) +
  geom_line(color = "steelblue") +
  facet_wrap(~ pais, scales = "free_y") +
  labs(title = "Casos por 100k (Media móvil 7 días)",
       x = "Fecha", y = "Casos/100k (MA7)") +
  theme_minimal()

# Guardar gráfico
ggsave(filename = "report/fig_casos_ma7.png", plot = g1, width = 10, height = 6, dpi = 120)

# ==========================
# t-test ejemplo: pre vs post segundo semestre 2021
# ==========================
periodo_pre <- serie %>% filter(fecha >= as.Date("2021-01-01") & fecha <= as.Date("2021-06-30"))
periodo_post <- serie %>% filter(fecha >= as.Date("2021-07-01") & fecha <= as.Date("2021-12-31"))

tt <- t.test(periodo_pre$casos_100k, periodo_post$casos_100k, alternative = "two.sided")

# Guardar resultados t-test
write_lines(capture.output(tt), "report/t_test.txt")

# ==========================
# χ²: categorización incidencia vs cobertura vacunación
# ==========================
if ("vacunacion_completa_100" %in% names(serie)) {
  df_chi <- serie %>%
    filter(!is.na(vacunacion_completa_100)) %>%
    mutate(
      incidencia_cat = if_else(casos_100k > quantile(casos_100k, 0.75, na.rm = TRUE), "Alta", "Baja"),
      cobertura_cat = cut(vacunacion_completa_100, breaks = c(-Inf, 30, 60, Inf), labels = c("Baja","Media","Alta"))
    ) %>%
    select(incidencia_cat, cobertura_cat) %>%
    na.omit()
  
  tbl_chi <- table(df_chi$incidencia_cat, df_chi$cobertura_cat)
  chisq <- chisq.test(tbl_chi)
  
  write_lines(capture.output(chisq), "report/chi2.txt")
}

