library(shiny)
library(shinyjs)
library(shinydashboard)

fieldsMandatory <- c("name", "age")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}
appCSS <- ".mandatory_star { color: red; }"

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
  })
}

shinyApp(ui, server)

