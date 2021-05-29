library(pdftools)
library(stringr)
library(here)
library(glue)
library(magick)

## convert pdf's to png's
pdfs <- list.files(here("dev"), pattern = "2021_22.*pdf", full.names = TRUE)

for(pdf in pdfs) {
  pdf_convert(pdf = glue("{pdf}"), 
              filenames = glue("{str_remove(pdf, '.pdf')}.png"),
              format = "png", dpi = 250)
}

setwd(here("dev"))

system("magick.exe convert 2021_22*.png -resize 1598x1040 -gravity center -background black -extent 1598x1040 out-%03d.png")


## convert png's to gif
system("magick.exe -delay 25 out*.png -delay 500 out-262.png -loop 0 2021_22_MarioKart.gif")
