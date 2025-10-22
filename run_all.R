
# R/run_all.R
# Ejecuta el pipeline completo y luego renderiza el informe Quarto.

scripts <- c("R/01_ingesta.R", "R/02_limpieza.R", "R/03_analisis.R", "R/04_modelo.R")
for (s in scripts) {
  message(">> Ejecutando ", s)
  source(s, echo = TRUE, max.deparse.length = Inf)
}

# Render del informe
out_file <- "report/proyecto_final.qmd"
if (!file.exists(out_file)) stop("No se encontró report/proyecto_final.qmd")

# Prefiere Quarto; si no, usa rmarkdown
if (nzchar(Sys.which("quarto"))) {
  system2("quarto", c("render", out_file))
} else {
  if (!"rmarkdown" %in% rownames(installed.packages())) install.packages("rmarkdown", repos = "https://cloud.r-project.org")
  rmarkdown::render(out_file, output_format = "html_document")
}

message("Render completo. Revisa la carpeta report/.")
