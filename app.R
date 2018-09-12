library(shiny)
library(shinyjs)
library(shinydashboard)
library(googlesheets)

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

fieldsMandatory <- c("name", "id","age")
fieldsAll <- c("name", "id","age")
df.colnames <- c("Name","NRIC/Passport","Age")
responsesDir <- file.path("responses")
appCSS <- ".mandatory_star { color: red; }"
goggle_sheet_key <- "1AeRjvftIZrx7c14xJ3sPhveQICBK_7FezfKmrs9ORQU"

table <- gs_title("NTC_Database")

ui <- dashboardPage(
  dashboardHeader(
    title = "Discovery Kids 2018"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("New Input", tabName = "new_input", icon = icon("pencil")),
      menuItem("Attendance", tabName = "attendance", icon = icon("check"))
    )
  ),
  dashboardBody(
    tabItems(
      #dashboard tab
      tabItem(tabName = "dashboard", h2("Overview")),
      tabItem(
        tabName = "new_input", 
        h2("New Data Entry"),
        fluidPage(
          shinyjs::useShinyjs(),
          shinyjs::inlineCSS(appCSS),
          div(
            id = "form",
            textInput("name", labelMandatory("Name"), ""),
            textInput("id", labelMandatory("NRIC/Passport Number"), ""),
            textInput("age", labelMandatory("Age"), ""),
            actionButton("submit", "Submit", class = "btn-primary")
          ),
          shinyjs::hidden(
            div(
              id = "thankyou_msg",
              h3("Thanks, your response has been recorded"),
              actionLink("submit_another", "Submit another response")
            )
          )
        )
      ),
      tabItem(tabName = "attendance", h2("Events Check-In"))
    )
  )
)

server <- function(input, output, session) {
  observe({
    # check if all mandatory fields have a value
    mandatoryFilled <-
      vapply(fieldsMandatory,
             function(x) {
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatoryFilled <- all(mandatoryFilled)
    
    # enable/disable the submit button
    shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
    
    formData <- reactive({
      data <- sapply(fieldsAll, function(x) input[[x]])
      # data <- sapply(function(x) input[[x]])
      data <- t(data)
    })
    
    saveData <- function(data) {
      sheet <- gs_key(goggle_sheet_key,lookup = FALSE, visibility = "private")
      # gs_edit_cells(sheet, input = c("Name","NRIC/Passport","Age"), byrow = TRUE, trim = FALSE)
      # gs_add_row(sheet, input = data)
      gs_edit_cells(sheet, input = data, byrow = TRUE)
      gs_add_row(sheet, input = "")
      }
    
    # action to take when submit butty  on is pressed
    observeEvent(input$submit, {
      saveData(formData())
      shinyjs::reset("form")
      shinyjs::hide("form")
      shinyjs::show("thankyou_msg")
    })
    
    observeEvent(input$submit_another, {
      shinyjs::show("form")
      shinyjs::hide("thankyou_msg")
    }) 
    
  })
}

shinyApp(ui, server)

