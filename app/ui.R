# a function of the request so the dark/light switch can start in the theme the
# request asks for (?theme= or the cc_theme cookie); see calcofi4r::cc_theme()
function(request) navbarPage(
  # navbarPage owns the top bar, so the calcofi.io logo (linking home; theme.css
  # shows one variant per theme) sits in its brand slot beside the title, and
  # the dark/light switch in a nav_item at the right — not a second bar
  title = tagList(
    a(href = "https://calcofi.io", `aria-label` = "CalCOFI.io home",
      img(class = "cc-logo-dark",  alt = "CalCOFI", height = "32px",
          src = "https://calcofi.io/brand/v1/logo_calcofi.svg"),
      img(class = "cc-logo-light", alt = "CalCOFI", height = "32px",
          src = "https://calcofi.io/brand/v1/logo_calcofi_light.svg")),
    "SoCal Marine Pollutants"),
  # cc_brand_head() owns the one <title>, the favicon set, theme.css/js and GA4
  windowTitle = NULL,
  header = tagList(
    tags$head(
      calcofi4r::cc_brand_head("SoCal Marine Pollutants", ga_app = "pollutants")),
    tags$style(type = "text/css", "#map {height: calc(100vh - 106px) !important;}")),
  theme = bs_theme(
    version = 5,
    code_font = font_collection(
      "OpenSans", "SFMono-Regular", "Menlo", "Monaco", "Consolas",
      "Liberation Mono", "Courier New", "monospace"),
    heading_font = font_google("Kdam Thmor Pro")),
  tabPanel(
    "Map",
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
  # tabPanel(
  #   "Download",
  #   "TODO"),
  # tabPanel(
  #   "Upload",
  #   "TODO"),
  tabPanel(
    "About",
    includeMarkdown("about.md")),
  # navbarMenu(
  #   "More",
  #   tabPanel(
  #     "Summary"),
  #   "----",
  #   "Section header",
  #   tabPanel(
  #     "Table"))
  bslib::nav_spacer(),
  bslib::nav_item(
    bslib::input_dark_mode(id = "dark_toggle", mode = calcofi4r::cc_theme(request)))
)
