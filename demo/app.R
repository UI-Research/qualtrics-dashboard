# LOAD PACKAGES
library(shiny)
library(tidyverse)
library(urbnthemes)
library(tidycensus)
library(qualtRics)
library(lubridate) # for converting Sys.time() to ET
library(DT) # for data table
library(scales) # for formatting plot y-axis

# ------------------------------------------------------------------------------
# SET CREDENTIALS FOR API CALLS
# run this code once in your console

# census_api_key("<YOUR_CENSUS_API_KEY>", install = TRUE)
#
# qualtrics_api_credentials(api_key = "<YOUR_QUALTRICS_API_KEY>",
#                           base_url = "<YOUR_QUALTRICS_BASE_URL>",
#                           install = TRUE)


# ------------------------------------------------------------------------------
# LOAD AND PROCESS ACS DATA
# (Qualtrics data is processed reactively within the app)

acs_2020 <- get_acs(geography = "state",
                  variables = c(
                    "Black" = "B02001_003",
                    "White" = "B02001_002",
                    "Asian" = "B02001_005",
                    "American Indian" = "B02001_004",
                    "Pacific Islander" = "B02001_006",
                    "Other" = "B02001_007",
                    "Two or more" = "B02001_008"),
                  state = "DC",
                  year = 2020)

acs_2020 <- acs_2020 %>%
  select(c(variable, estimate)) %>%
  rename(category = variable, count = estimate) %>%
  mutate(freq = count / sum(count)) %>%
  mutate(source = "ACS")

# ------------------------------------------------------------------------------
# HELPER FUNCTIONS

recode_to_acs <- function(data){

  data <- data %>%
    mutate(num_races = Q5_1 + Q5_2 + Q5_3 + Q5_4 + Q5_5 + Q5_6)

  data <- data %>%
    mutate(acs_race = case_when(
      num_races > 1 ~ "Two or more",
      Q5_1 == 1 ~ "Black",
      Q5_2 == 1 ~ "White",
      Q5_3 == 1 ~ "Asian",
      Q5_4 == 1 ~ "American Indian",
      Q5_5 == 1 ~ "Pacific Islander",
      Q5_6 == 1 ~ "Other"))

  return(data)

}

prep_to_stack <- function(data){

  data <- data %>%
    select(acs_race) %>%
    rename(category = acs_race) %>%
    group_by(category) %>%
    summarize(count = n()) %>%
    mutate(freq = count / sum(count)) %>%
    mutate(source = "Qualtrics")

  return(data)

}

prep_for_table <- function(data){

  data <- select(data, c("category", "freq", "source"))

  data <-  spread(data, source, freq)

  data <- select(data, c("category", "Qualtrics", "ACS"))

  data <- data %>%
    rename(Race = category)

  data <- data %>%
    mutate(Difference = percent((Qualtrics - ACS), accuracy = 0.01)) %>%
    mutate(Qualtrics = percent(Qualtrics, accuracy = 0.01)) %>%
    mutate(ACS = percent(ACS, accuracy = 0.01))

  return(data)

}

# ------------------------------------------------------------------------------
# SET PLOT STYLE

set_urbn_defaults(style = "print")

# ------------------------------------------------------------------------------
# SHINY APP

# set Shiny options
options(shiny.sanitize.errors = TRUE)
options(scipen = 999)

# create user interface
ui <- fluidPage(

  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "shiny.css")
  ),

  titlePanel(NULL), # for a bit of white space at the top of the page

  sidebarLayout(

    sidebarPanel(

      "This dashboard loads",
      a(href = "https://www.qualtrics.com/support/survey-platform/survey-module/survey-tools/generating-test-responses/",
        "computer-generated data"),
      "from an example Qualtrics survey, recodes race into Census Bureau categories,
      and compares the generated demographic data to 2020 American Community Survey
      estimates for Washington, DC.",

      br(), br(),

      actionButton(inputId = "refresh_data", label = "Refresh Qualtrics data"),

      br(), br(),

      uiOutput(outputId = "n"),

      uiOutput(outputId = "last_refresh")

    ),

    mainPanel(

      h2("Respondent Demographics vs. Census Demographic Estimates", align = "center"),

      plotOutput(outputId = "plot"),

      br(),

      DT::dataTableOutput(outputId = "table")

    )
  )
)

# create server session
server <- function(input, output) {

  # fetch Qualtrics data
  survey <- eventReactive(input$refresh_data, {
    fetch_survey("SV_8dfeHisTfwCKCTI", # survey ID for demo survey
                 label = FALSE, # get answers as numeric values instead of choice text
                 convert = FALSE, # prevent fetch_survey() from converting data types
                 unanswer_recode = 0, # recode unselected options to 0 (necessary to compute num_races, see above)
                 force_request = TRUE) # always redownload data from Qualtrics
  }, ignoreNULL = FALSE)

  # number of responses
  output$n <- renderUI({
    HTML(paste(strong(nrow(survey())), "responses as of last refresh:"))
  })

  # last refresh
  output$last_refresh <- eventReactive(input$refresh_data, {
      HTML(format(lubridate::with_tz(Sys.time(),"America/New_York"), "%B %d, %Y %I:%M %p"), "ET")
    }, ignoreNULL = FALSE)

  # process Qualtrics data
  qual_to_stack <- eventReactive(input$refresh_data, {
    survey() %>%
      recode_to_acs() %>%
      prep_to_stack()
  }, ignoreNULL = FALSE)

  # merge ACS and Qualtrics data
  stacked <- eventReactive(input$refresh_data, {
    rbind(acs_2020, qual_to_stack()) %>%
      # set source levels to control display order
      mutate(source = factor(source, levels=c("Qualtrics", "ACS")))
  }, ignoreNULL = FALSE)

  # plot data
  output$plot <- renderPlot(
    ggplot(data = stacked(), aes(x = category, y = freq, fill = source)) +
      geom_bar(stat = "identity", position = "dodge") +
      geom_text(aes(label = percent(freq, accuracy = 0.01)),
                size = 4.5,
                position = position_dodge(width = 0.7),
                vjust = -1) +
      theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust=1, size = 14),
            axis.text.y = element_text(size = 14),
            panel.grid = element_blank(),
            legend.position = "top",
            legend.text = element_text(size=16)) +
      scale_fill_discrete(labels=c("Qualtrics Survey", "Census Data")) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                         limits = c(0, 0.85)) +
      ylab(NULL) +
      xlab(NULL))

  # data table
  for_table <- eventReactive(input$refresh_data, {
    prep_for_table(stacked())
  }, ignoreNULL = FALSE)

  output$table <- DT::renderDataTable({
    DT::datatable(data = for_table(),
                  options = list(paging = FALSE,
                                 searching = FALSE,
                                 info = FALSE),
                  rownames = FALSE)
  })
}

# build shiny application
shinyApp(ui = ui, server = server)
