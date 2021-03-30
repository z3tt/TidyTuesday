library(pdftools)
library(stringr)
library(here)
library(glue)
library(magick)

## convert pdf's to png's
pdfs <- list.files(here("dev"), pattern = "*.pdf", full.names = TRUE)

for(pdf in pdfs) {
  pdf_convert(pdf = glue("{pdf}"), 
              filenames = glue("{str_remove(pdf, '.pdf')}.png"),
              format = "png", dpi = 250)
}

system("magick.exe convert 2021_*.png -resize 1500x1000 -gravity center -background black -extent 1500x1000 out-%03d.png")


## convert png's to gif
system("magick.exe -delay 25 out*.png -delay 500 out-150.png -loop 0 2021_01_geomUsage.gif")
