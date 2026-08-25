function(input, output, session) {

  # bookmarking ----
  # theme is a preference, not a view; leaflet's own map_* inputs (bounds, zoom,
  # clicks) are re-derived, and the view is carried explicitly as values below
  observe(setBookmarkExclude(c(
    "dark_toggle", "nav", grep("^map_", names(input), value = TRUE))))

  # keep the address bar current so any moment is shareable without the button
  observe({
    input$sel_analyte_class; input$sel_analyte; input$map_zoom; input$map_center
    session$doBookmark()
  })
  onBookmarked(function(url) updateQueryString(url))

  # the map view rides along as values (leaflet inputs are excluded above)
  onBookmark(function(state) {
    state$values$zoom   <- input$map_zoom
    state$values$center <- input$map_center
  })
  restore_view    <- reactiveVal(NULL)
  restore_analyte <- reactiveVal(NULL)
  onRestore(function(state) {
    if (!is.null(state$values$zoom))
      restore_view(list(zoom = state$values$zoom, center = state$values$center))
    # the analyte input restores its value only once its choices hold it, which
    # happens in the class observer below
    restore_analyte(state$input$sel_analyte)
  })

  # analyte follows analyte class ----
  observeEvent(input$sel_analyte_class, {
    v <- analytes_for(input$sel_analyte_class)
    want <- restore_analyte() %||% isolate(input$sel_analyte)
    restore_analyte(NULL)
    updateSelectInput(
      session, "sel_analyte", choices = v,
      selected = if (!is.null(want) && want %in% v) want else v[1])
  })

  # theme ----
  # the header's dark/light switch (id "dark_toggle"); the basemap follows it
  is_dark <- reactive(calcofi4r::cc_is_dark(input))

  # basemap per theme, in one group so a flip can swap it under the markers:
  # Esri Ocean (base + reference labels) on light, Carto Dark Matter on dark
  add_basemap <- function(map, dark) {
    if (dark) {
      return(addProviderTiles(map, "CartoDB.DarkMatter", group = "basemap"))
    }
    map |>
      addProviderTiles(
        "Esri.OceanBasemap",
        group   = "basemap",
        options = providerTileOptions(
          variant = "Ocean/World_Ocean_Base",
          opacity = 0.4)) |>
      # add reference: placename labels and borders
      addProviderTiles(
        "Esri.OceanBasemap",
        group   = "basemap",
        options = providerTileOptions(
          variant = "Ocean/World_Ocean_Reference",
          opacity = 0.4))
  }

  # dark / light toggle -> basemap swap, without re-rendering the markers
  observeEvent(input$dark_toggle, {
    leafletProxy("map") |>
      clearGroup("basemap") |>
      add_basemap(is_dark())
  }, ignoreInit = TRUE)

  # pts ----
  get_pts <- reactive({
    req(input$sel_analyte, input$sel_analyte_class)
    # the analyte input lags the class by one flush while its choices update;
    # a value from the previous class is not a selection
    req(input$sel_analyte %in% analytes_for(input$sel_analyte_class))
    d_res %>%
      filter(analytename == input$sel_analyte) %>%
      left_join(d_smpl, by = "labsampleid") %>%
      left_join(p_sta,  by = "stationid") %>%
      st_as_sf()
  })

  # map ----
  output$map <- renderLeaflet({
    p <- get_pts()

    units <- d_analytes %>%
      filter(
        analyteclass == input$sel_analyte_class,
        analytename  == input$sel_analyte) %>%
      pull(units)

    pal <- colorNumeric(
      palette = "Spectral",
      domain  = p$result,
      reverse = T)

    # isolate: a theme flip swaps the basemap by proxy, not a full re-render
    m <- leaflet() |>
      add_basemap(isolate(is_dark())) |>
      addCircleMarkers(
        data  = p, weight = 2,
        color = ~pal(result),
        label = ~glue("{result} {units}"),
        popup = ~glue(
          "sampledate: {sampledate}<br>
          stationdepth: {stationdepth}<br>
          result: {result} {units}"),
        group = "SCCWRP Stations") %>%
      addLegend(
        pal   = pal, values = p$result,
        title = glue("{input$sel_analyte} ({units})")) %>%
      addLayersControl(
        overlayGroups = c("SCCWRP Stations"),
        position      = "bottomleft",
        options       = layersControlOptions(collapsed = T))

    # a restored bookmark reopens at the sender's view, once
    v <- isolate(restore_view())
    if (!is.null(v)) {
      restore_view(NULL)
      m <- m |> setView(lng = v$center$lng, lat = v$center$lat, zoom = v$zoom)
    }
    m
  })
}
