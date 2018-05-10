library(shiny)
library(shinydashboard)

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
      tabItem(tabName = "new_input", h2("New Data Entry")),
      tabItem(tabName = "attendance", h2("Events Check-In"))
    )
  )
)

server <- function(input, output) {}

shinyApp(ui, server)

