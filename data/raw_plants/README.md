Plants in Danger

The data this week comes from the [International Union for Conservation of Nature (IUCN) Red list of Threatened Species (Version 2020-1)](https://www.iucnredlist.org) and was scrapped and prepared by [Florent Lavergne](https://www.behance.net/florentlavergne) for his [fantastic and unique infographic](https://www.behance.net/gallery/98304453/Infographic-Plants-in-Danger).

Here is what Florent says about the rationale of this project:

> Just like animals, plants are going through an important biodiversity crisis. Many species from isolated areas are facing extinction due to human activities. Using distribution data from the International Union for Conservation of Nature (IUCN), I designed these network maps to inform on an important yet underrepresented topic.

In total, 500 plant species are considered extinct as of 2020. 19.6% of those were endemic to Madagascar, 12.8% to Hawaiian islands.

### Further reading:

* You can find more details on threatened species, summary statistics, articles, and more on the different Red List categories on the [IUCN main page](https://www.iucnredlist.org/).

* This [study published in Science in 2019](https://advances.sciencemag.org/content/5/11/eaax9444) provides some general information about extinction risks of plants in general and some analyses and visualization about the African flora at risk.

* The IUCN itself shared a [blog post](https://www.iucn.org/news/species/201909/over-half-europes-endemic-trees-face-extinction) on the extinction risk of European endemic trees.

Credit: [Florent Lavergne](https://www.behance.net/florentlavergne) and [Cédric Scherer](twitter.com/@CedScherer)


### Data Dictionary

## `plants_extinct_wide.csv`

|variable         |class     |description                             |
|:----------------|:---------|:---------------------------------------|
|binomial_name    |character | Species name (Genus + species)         |
|country          |character | Country of origin                      |
|continent        |character | Continent of origin                    |
|group            |character | Taxonomic group                        |
|year_last_seen   |character | Period species was last seen           |
|threat_AA        |double    | Threat: Agriculture & Aquaculture      |
|threat_BRU       |double    | Threat: Biological Resource Use        |
|threat_RCD       |double    | Threat: Commercial Development         |
|threat_ISGD      |double    | Threat: Invasive Species               |
|threat_EPM       |double    | Threat: Energy Production & Mining     |
|threat_CC        |double    | Threat: Climate Change                 |
|threat_HID       |double    | Threat: Human Intrusions               |
|threat_P         |double    | Threat: Pollution                      |
|threat_TS        |double    | Threat: Transportation Corridor        |
|threat_NSM       |double    | Threat: Natural System Modifications   |
|threat_GE        |double    | Threat: Geological Events              |
|threat_NA        |double    | Threat unknown                         |
|action_LWP       |double    | Current action: Land & Water Protection|
|action_SM        |double    | Current action: Species Management     |
|action_LP        |double    | Current action: Law & Policy           |
|action_RM        |double    | Current action: Research & Monitoring  |
|action_EA        |double    | Current action: Education & Awareness  |
|action_NA        |double    | Current action unknown                 |
|red_list_category|character | IUCN Red List category                 |

### Cleaning Script

```{r}
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
```
