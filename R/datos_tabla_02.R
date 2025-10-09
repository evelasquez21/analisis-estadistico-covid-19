# Cargar la serie filtrada
serie <- readRDS("data/serie_filtrada.rds")

# Ver las primeras filas
head(serie)

# Ver la estructura de columnas y tipos
dplyr::glimpse(serie)

# Abrir la vista tipo Excel dentro de RStudio
View(serie)

