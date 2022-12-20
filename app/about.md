<div class="container">

<div class="row">
  <div class="col">
  <img src="logo_calcofi.png" class="img-fluid rounded float-start">
  </div>
  <div class="col">
  <img src="logo_sccwrp.jpeg" class="img-fluid rounded float-end">
  </div>
</div>

## About

This preliminary application was built by [Ben Best](https://bbest.github.io/about.html) (<ben@ecoquants.com>) while consulting for [CalCOFI](https://calcofi.org) and motivated to more easily map and query pollutants in the Southern California Bight based on presentations at the half-day workshop **Incorporating & coordinating pollutant time series into a California pollutant monitoring program** led by [Matt Savoca](https://hopkinsmarinestation.stanford.edu/people/matthew-scott-savoca) (Stanford) at the [CalCOFI Conference - Dec 7, 2022](https://calcofi.org/conference/conference-2022/) with presentations by:

- [Scott Coffin](https://scottcoff.in) (CA Water Board)\
  Legislative drivers for microplastics, PFAS, ubiquitous tire chemical (6PPD Quinone)
- [Amalia Almada](https://dornsife.usc.edu/uscseagrant/amalia-almada) (USC) & [Lian Guo](https://caseagrant.ucsd.edu/profiles/lian-guo) (California Sea Grant)\
  DDT+ Research Needs Assessment report
- [Noelle Bowlin](https://www.linkedin.com/in/noelle-bowlin-16294910/) (NOAA CalCOFI)\
  CalCOFI Pollutant Sampling Efforts
- [Karen McLaughlin](https://www.sccwrp.org/about/staff/karen-mclaughlin) (SCCWRP)\
  SCCWRP Pollutant Sampling Efforts

Karen McLaughlin presented on the [Southern California Bight Regional Monitoring Program | SCCWRP](https://www.sccwrp.org/about/research-areas/regional-monitoring/southern-california-bight-regional-monitoring-program/), from which tabular (*.csv) files were downloaded by navigating via the following:

* [Bight Regional Monitoring | ArcGIS.com](https://bight-sccwrp.opendata.arcgis.com/)
  * [Bight '18 Regional Monitoring](https://bight-sccwrp.opendata.arcgis.com/pages/0ae7c88b8ba44176861714d08dd0955c)
    * [Bight '18 Sediment Chemistry Harmonized](https://bight-sccwrp.opendata.arcgis.com/datasets/d32463cef04447c3a316fc470b4ba479_0/explore?location=33.491183%2C-118.652111%2C9.35)\
    `Bight_18_Sediment_Chemistry_Harmonized.csv`
  * [Bight '13 Regional Monitoring](https://bight-sccwrp.opendata.arcgis.com/pages/0151441975644372ab11b2a83d3710e1)
    * [Bight '13 Sediment Chemistry Harmonized](https://bight-sccwrp.opendata.arcgis.com/datasets/311d9574e33743bd97cecaef1362ac6c_0/explore?location=33.486346%2C-118.797521%2C9.38)\
    `Bight_13_Sediment_Chemistry_Harmonized.csv`
  * [Bight '08 Regional Monitoring](https://bight-sccwrp.opendata.arcgis.com/pages/8e199abaf00b4dda94c17ee61023dbea)
    * [Bight '08 Sediment Chemistry Harmonized](https://bight-sccwrp.opendata.arcgis.com/datasets/424eec5bdde546dc8c393919913df413_0/explore?location=33.487805%2C-118.837600%2C9.47)\
    `Bight_08_Sediment_Chemistry_Harmonized.csv`

To see how these data were processed and displayed, see the R code here:

* Script: [Process SCCWRP Bight Data](http://calcofi.io/pollutants-app/process_sccwrp.html)
* App: [github.com/CalCOFI/pollutants-app: app](https://github.com/CalCOFI/pollutants-app/tree/main/app)

</div>
