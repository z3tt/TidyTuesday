library(dplyr)
library(tidyr)

btw_data <- read.csv2(
  "https://www.bundeswahlleiter.de/dam/jcr/f0610db5-f84c-430e-96e1-19be7f599e60/btw17_rws_zwst-1953.csv", 
  skip = 10
) %>%
  select(-Altersgruppe.etwa.von.....bis.....Jahren) %>%
  filter(Geschlecht != "Summe") %>%
  gather(CDU, SPD, PDS.DIE.LINKE, GRÃœNE, CSU, FDP, AfD, Sonstige, key = Partei, value = Wahlergebnis) %>%
  mutate(Partei = ifelse(Partei == "PDS.DIE.LINKE", "Die Linke", Partei)) %>%
  mutate(Partei = ifelse(Partei == "GRÃœNE", "Die Grünen", Partei)) %>%
  mutate(Partei = factor(Partei, levels = c("CDU", "SPD", "FDP", "CSU", "Die Grünen", "Die Linke", "AfD", "Sonstige"))) %>%
  mutate(Geschlecht = ifelse(Geschlecht == "m", "männlich", "weiblich")) %>%
  mutate(Wahlergebnis = Wahlergebnis / 100) %>%
  replace_na(replace = list(Wahlergebnis = 0))

party_color <- c(
  "AfD" = "#1a9fde",
  "SPD" = "#e10b1f", 
  "CDU" = "#565656", 
  "CSU" = "#727272", 
  "Die Grünen" = "#499533", 
  "Die Linke" = "#bc3475", 
  "FDP" = "#e5d82d",
  "Sonstige" = "#D3D3D3"
)

library(ggplot2)
library(gganimate)

btw_animated <- ggplot(btw_data, aes(x = Partei, y = Wahlergebnis, fill = Partei)) +
  geom_hline(yintercept = 0.05, colour = "#D3D3D3", linetype = "dashed") +
  geom_bar(position = "dodge", stat = "identity") +
  geom_text(aes(label = scales::percent(Wahlergebnis), 
                y = Wahlergebnis + 0.01),
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 6, color = "black") +
  labs(title = "Wahlergebnisse der Bundestagswahl {closest_state}",
       subtitle = "Ergebnisse nach Geschlecht der WählerInnen*",
       caption = "* 1994 und 1998 wurde die repräsentative Wahlstatistik durch den Gesetzgeber ausgesetzt",
       x = "", y = "") +
  theme_light(base_size = 16) +
  guides(fill = FALSE) +
  facet_grid(Geschlecht ~ .) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.59)) +
  scale_fill_manual(values = party_color) +
  transition_states(Bundestagswahl, 1, 3, wrap = FALSE) +
  ease_aes('quadratic-in-out')


#####

library(ggimage)

source(here::here("theme", "tidy_grey.R"))


df_cars <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-15/big_epa_cars.csv")

df_cars_top <- 
  df_cars %>%
  pivot_longer(
    cols = c("city08", "cityA08"), 
    names_to = "city_fuel", 
    values_to = "city_mpg"
  ) %>%
  filter(city_mpg > 0) %>%
  group_by(make) %>%
  summarize(city_mpg_median = median(city_mpg)) %>%
  ungroup()  %>% 
  arrange(-city_mpg_median) %>% 
  top_n(20, city_mpg_median) %>%
  mutate(
    make = fct_reorder(make, city_mpg_median),
    #make_id =  n() - as.numeric(make) + 1
    make_id =  as.numeric(make),
  )

df_cars_anim <-
  df_cars_top %>% 
  mutate(
    city_mpg_median = 0,
    state = 0
  ) %>% 
  bind_rows(df_cars_top)
  


