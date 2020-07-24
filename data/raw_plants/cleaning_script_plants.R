library(tidyverse)

## load data
plants <- readxl::read_excel(here::here("data", "master_table_plants_extinct.xlsx"))

## clean names
h <- 
  tibble(h1 = names(plants), h2= as.character(plants[1,])) %>% 
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

## remove NA columns
#plants <- plants[, -c(17, 23)]

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
