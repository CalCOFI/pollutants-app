

shinyServer(function(input, output, session){

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

    leaflet() %>%
      addProviderTiles(
        "Esri.OceanBasemap",
        options = providerTileOptions(
          variant = "Ocean/World_Ocean_Base",
          opacity = 0.4)) |>
      # add reference: placename labels and borders
      addProviderTiles(
        "Esri.OceanBasemap",
        options = providerTileOptions(
          variant = "Ocean/World_Ocean_Reference",
          opacity = 0.4)) |>
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
