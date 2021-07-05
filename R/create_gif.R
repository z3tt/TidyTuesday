library(pdftools)
library(stringr)
library(here)
library(glue)
library(magick)

## convert pdf's to png's
pdfs <- list.files(here("dev"), pattern = "2021_25.*pdf", full.names = TRUE)

for(pdf in pdfs) {
  pdf_convert(pdf = glue("{pdf}"), 
              filenames = glue("{str_remove(pdf, '.pdf')}.png"),
              format = "png", dpi = 250)
}

setwd(here("dev"))

system("magick.exe convert 2021_25*.png -resize 1500x1125 -gravity center -background white -extent 1500x1125 out-%03d.png")


## convert png's to gif
system("magick.exe -delay 25 out*.png -delay 500 out-110.png -loop 0 2021_25_DuBoisChallenge.gif")
