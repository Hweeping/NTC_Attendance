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
      # data1 <- sapply(fieldsAll, function(x) input[[x]])
      # data1 <- t(data1)
    })
    
    saveData <- function(data) {
      sheet <- gs_key(goggle_sheet_key,lookup = FALSE, visibility = "private")
      gs_edit_cells(sheet, input = c("Name","NRIC/Passport","Age"), byrow = TRUE, trim = FALSE)
      #gs_add_row(sheet, )
      }
    
    # action to take when submit button is pressed
    observeEvent(input$submit, {
      saveData(formData())
    })
  })
}

shinyApp(ui, server)