df_cars_top <- 
  df_cars %>%
  pivot_longer(cols = c("city08", "cityA08"), names_to = "city_fuel", values_to = "city_mpg") %>%
  filter(city_mpg > 0) %>%
  group_by(make) %>%
  summarize(median = median(city_mpg)) %>%
  ungroup()  %>% 
  arrange(-median) %>% 
  top_n(20, median) %>%
  mutate(
    #make = fct_reorder(make, median),
    make = fct_shuffle(make),
    #make_id =  n() - as.numeric(make) + 1
    make_id =  as.numeric(make),
    median_0 = 0,
    median_5 = if_else(median > 5, 5, median),
    median_10 = if_else(median > 10, 10, median),
    median_15 = if_else(median > 15, 15, median),
    median_20 = if_else(median > 20, 20, median),
    median_25 = if_else(median > 25, 25, median),
    median_30 = if_else(median > 30, 30, median),
    median_35 = if_else(median > 35, 35, median),
    median_40 = if_else(median > 40, 40, median),
    median_45 = if_else(median > 45, 45, median),
    median_50 = if_else(median > 50, 50, median),
    median_55 = if_else(median > 55, 55, median),
    median_60 = if_else(median > 60, 60, median),
    median_65 = if_else(median > 65, 65, median),
    median_70 = if_else(median > 70, 70, median),
    median_75 = if_else(median > 75, 75, median),
    median_80 = if_else(median > 80, 80, median),
    median_85 = if_else(median > 85, 85, median),
    median_90 = if_else(median > 90, 90, median),
    median_95 = if_else(median > 95, 95, median)
  ) %>% 
  dplyr::select(-median) %>% 
  gather(state, median, -make, -make_id) %>% 
  mutate(state = as.numeric(str_sub(state, 8)))

car <- here::here("img", "car.png")

lines <-
  df_cars_top %>% 
  group_by(make_id) %>% 
  summarize(val = unique(make_id) + 0.5) %>% 
  add_row(make_id = 0, val = 0.5)

df_cars_anim <- 
  ggplot(df_cars_top, 
       aes(make_id, median, group = make_id)) +
    geom_segment(aes(x = make_id - 0.15, xend = make_id - 0.15, 
                     y = 0, yend = median),
                 size = 1.7) +
    geom_segment(aes(x = make_id + 0.15, xend = make_id + 0.15, 
                     y = 0, yend = median),
                 size = 1.7) +
    geom_image(aes(make_id, median + 1.5, image = car), size = 0.05, asp = 0.7) +
    geom_vline(data = lines,
               aes(xintercept = val),
               color = "white",
               linetype = "dashed",
               size = 0.3) +
    geom_text(aes(make_id, -16, label = make),
              color = "grey80",
              hjust = 0,
              family = "Montserrat",
              size = 5,
              fontface = "bold") +
    scale_x_continuous(expand = c(0.01, 0.01)) +
    scale_y_continuous(limits = c(-17, 102), 
                       expand = c(0.001, 0.001),
                       breaks = seq(0, 100, by = 20),
                       labels = c("0 miles per gallon", "20", "40", "60", "80", "100")) + 
    coord_flip() + 
    theme_custom(base_family = "Montserrat") +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_text(size = 16),
          axis.ticks.y = element_blank(),
          axis.text.y = element_blank(),
          plot.title = element_text(size = 40),
          plot.subtitle = element_text(size = 16,
                                       lineheight = 1.2),
          plot.caption = element_text(size = 16),
          panel.border = element_blank(),
          panel.grid.major.x = element_line(color = "grey10", 
                                            size = 0.2)) +
      labs(x = NULL, y = NULL,
           title = "3, 2, 1, START!",
           subtitle = "Top 20 most energy efficient brands in city driving based on median MPG and MPGe of all models since 1984.\n\n",
           caption = "\n\nVisualization by Cédric Scherer  |  Data: EPA") +
  transition_reveal(state) 
  
animate(df_cars_anim, 
        nframes = 5 * n_distinct(df_cars_top$state), 
        width = 1300, height = 950, 
        fps = 10, detail = 5, 
        start_pause = 5, end_pause = 10,
        renderer = gifski_renderer("car_race.gif")) 
