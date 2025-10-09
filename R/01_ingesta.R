# 01_ingesta.R - versión final sin errores de fecha
library(DBI)
library(duckdb)
library(dplyr)
library(readr)
library(lubridate)

# Crear carpeta data si no existe
dir.create("data", showWarnings = FALSE)

# Ruta de tu archivo CSV
archivo_csv <- "C:/estadistica 1/PROYECTO R/analisis-estadistico-covid-19/data/compact.csv"

# Crear la base local DuckDB
db_path <- "covid.duckdb"
con <- dbConnect(duckdb::duckdb(), dbdir = db_path, read_only = FALSE)

# Cargar CSV a tabla, forzando la columna 'date' a VARCHAR y leyendo todo
DBI::dbExecute(con, "
CREATE OR REPLACE TABLE covid AS
SELECT * FROM read_csv_auto(?, types={'date': 'VARCHAR'}, sample_size=-1);
", params = list(archivo_csv))

# Crear la vista covid_view con nombres estandarizados
DBI::dbExecute(con, "
CREATE OR REPLACE VIEW covid_view AS
SELECT 
  country AS pais,
  CAST(date AS DATE) AS fecha,
  population AS poblacion,
  new_cases AS casos_nuevos,
  new_deaths AS muertes_nuevas,
  total_cases AS casos_acum,
  total_deaths AS muertes_acum,
  people_fully_vaccinated_per_hundred AS vacunacion_completa_100
FROM covid
WHERE country NOT IN ('World','International','High income','Upper middle income','Lower middle income','Low income')
")

# Confirmación y prueba: mostrar primeras 5 filas de la vista
cat('✅ Ingesta completa. Base local creada en:', db_path, '\n')
head(dbGetQuery(con, "SELECT * FROM covid_view LIMIT 5;"))

dbDisconnect(con, shutdown = TRUE)

