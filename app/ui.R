# a function of the request so (a) bookmark state restores from the URL and
# (b) the dark/light switch starts in the theme the request asks for
# (?theme= or the cc_theme cookie); see calcofi4r::cc_theme()
function(request) page_navbar(
  id       = "nav",
  fillable = "Map",   # the map panel fills the viewport; About scrolls
  # page_navbar owns the top bar, so the calcofi.io logo (linking home;
  # theme.css shows one variant per theme) sits in its brand slot beside the
  # title, and the dark/light switch in a nav_item at the right — not a second bar
  title = tags$span(
    class = "d-inline-flex align-items-center gap-2",
    a(href = "https://calcofi.io", `aria-label` = "CalCOFI.io home",
      class = "d-inline-flex align-items-center text-decoration-none",
      img(class = "cc-logo-dark",  alt = "CalCOFI", height = "32px",
          src = "https://calcofi.io/brand/v2/logo_calcofi_h.svg"),
      img(class = "cc-logo-light", alt = "CalCOFI", height = "32px",
          src = "https://calcofi.io/brand/v2/logo_calcofi_h_light.svg")),
    "SoCal Marine Pollutants"),
  # cc_brand_head() owns the one <title>, the favicon set, theme.css/js and GA4
  window_title = NA,
  header = tags$head(
    calcofi4r::cc_brand_head("SoCal Marine Pollutants", ga_app = "pollutants")),
  theme = bs_theme(
    version = 5,
    code_font = font_collection(
      "OpenSans", "SFMono-Regular", "Menlo", "Monaco", "Consolas",
      "Liberation Mono", "Courier New", "monospace"),
    heading_font = font_google("Kdam Thmor Pro")),

  nav_panel(
    "Map",
    layout_sidebar(
      fillable = TRUE,
      sidebar  = sidebar(
        width = 280,
        selectInput(
          "sel_analyte_class", "Analyte Class",
          choices  = v_analyteclasses,
          selected = DEFAULT_ANALYTE_CLASS),
        # choices follow the class (server), so the input is static and a
        # bookmarked value restores into it
        selectInput(
          "sel_analyte", "Analyte",
          choices  = analytes_for(DEFAULT_ANALYTE_CLASS),
          selected = DEFAULT_ANALYTE),
        helpText(
          class = "small",
          "Sediment chemistry from the Southern California Bight Regional",
          "Monitoring Program (SCCWRP). The URL follows your selection and",
          "map view, so it can be shared as is.")),
      leafletOutput("map", height = "100%"))),

  nav_panel(
    "About",
    div(class = "container-lg py-3", includeMarkdown("about.md"))),

  nav_spacer(),
  nav_item(
    # opens the share modal with the current bookmark URL (the address bar
    # already carries it — this is for copying deliberately)
    bookmarkButton(label = "Share", icon = icon("share-nodes"),
                   class = "btn-sm btn-outline-secondary")),
  nav_item(
    bslib::input_dark_mode(id = "dark_toggle", mode = calcofi4r::cc_theme(request)))
)
