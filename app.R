library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "Discovery Kids 2018"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("New Input", tabName = "new input", icon = icon("pencil")),
      menuItem("Attendance", tabName = "attendance", icon = icon("check"))
    )
  ),
  dashboardBody(
    tabItems(
      #dashboard tab
      tabItem(tabName = "dashboard", h2("Overview")),
      tabItem(tabName = "new input", h2("New Data Entry"))
    )
  )
)

server <- function(input, output) {}

shinyApp(ui, server)

