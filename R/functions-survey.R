# Functions for survey analysis

## Tidying functions

### remove question number prefix
remove_q <- function(a_question_df, question_index_number){
  x <- gsub("^[[:digit:]]\\.[[:space:]]", "", a_question_df[question_index_number,"question"])
  return(x)
}


## Graphing functions

library(grid)
library(tidyverse)
library(shadowtext)

### Yes/NO question - prep data for graphing

prep_yn_df <- function(survey_df, question_number){
  question_col <- paste0("Q", question_number)
  
  # select only q1 data
  question_df <- survey_df %>% 
    mutate(
      response = ifelse(str_detect(survey_df[[question_col]], "Yes"), "Yes",
                        ifelse(is.na(survey_df[[question_col]]), "NA", "No")),
      response = factor(response)) %>%
    arrange(desc(survey_df$n)) %>% 
    count(response)
}

### Yes/No question - clean data & horizontal bar chart
mk_yn_fig <- function(preped_df){
  
  # set colors
  BLUE <- "#2A5D82"
  LBLUE <- "#81AEBF"
  BLACK <- "#202020"
  
  fig <- ggplot(preped_df) +
    geom_col(aes(n, response), fill = BLUE, width = 0.6) + 
    scale_x_continuous(
      limits = c(0, 20.5),
      breaks = seq(0, 20, by = 5), 
      expand = c(0, 0), # The horizontal axis does not extend to either side
      position = "bottom"  # Labels are located on the bottom
    ) +
    # The vertical axis extends upwards & down
    scale_y_discrete(expand = expansion(add = c(0.5, 0.5))) +
    theme(
      # Set background color to white
      panel.background = element_rect(fill = "white"),
      # Set the color and the width of the grid lines for the horizontal axis
      panel.grid.major.x = element_line(color = LBLUE, size = 0.3),
      # Remove tick marks by setting their length to 0
      axis.ticks.length = unit(0, "mm"),
      # Remove the title for both axes
      axis.title = element_blank(),
      # Only left line of the vertical axis is painted in black
      axis.line.y.left = element_line(color = "black"),
      # Customize labels from the vertical axis
      axis.text.y = element_text(size = 12),
      # But customize labels for the horizontal axis
      axis.text.x = element_text(size = 12)
    ) +
    geom_shadowtext(
      data = subset(preped_df, n < 2),
      aes(n, y = response, label = n),
      hjust = 0,
      nudge_x = 0.3,
      colour = BLUE,
      bg.colour = "white",
      bg.r = 0.2,
      size = 4
    ) + 
    geom_text(
      data = subset(preped_df, n >= 2),
      aes(n-1.5, y = response, label = n),
      hjust = 0,
      nudge_x = 0.3,
      colour = "white",
      size = 4
    )
  return(fig)
}
