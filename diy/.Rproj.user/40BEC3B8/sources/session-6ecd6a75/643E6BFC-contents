# LOAD PACKAGES
library(shiny)
library(qualtRics) # for retrieving and processing Qualtrics survey data
library(tidyverse) # for data wrangling and viz
library(urbnthemes) # for styling plots
library(DT) # for creating data tables
# TODO (optional): load any other packages you need


# ------------------------------------------------------------------------------
# SET CREDENTIALS FOR API CALLS
# TODO: replace <THE_TEXT_IN_BRACKETS> with your API credentials and
# run the code below once in your console
# see https://ui-research.github.io/qualtrics-api/setup.html for more detailed 
# setup instructions

# qualtrics_api_credentials(api_key = "<YOUR_QUALTRICS_API_KEY>",
#                           base_url = "<YOUR_QUALTRICS_BASE_URL>",
#                           install = TRUE)


# ------------------------------------------------------------------------------
# HELPER FUNCTIONS
# TODO (optional): define any functions you need to work with your data
# for example, if you need to process your data before you plot it,
# you could write a data processing function here to call in you app
# this can help make your app code easier to read


# ------------------------------------------------------------------------------
# SET PLOT STYLE (FROM URBNTHEMES)
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
    # TODO (optional): update shiny.css to change the dashboard styling
  ),

  titlePanel(NULL),

  sidebarLayout(

    sidebarPanel(

      # refresh data button
      actionButton(inputId = "refresh_data", label = "Refresh Qualtrics data"),

      # white space
      br(), br(),

      # number of responses
      uiOutput(outputId = "n"),

      # date/time of last refresh
      uiOutput(outputId = "last_refresh")

      # TODO (optional): add additional sidebar content

    ),

    mainPanel(

      # TODO: customize your main panel with plots, tables, etc.
      # this starter code (immediately below) displays one plot and one table
      # you will need to provide code for the plot and table
      # in the server function (further below)
      
      # plot
      plotOutput(outputId = "plot"),
      
      # white space
      br(),
      
      # table
      DT::dataTableOutput(outputId = "table")

    )
  )
)

# create server session
server <- function(input, output) {

  # fetch Qualtrics data
  survey <- eventReactive(input$refresh_data, {
    fetch_survey("<YOUR_SURVEY_ID>", # TODO: specify your survey ID
                 label = FALSE, # get answers as numeric values instead of choice text
                 # TODO (optional): customize your function call
                 # run ?fetch_survey in your console for options
                 )
  }, ignoreNULL = FALSE)

  # number of responses
  output$n <- renderUI({
    HTML(paste(strong(nrow(survey())), "responses as of last refresh:"))
  })

  # date/time of last refresh
  output$last_refresh <- eventReactive(input$refresh_data, {
    HTML(format(Sys.time(), "%B %d, %Y %I:%M %p"))
  }, ignoreNULL = FALSE)

  # plot starter code
  for_plot <- eventReactive(input$refresh_data, {
    # TODO (optional): prep your Qualtrics data for your plot
    # if you wrote helper functions above, you can call them here!
  }, ignoreNULL = FALSE)
  
  output$plot <- renderPlot(
    # TODO: add your ggplot code
    # use data = survey() to plot data straight from Qualtrics
    # use data = for_plot() to plot processed data
  )
  
  # table starter code
  for_table <- eventReactive(input$refresh_data, {
    # TODO (optional): prep your Qualtrics data for your table
    # if you wrote helper functions above, you can call them here!
  }, ignoreNULL = FALSE)
  
  output$table <- DT::renderDataTable({
    DT::datatable(
      # use data = survey() to plot data straight from Qualtrics
      # use data = for_table() to plot processed data
                  options = list(
                    # TODO (optional): specify initialization options
                    # see https://datatables.net/reference/option/
                    # option 1,
                    # option 2,
                    # etc.
                  ),
                  # TODO (optional): customize your data table
                  # run ?datatable in your console for options
                  )
  })
  
}  

# build shiny application
shinyApp(ui = ui, server = server)
