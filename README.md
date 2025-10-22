

# Proyecto Final – Estadística I
**Tema:** Análisis estadístico de la pandemia de COVID‑19 con R y DuckDB  
**Modalidad:** Equipos · **Duración:** 4 semanas



## Estructura
```
/R/                    # scripts
/data/                 # datos descargados y .rds intermedios
/report/               # figuras, tablas y el informe final
/sql/                  # (opcional) consultas SQL
covid.duckdb           # base local (creada por 01_ingesta.R)
```
Scripts clave:
- `R/01_ingesta.R`  → descarga OWID y crea `covid.duckdb` + `covid_view`
- `R/02_limpieza.R` → filtra países/fechas y calcula tasas por 100k → `data/serie_filtrada.rds`
- `R/03_analisis.R` → descriptivos, gráficos, t‑test, χ² → resultados en `report/`
- `R/04_modelo.R`   → regresión lineal simple → `report/regresion_lineal.txt`
- `R/run_all.R`     → ejecuta todo el pipeline y renderiza el informe Quarto

## Requisitos
- R ≥ 4.2, RStudio actualizado.
- Paquetes: `duckdb`, `DBI`, `dplyr`, `dbplyr`, `readr`, `lubridate`, `ggplot2`, `broom`, `knitr`, `rmarkdown` o `quarto`, `zoo`.

## Ejecución rápida
1) Abrir R/RStudio en la carpeta del proyecto.  
2) Ejecutar:
```r
source("R/run_all.R")
```
Esto descargará los datos, creará la base DuckDB, generará figuras/tablas y **renderizará** `report/proyecto_final.qmd` a HTML.

> Si no tienes Quarto instalado, el script intentará usar `rmarkdown`. Instala Quarto desde https://quarto.org

## Personalización
- Modifica países y periodo en `R/02_limpieza.R`.
- Ajusta preguntas/hipótesis en el informe `report/proyecto_final.qmd`.
- Agrega consultas en `/sql/` y úsalas desde `dbplyr` o `DBI`.
