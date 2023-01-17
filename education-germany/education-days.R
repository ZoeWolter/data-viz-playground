# load packages & theme --------------------------------------------------------
library(openxlsx)
library(tidyverse)
library(ggpubr)

source(here::here('code-general/theme_correlaid.R'))

# load data --------------------------------------------------------------------
# data can be downloaded via https://www.bildungsbericht.de/de/datengrundlagen/daten-2022#1
# df <- readxl::read_excel("data/b3-anhang.xlsx", 
#                          sheet = "Tab. B3-9web", skip = 2)
df <- openxlsx::read.xlsx("https://www.bildungsbericht.de/de/bildungsberichte-seit-2006/bildungsbericht-2022/excel-bildungsbericht-2022/b3-anhang.xlsx", sheet = 10, startRow = 9, colNames = FALSE)

# keep only relevant rows and rename columns
df <- df[1:16, ]
names(df) <- c('Land', as.character(2010:2020))

# geo data ---------------------------------------------------------------------
# data can be downloaded via https://hub.arcgis.com/datasets/ae25571c60d94ce5b7fcbf74e27c00e0/about
geo <- sf::read_sf(here::here('data/vg2500_geo84/vg2500_bld.shp'), 
                   options = "ENCODING=ISO8859-15")

# test
plot(sf::st_geometry(geo))

# maps =========================================================================
# one year ---------------------------------------------------------------------
df_geo <- df %>%
  dplyr::select('Land', 'values' = '2020') %>%
  dplyr::full_join(geo, by = c('Land' = 'GEN')) %>%
  sf::st_as_sf()

ggplot() +
  geom_sf(data = df_geo, aes(fill = values)) +
  geom_sf_text(data = df_geo, aes(label = Land), colour = "white", size = 2) +
  scale_fill_gradient(low = '#acc940', high = '#3c61aa') +
  labs(title = 'Ausgaben je Schüler*in 2020',
       subtitle = 'für öffentliche allgemeinbildende und berufliche Schulen',
       caption = glue::glue('Datenquelle: Nationaler Bildungsbericht \nCorrelAid e.V.'), 
       fill = 'Ausgaben in EUR') +
  guides(fill = guide_colourbar(barwidth = 15, barheight = 0.5)) +
  theme_correlaid() +
  theme(panel.background = element_blank(),
        plot.background = element_rect(fill = "white", color = "black",size = 2),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom")

ggsave(file = here::here('img/map_education.svg'),
       width = 6, height = 9)

# years 2010 to 2020 -----------------------------------------------------------
years <- as.character(2010:2020) 

df_geo <- df %>%
  dplyr::full_join(geo, by = c('Land' = 'GEN')) %>%
  sf::st_as_sf()
df_geo$`2010` <- as.numeric(df_geo$`2010`)

purrr::map(.x = years, ~ {
  ggplot() +
    geom_sf(data = df_geo, aes(fill = .data[[.x]])) +
    scale_fill_gradient(low = '#acc940', high = '#3c61aa') +
    labs(title = .x,
         fill = '') +
    guides(fill = guide_colourbar(barwidth = 15, barheight = 0.5)) +
    theme_correlaid() +
    theme(panel.background = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          legend.position = "bottom")
}) -> g

g_all <- ggarrange(plotlist = g, ncol = 4, nrow = 3, common.legend = TRUE) 

annotate_figure(g_all,
                top = text_grob("Ausgaben je Schüler*in für öffentliche allgemeinbildende und berufliche Schulen", 
                                color = "black", 
                                face = "bold", 
                                family = "Roboto",
                                size = 22),
                bottom = text_grob(glue::glue('Datenquelle: Nationaler Bildungsbericht \nCorrelAid e.V.'), 
                                   color = "black",
                                   family = 'Roboto',
                                   hjust = 1, x = 1, size = 10))

ggsave(file = here::here('img/map_education_dev.svg'),
       width = 12, height = 9)
