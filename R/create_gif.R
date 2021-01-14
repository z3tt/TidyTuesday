library(pdftools)
library(magick)

## convert pdf's to png's
setwd(here::here("dev"))
pdfs <- list.files(here::here("dev"), pattern = ".*pdf")

for(pdf in pdfs) {
  pdf_convert(pdf = here::here("dev", pdf), 
              format = "png", dpi = 250)
}

system("magick.exe convert 2021_*.png -resize 1358x792 -gravity center -background black -extent 1358x792 out-%03d.png")

## convert png's to gif
system("magick.exe -delay 25 out*.png -delay 500 out-209.png -loop 0 2021_02_TransitCosts.gif")
