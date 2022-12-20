navbarPage(
  "CA Marine Pollutants App",
  theme = bs_theme(
    bootswatch = "darkly",
    code_font = font_collection(
      "OpenSans", "SFMono-Regular", "Menlo", "Monaco", "Consolas",
      "Liberation Mono", "Courier New", "monospace"),
    heading_font = font_google("Kdam Thmor Pro")),
  tags$style(type = "text/css", "#map {height: calc(100vh - 106px) !important;}"),
  tabPanel(
    "Query",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectInput(
          "sel_analyte_class",
          "Analyte Class",
          v_analyteclasses),
        uiOutput(
          "ui_analyte") ),
      mainPanel(
        width = 10,
        leafletOutput("map") ) ) ),
  tabPanel(
    "Download",
    "TODO"),
  tabPanel(
    "Submit",
    "TODO"),
  tabPanel(
    "About",
    includeMarkdown("about.md")),
  navbarMenu(
    "More",
    tabPanel(
      "Summary"),
    "----",
    "Section header",
    tabPanel(
      "Table"))
)
