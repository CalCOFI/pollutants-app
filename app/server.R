

shinyServer(function(input, output, session){

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

  # ui_analyte ----
  output$ui_analyte <- renderUI({
    req( input$sel_analyte_class)

    v_analytes <- d_analytes %>%
      filter(
        analyteclass == input$sel_analyte_class) %>%
      pull(analytename)

    selectInput(
      "sel_analyte",
      "Analyte",
      v_analytes)
  })

  # pts
  get_pts <- eventReactive(
    input$sel_analyte,
    {
      d_res %>%
        filter(
          analytename == input$sel_analyte) %>%
        left_join(
          d_smpl,
          by = "labsampleid") %>%
        left_join(
          p_sta,
          by = "stationid") %>%
        st_as_sf()  })

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
    leaflet() |>
      add_basemap(isolate(is_dark())) |>
      addCircleMarkers(
        data  = p, weight = 2, # stroke = F,
        color = ~pal(result),
        label = ~glue("{result} {units}"),
        popup = ~glue(
          "sampledate: {sampledate}<br>
          stationdepth: {stationdepth}<br>
          result: {result} {units}"),
        group = "SCWRRP Stations") %>%
      addLegend(
        pal   = pal, values = p$result,
        title = glue("{input$sel_analyte} ({units})")) %>%
      addLayersControl(
        baseGroups    = c("Toner Lite", "Toner", "NatGeo"),
        overlayGroups = c("SCWRRP Stations"),
        position      = "bottomleft",
        options       = layersControlOptions(collapsed = T))
  })

})
