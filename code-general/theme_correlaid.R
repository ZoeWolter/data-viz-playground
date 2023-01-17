library(tidyverse)
library(rsvg)
library(showtext)

# Load cd fonts
font_add("Roboto", 
         regular = "/Users/correlaid/Library/Fonts/Roboto-Light.ttf")

showtext_auto()

# Use cd colors
colors_correlaid <- c('#acc940', '#96c246', '#6fa080', '#508994', '#3c61aa')

# CReate theme function
theme_correlaid <- function() {
  
  # font family
  font <- "Roboto"
  
  # main theme adjustments
  theme(
    
    # grid elements
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    
    # plot elements
    plot.title = element_text(family = font, 
                              size = 18,
                              face = "bold",
                              hjust = 0,
                              vjust = 1),
    plot.subtitle = element_text(family = font,
                                 size = 15,
                                 hjust = 0,
                                 margin = margin(2,0,2,0)),
    plot.caption = element_text(family = font,
                                size = 10,
                                hjust = 1),
    plot.margin = unit(c(1, 1, 1, 1), 
                       "lines"),
    
    # axis elements
    axis.title = element_text(family = font,
                              size = 12,
                              face = "bold"),
    axis.text = element_text(family = font,
                             size = 12),
    axis.ticks = element_blank(),
    
    # legend elements
    legend.position = "bottom",
    legend.text.align = 0,
    legend.background = element_blank(),
    legend.title = element_text(family = font, 
                                size = 12,
                                face = "bold"),
    legend.key = element_blank(),
    legend.text = element_text(family = font,
                               size = 12),
    
    # panel elements
    panel.grid.minor.x = element_line(color = "#cbcbcb"),
    panel.grid.minor.y = element_line(color = "#cbcbcb"),
    panel.grid.major.y = element_line(color = "#cbcbcb"),
    panel.grid.major.x = element_line(color = "#cbcbcb"),
    panel.background = element_rect(fill = "white"), 
    
    # strip elements
    strip.background = element_rect(fill = "white"),
    strip.text = element_text(family = font,
                              size  = 14,  
                              hjust = 0)
    
  )
}