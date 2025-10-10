# 02_limpieza.R
library(DBI)
library(duckdb)
library(dplyr)
library(lubridate)

# Conexión a la base DuckDB
con <- dbConnect(duckdb::duckdb(), dbdir = "covid.duckdb", read_only = FALSE)

# Acceder a la vista covid_view
covid_tbl <- tbl(con, "covid_view")

# Definir países de interés y rango de fechas
paises_foco <- c("Guatemala","Honduras","El Salvador","Costa Rica","Panama")
inicio <- as.Date("2021-01-01")
fin <- as.Date("2022-12-31")

# Filtrar, calcular tasas por 100k y ordenar
serie <- covid_tbl %>%
  filter(pais %in% paises_foco, fecha >= inicio, fecha <= fin) %>%
  mutate(
    casos_100k = if_else(!is.na(poblacion) & poblacion > 0, 1e5 * casos_nuevos / poblacion, NA_real_),
    muertes_100k = if_else(!is.na(poblacion) & poblacion > 0, 1e5 * muertes_nuevas / poblacion, NA_real_)
  ) %>%
  arrange(pais, fecha) %>%
  collect()  # Traer los datos a memoria

# Guardar la serie filtrada como RDS
saveRDS(serie, file = "data/serie_filtrada.rds")

# Cerrar conexión
dbDisconnect(con, shutdown = TRUE)

cat("✅ Limpieza completa. Serie filtrada guardada en data/serie_filtrada.rds\n")
