library(tidyverse)

## load data
plants <- readxl::read_excel(here::here("data", "master_table_plants_extinct.xlsx"))

## clean names
h <- 
  tibble(h1 = names(plants), h2 = as.character(plants[1,])) %>% 
  mutate(name = if_else(is.na(h2), h1, h2))

## fix duplicated NA name
h$name[17] <- "threat_NA"
h$name[23] <- "action_NA"

## set clean names
names(plants) <- h$name

## remove 2nd header line
plants <- plants[-1,]

## remove empty cols at the end
plants <- plants[, -c(25:28)]

plants_wide <-
  plants %>% 
  mutate_at(vars(AA:action_NA), as.numeric) %>% 
  rename_at(vars(AA:GE), function(x){paste0("threat_", x)}) %>% 
  rename_at(vars(LWP:EA), function(x){paste0("action_", x)}) %>% 
  replace(is.na(.), 0)
  
write_csv(plants_wide, here::here("data", "plants_extinct_wide.csv"))

plants_long <-
  plants %>% 
  #dplyr::select(-"NA")
  pivot_longer(
    cols = AA:GE,
    names_to = "threat",
    values_to = "threathened"
  ) %>% 
  pivot_longer(
    cols = LWP:EA,
    names_to = "action",
    values_to = "actioned"
  ) %>% 
  replace_na(list(threathened = 0, actioned = 0))

write_csv(plants_long, here::here("data", "plants_extinct_long.csv"))


##############################################################################
## Detect color fills in original files ######################################

# library(tidyverse)
# library(readxl)
# library(tidyxl)
# 
# path <- "master_table_plants_extinct_color.xlsx"
# 
# # Read in the sheet, I've opted to not use the first line as headers since I add them back in manually at the end.
# x <- read_excel(path, col_names = FALSE)
# 
# # Pulling the formatting out of the sheet
# formats <- xlsx_formats(path)
# 
# # Pulling the fill colours specifically out of the path
# fill_colours_path <- formats$local$fill$patternFill$fgColor$rgb
# 
# #  Import all the cells (note that it also imports extra whitespace beyond column 24, this is deal with below),
# # Create new columns of 'x_fill' with the fill colours, by looking up the local format id of each cell
# fills <- xlsx_cells(path,
#                     sheet = "Sheet1") %>% 
#   mutate(fill_colour = fill_colours_path[local_format_id]) %>% 
#   select(row, col, fill_colour) %>% 
#   spread(col, fill_colour) %>% 
#   set_names(paste0(colnames(x), "_fill"))
# 
# # Combine the original sheet and the format sheet
# y <- bind_cols(x, fills)
# 
# # Removed the two header rows, will be added back in below
# y1 <- y[-(1:2),]
# 
# # Moved format colours from their columns to where they are on the sheet 
# # (i.e. moved the hexcode info from columns 35:52 to columns 6:23)
# y1[,(6:23)] <- y1[,(35:52)]
# 
# # Removed excess columns right of 'Red List Category' column
# y1 <- y1[,-(25:length(y1))]


