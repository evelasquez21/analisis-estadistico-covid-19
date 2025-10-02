# 1. Instalar y cargar la librería necesaria.
# 'readr' es ideal para leer archivos CSV de forma rápida y eficiente.
# Si no tienes 'tidyverse' instalado, R te pedirá instalarlo.
if (!require("readr")) {
  install.packages("readr")
}
library(readr)

# 2. Definir la URL del archivo CSV.
# Esta es la URL que aparece en tu imagen.
url_datos <- "https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv"

# 3. Leer el archivo CSV directamente desde la URL.
# La función read_csv() crea un dataframe (tibble) con los datos.
datos_covid <- read_csv(url_datos)

# 4. (Opcional) Explorar los datos para confirmar que se cargaron correctamente.
# Muestra las primeras 6 filas del dataset.
head(datos_covid)

# Ofrece un resumen de cada columna (variable).
summary(datos_covid)

# Muestra la estructura del dataset y el tipo de cada variable.
str(datos_covid)