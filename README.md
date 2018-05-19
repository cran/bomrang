*bomrang*: Australian Government Bureau of Meteorology Data from R
================

[![CircleCI](https://circleci.com/gh/ropensci/bomrang.svg?style=shield)](https://circleci.com/gh/ropensci/bomrang) [![Appveyor](https://ci.appveyor.com/api/projects/status/au6p6qy1ah2lrtl5/branch/master?svg=true)](https://ci.appveyor.com/project/adamhsparks/bomrang/branch/master) [![codecov](https://codecov.io/gh/ropensci/bomrang/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/bomrang) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.598301.svg)](https://doi.org/10.5281/zenodo.598301)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/bomrang)](https://cran.r-project.org/package=bomrang)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![](https://badges.ropensci.org/121_status.svg)](https://github.com/ropensci/onboarding/issues/121)
[![JOSS status](http://joss.theoj.org/papers/350bf005bded599e4b0f3ac2acf138e8/status.svg)](http://joss.theoj.org/papers/350bf005bded599e4b0f3ac2acf138e8)

<img align="right" src="man/figures/bomrang-hex.png"> Provides functions to interface with Australian Government Bureau of Meteorology (BOM) data, fetching data and returning a tidy data frame of précis forecasts, current weather data from stations, ag information bulletins, historical weather data or a `raster::stack()` object of satellite imagery from GeoTIFF files.

Credit for the name, *bomrang*, goes to [Di Cook](http://dicook.github.io), who suggested it while attending the rOpenSci AUUnconf in Brisbane, 2016, upon seeing the [vignette](https://github.com/saundersk1/auunconf16/blob/master/Vignette_BOM.pdf) that we had assembled during the Unconf.

Quick Start
-----------

Install the stable release from CRAN.

``` r
install.packages("bomrang")
```

Or from GitHub for the version in development.

``` r
if (!require("devtools")) {
  install.packages("devtools", repos = "http://cran.rstudio.com/")
  library("devtools")
}

devtools::install_github("ropensci/bomrang")
```

Using *bomrang*
---------------

Several functions are provided by *bomrang* to retrieve Australian Bureau of Meteorology (BOM) data. A family of functions retrieve weather data and return tidy data frames; `get_precis_forecast()`, which retrieves the précis (short) forecast; `get_current_weather()`, which fetches the current weather from a given station; `get_ag_bulletin()`, which retrieves the agriculture bulletin; `get_weather_bulletin()`, which retrieves the BOM 0900 or 1500 bulletins; and `get_historical()`, which retrieves historical daily observations for a given station. A second group of functions retrieve information pertaining to satellite imagery, `get_available_imagery()` and the imagery itself, `get_satellite_imagery()`.

### Using `get_current_weather`

Returns the latest 72 hours weather observations for a station.

This function accepts four arguments:

-   `station_name`, The name of the weather station. Fuzzy string matching via `base::agrep` is done.

-   `latlon`, A length-2 numeric vector. When given instead of station\_name, the nearest station (in this package) is used, with a message indicating the nearest such station. (See also `sweep_for_stations()`.) Ignored if used in combination with `station_name`, with a warning.

-   `raw`, Logical. Do not convert the columns data.table to the appropriate classes. (FALSE by default.)

-   `emit_latlon_msg`, Logical. If `TRUE` (the default), and `latlon` is selected, a message is emitted before the table is returned indicating which station was actually used (i.e. which station was found to be nearest to the given coordinate).

#### Results of `get_current_weather`

The function, `get_current_weather()` will return a tidy data frame of the current and past 72 hours observations for the requested station. For a complete listing of the fields in the data frame see Appendix 1, `Output from get_current_weather()` in the *bomrang* vignette.

#### Example Using `get_current_weather`

Following is an example fetching the current weather for Melbourne.

``` r
library("bomrang")
```

    ## 
    ## Data (c) Australian Government Bureau of Meteorology,
    ## Creative Commons (CC) Attribution 3.0 licence or
    ## Public Access Licence (PAL) as appropriate.
    ## See http://www.bom.gov.au/other/copyright.shtml

``` r
Melbourne_weather <- get_current_weather("Melbourne (Olympic Park)")
head(Melbourne_weather)
```

    ##   sort_order   wmo                full_name history_product
    ## 1          0 95936 Melbourne (Olympic Park)        IDV60801
    ## 2          1 95936 Melbourne (Olympic Park)        IDV60801
    ## 3          2 95936 Melbourne (Olympic Park)        IDV60801
    ## 4          3 95936 Melbourne (Olympic Park)        IDV60801
    ## 5          4 95936 Melbourne (Olympic Park)        IDV60801
    ## 6          5 95936 Melbourne (Olympic Park)        IDV60801
    ##   local_date_time local_date_time_full        aifstime_utc      lat
    ## 1      18/05:30pm  2017-08-18 17:30:00 2017-08-18 07:30:00 -37.8255
    ## 2      18/05:00pm  2017-08-18 17:00:00 2017-08-18 07:00:00 -37.8255
    ## 3      18/04:30pm  2017-08-18 16:30:00 2017-08-18 06:30:00 -37.8255
    ## 4      18/04:00pm  2017-08-18 16:00:00 2017-08-18 06:00:00 -37.8255
    ## 5      18/03:30pm  2017-08-18 15:30:00 2017-08-18 05:30:00 -37.8255
    ## 6      18/03:00pm  2017-08-18 15:00:00 2017-08-18 05:00:00 -37.8255
    ##        lon apparent_t cloud cloud_base_m cloud_oktas cloud_type
    ## 1 144.9816        5.7     -           NA          NA          -
    ## 2 144.9816        5.7     -           NA          NA          -
    ## 3 144.9816        5.7     -           NA          NA          -
    ## 4 144.9816        6.9     -           NA          NA          -
    ## 5 144.9816        6.7     -           NA          NA          -
    ## 6 144.9816        6.5     -           NA          NA          -
    ##   cloud_type_id delta_t gust_kmh gust_kt air_temp dewpt  press press_msl
    ## 1            NA     1.7       22      12      9.2   5.4 1015.6    1015.6
    ## 2            NA     2.1       24      13      9.4   4.6 1015.2    1015.2
    ## 3            NA     3.1       32      17     10.4   3.4 1014.4    1014.4
    ## 4            NA     3.2       30      16     11.1   3.9 1013.7    1013.7
    ## 5            NA     2.6       28      15     10.7   5.0 1013.4    1013.4
    ## 6            NA     1.9       20      11      9.6   5.4 1013.1    1013.1
    ##   press_qnh press_tend rain_trace rel_hum sea_state swell_dir_worded
    ## 1    1015.6          -        1.4      77         -                -
    ## 2    1015.2          -        1.2      72         -                -
    ## 3    1014.4          -        1.0      62         -                -
    ## 4    1013.7          -        1.0      61         -                -
    ## 5    1013.4          -        1.0      68         -                -
    ## 6    1013.1          -        1.0      75         -                -
    ##   swell_height swell_period vis_km weather wind_dir wind_spd_kmh
    ## 1           NA           NA     10       -        W           13
    ## 2           NA           NA     10       -      WSW           13
    ## 3           NA           NA     10       -        W           17
    ## 4           NA           NA     10       -        W           15
    ## 5           NA           NA     10       -      WSW           15
    ## 6           NA           NA     10    Rain      WSW           11
    ##   wind_spd_kt
    ## 1           7
    ## 2           7
    ## 3           9
    ## 4           8
    ## 5           8
    ## 6           6

### Using `get_precis_forecast`

This function only takes one argument, `state`. States or territories are specified using the official postal codes.

-   **ACT** - Australian Capital Territory

-   **NSW** - New South Wales

-   **NT** - Northern Territory

-   **QLD** - Queensland

-   **SA** - South Australia

-   **TAS** - Tasmania

-   **VIC** - Victoria

-   **WA** - Western Australia

-   **AUS** - Australia, returns national forecast including all states or territories.

#### `get_precis_forecast` Results

The function `get_precis_forecast()` will return a tidy data frame of BOM data for the requested state(s) or territory. For a complete listing of the fields in the data frame see Appendix 2, `Output from get_precis_forecast()` in the *bomrang* vignette.

#### Example Using `get_precis_forecast`

Following is an example fetching the précis forecast for Queensland.

``` r
QLD_forecast <- get_precis_forecast(state = "QLD")
head(QLD_forecast)
```

    ##   index product_id state     town       aac      lat      lon elev
    ## 1     0   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ## 2     1   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ## 3     2   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ## 4     3   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ## 5     4   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ## 6     5   IDQ11295   QLD Brisbane QLD_PT001 -27.4808 153.0389  8.1
    ##      start_time_local end_time_local UTC_offset      start_time_utc
    ## 1 2017-08-13 05:00:00     2017-08-14      10:00 2017-08-12 19:00:00
    ## 2 2017-08-14 00:00:00     2017-08-15      10:00 2017-08-13 14:00:00
    ## 3 2017-08-15 00:00:00     2017-08-16      10:00 2017-08-14 14:00:00
    ## 4 2017-08-16 00:00:00     2017-08-17      10:00 2017-08-15 14:00:00
    ## 5 2017-08-17 00:00:00     2017-08-18      10:00 2017-08-16 14:00:00
    ## 6 2017-08-18 00:00:00     2017-08-19      10:00 2017-08-17 14:00:00
    ##          end_time_utc minimum_temperature maximum_temperature
    ## 1 2017-08-13 14:00:00                  NA                  26
    ## 2 2017-08-14 14:00:00                  12                  26
    ## 3 2017-08-15 14:00:00                  12                  28
    ## 4 2017-08-16 14:00:00                  14                  30
    ## 5 2017-08-17 14:00:00                  15                  30
    ## 6 2017-08-18 14:00:00                  16                  27
    ##   lower_precipitation_limit upper_precipitation_limit precis
    ## 1                         0                         0 Sunny.
    ## 2                         0                         0 Sunny.
    ## 3                         0                         0 Sunny.
    ## 4                         0                         0 Sunny.
    ## 5                         0                         0 Sunny.
    ## 6                         0                         0 Sunny.
    ##   probability_of_precipitation
    ## 1                            5
    ## 2                            0
    ## 3                            0
    ## 4                            0
    ## 5                            5
    ## 6                            0

### Using `get_ag_bulletin`

This function only takes one argument, `state`. The `state` parameter allows the user to select the bulletin for just one state or a national bulletin. States or territories are specified using the official postal codes.

-   **NSW** - New South Wales

-   **NT** - Northern Territory

-   **QLD** - Queensland

-   **SA** - South Australia

-   **TAS** - Tasmania

-   **VIC** - Victoria

-   **WA** - Western Australia.

#### `get_ag_bulletin` Results

The function `get_ag_bulletin()` will return a tidy data frame of BOM data for the requested state(s) or territory. For a complete listing of the fields in the data frame see Appendix 3, `Output from get_ag_bulletin()` in the *bomrang* vignette.

#### Example Using `get_ag_bulletin`

Following is an example fetching the ag bulletin for Queensland.

``` r
QLD_bulletin <- get_ag_bulletin(state = "QLD")
head(QLD_bulletin)
```

    ##   product_id state dist   wmo  site          station
    ## 1   IDQ60604   QLD   38 95482 38026       Birdsville
    ## 2   IDQ60604   QLD   40 94578 40842 Brisbane Airport
    ## 3   IDQ60604   QLD   39 94387 39128        Bundaberg
    ## 4   IDQ60604   QLD   31 94287 31011           Cairns
    ## 5   IDQ60604   QLD   44 94510 44021      Charleville
    ## 6   IDQ60604   QLD   33 94360 33013     Collinsville
    ##                  full_name      obs_time_local        obs_time_utc
    ## 1       BIRDSVILLE AIRPORT 2017-08-13 09:00:00 2017-08-12 23:00:00
    ## 2            BRISBANE AERO 2017-08-13 09:00:00 2017-08-12 23:00:00
    ## 3           BUNDABERG AERO 2017-08-13 09:00:00 2017-08-12 23:00:00
    ## 4              CAIRNS AERO 2017-08-13 09:00:00 2017-08-12 23:00:00
    ## 5         CHARLEVILLE AERO 2017-08-13 09:00:00 2017-08-12 23:00:00
    ## 6 COLLINSVILLE POST OFFICE 2017-08-13 09:00:00 2017-08-12 23:00:00
    ##   time_zone      lat      lon  elev bar_ht start  end r   tn   tx twd  ev
    ## 1       EST -25.8975 139.3472  46.6   47.0  2000 2017 0  9.8 27.6 8.4  NA
    ## 2       EST -27.3917 153.1292   4.5    9.5  1992 2017 0 11.5 25.3 5.6 3.4
    ## 3       EST -24.9069 152.3230  30.8   31.5  1942 2017 0 10.3 27.5 2.7  NA
    ## 4       EST -16.8736 145.7458   2.2    8.3  1941 2017 0 18.8 28.8 5.2  NA
    ## 5       EST -26.4139 146.2558 301.6  303.3  1942 2017 0  6.8 29.3 8.0  NA
    ## 6       EST -20.5533 147.8464 196.0     NA  1939 2017 0  8.0 28.2 3.1 5.2
    ##    tg  sn   t5  t10  t20  t50  t1m  wr
    ## 1  NA  NA   NA   NA   NA   NA   NA  NA
    ## 2 9.5 8.6 16.0 17.0 18.0 18.0 19.0 158
    ## 3  NA  NA 17.8 18.3 19.6 19.1 20.7  NA
    ## 4  NA  NA   NA   NA   NA   NA   NA  NA
    ## 5  NA  NA   NA   NA   NA   NA   NA  NA
    ## 6  NA  NA   NA   NA   NA   NA   NA  NA
    
### Using `get_weather_bulletin`

This function takes two arguments, `state` for the desired state; and `morning`
if `TRUE`, return the 9am bulletin for the nominated state; otherwise return the
3pm bulletin.  States or territories are specified using the official postal codes.

-   **ACT**  Australian Capital Territory (will return NSW)

-   **NSW** - New South Wales

-   **NT** - Northern Territory

-   **QLD** - Queensland

-   **SA** - South Australia

-   **TAS** - Tasmania

-   **VIC** - Victoria

-   **WA** - Western Australia

-   **AUS** - Australia, returns bulletin for all states/territories.

#### `get_weather_bulletin` Results

The function `get_weather_bulletin()` will return a tidy data frame of BOM data
for the requested state(s) or territory.

#### Example using `get_weather_bulletin`

Following is an example fetching the 3PM bulletin for Queensland.

``` r
qld_weather <- get_weather_bulletin(state = "QLD")
head(qld_weather)
```

    ##         stations cld8ths wind_dir wind_speed_kmh temp_c_dry temp_c_dew
    ## 1     Coconut Is      NA       SE              4         27         NA
    ## 2        Coen Ap      NA      NNE              9         23         16
    ## 3        Horn Is      NA      ESE             17         25         19
    ## 4 Lockhart River      NA       SE             11         23         19
    ## 5    Palmerville      NA        S              7         22         14
    ## 6       Scherger      NA        E              9         25         18
    ##   temp_c_max temp_c_min temp_c_gr barhpa rain_mm weather seastate
    ## 1         31         23        NA   1014      NA                 
    ## 2         31         14        NA   1014      NA                 
    ## 3         29         21        NA   1014      NA                 
    ## 4         29         15        NA   1015      NA                 
    ## 5         35         13        NA   1015      NA                 
    ## 6         34         17        NA   1014      NA

## Using `get_historical`

`get_historical()` takes either of two arguments: `stationid` and `latlon`, as 
well as a type of observation (`"rain"`, `"min"` (temperature), `"max"`
(temperature), or `"solar"`), returning the historical daily weather
observations of that type for the given location.

If `latlon` is used, the observations returned are from the station nearest to
that latitude-longitude coordinate. `latlon` values are entered as decimal
degrees, _e.g._ -34, 151 for Sydney. The function also emits a message, to
tell the user which station was used.

### Results

The table returned may have different fields depending on the station that is
selected. The time period over which observations are available will be highly
dependent on the station requested. Some stations may only have a decade or less
of data  (e.g. max temperature at `070351 (CANBERRA AIRPORT)` has ~3,700+
observations back to 2008) while others may have very extensive records (e.g.
rainfall at `ADELAIDE (WEST TERRACE / NGAYIRDAPIRA)` has ~65,000+ observations
back to 1839, three years after the city was founded.) 

### Example

Following is an example fetching the historical daily temperature minimum
observations for the station closest to 35.2809°S, 149.1300°E (Canberra)

```r
Canberra_mintemps <- get_historical(latlon = c(-35.2809, 149.1300),
                                    type = "min")
```

    ## Closest station: 070351 (CANBERRA AIRPORT)
    ## trying URL 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=070351&p_c=-989869218&p_nccObsCode=123'
    ## Content type 'application/zip' length 19508 bytes (19 KB)
    ## ==================================================
    ## downloaded 19 KB
    ##
    ## Data saved as /var/folders/47/rh3mqv4j3w31bch7f_tcj3jr0000gn/T//RtmpVxfght/IDCJAC0011_070351_1800_Data.csv

``` r
head(Canberra_mintemps)
```

    ##   Product.code Bureau.of.Meteorology.station.number Year Month Day Minimum.temperature..Degree.C. Days.of.accumulation.of.minimum.temperature Quality
    ## 1   IDCJAC0011                                70351 2008     1   1                             NA                                          NA        
    ## 2   IDCJAC0011                                70351 2008     1   2                             NA                                          NA        
    ## 3   IDCJAC0011                                70351 2008     1   3                             NA                                          NA        
    ## 4   IDCJAC0011                                70351 2008     1   4                             NA                                          NA        
    ## 5   IDCJAC0011                                70351 2008     1   5                             NA                                          NA        
    ## 6   IDCJAC0011                                70351 2008     1   6                             NA                                          NA        

### Using `get_satellite_imagery`

_bomrang_ provides two functions to check and retrieve satellite imagery from
BOM, `get_available_imagery()` and `get_satellite_imagery()`.

The function `get_available_imagery()` only takes one argument, `product_id`, a
BOM identifier for the imagery that you wish to check for available imagery.
Using this function will fetch a listing of BOM GeoTIFF satellite imagery from
<ftp://ftp.bom.gov.au/anon/gen/gms/> to display which files are currently
available for download. These files are available at ten minute update frequency
with a 24 hour delete time. This function can be used see the most recent files
available and then specify in the `get_satellite_imagery()` function. If no
valid Product ID is supplied, defaults to all GeoTIFF images currently
available.

#### Example using `get_available_imagery`

``` r
# Most recent 5 images available for IDE00425
avail <- get_available_imagery(product_id = "IDE00426")
```

    ## 
    ## The following files are currently available for download:

    ##   [1] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120210.tif"
    ##   [2] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120220.tif"
    ##   [3] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120230.tif"
    ##   [4] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120250.tif"
    ##   [5] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120300.tif"
    ##   [6] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120310.tif"
    ##   [7] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120320.tif"
    ##   [8] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120330.tif"
    ##   [9] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120340.tif"
    ##  [10] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120350.tif"
    ##  [11] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120400.tif"
    ##  [12] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120410.tif"
    ##  [13] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120420.tif"
    ##  [14] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120430.tif"
    ##  [15] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120440.tif"
    ##  [16] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120450.tif"
    ##  [17] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120500.tif"
    ##  [18] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120510.tif"
    ##  [19] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120520.tif"
    ##  [20] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120530.tif"
    ##  [21] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120540.tif"
    ##  [22] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120550.tif"
    ##  [23] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120600.tif"
    ##  [24] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120610.tif"
    ##  [25] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120620.tif"
    ##  [26] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120630.tif"
    ##  [27] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120640.tif"
    ##  [28] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120650.tif"
    ##  [29] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120700.tif"
    ##  [30] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120710.tif"
    ##  [31] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120720.tif"
    ##  [32] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120730.tif"
    ##  [33] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120740.tif"
    ##  [34] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120750.tif"
    ##  [35] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120800.tif"
    ##  [36] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120810.tif"
    ##  [37] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120820.tif"
    ##  [38] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120830.tif"
    ##  [39] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120840.tif"
    ##  [40] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120850.tif"
    ##  [41] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120900.tif"
    ##  [42] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120910.tif"
    ##  [43] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120920.tif"
    ##  [44] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120930.tif"
    ##  [45] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120940.tif"
    ##  [46] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708120950.tif"
    ##  [47] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121000.tif"
    ##  [48] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121010.tif"
    ##  [49] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121020.tif"
    ##  [50] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121030.tif"
    ##  [51] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121040.tif"
    ##  [52] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121050.tif"
    ##  [53] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121100.tif"
    ##  [54] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121110.tif"
    ##  [55] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121120.tif"
    ##  [56] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121130.tif"
    ##  [57] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121140.tif"
    ##  [58] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121150.tif"
    ##  [59] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121200.tif"
    ##  [60] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121210.tif"
    ##  [61] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121220.tif"
    ##  [62] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121230.tif"
    ##  [63] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121240.tif"
    ##  [64] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121250.tif"
    ##  [65] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121300.tif"
    ##  [66] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121310.tif"
    ##  [67] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121320.tif"
    ##  [68] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121330.tif"
    ##  [69] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121340.tif"
    ##  [70] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121350.tif"
    ##  [71] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121400.tif"
    ##  [72] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121410.tif"
    ##  [73] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121420.tif"
    ##  [74] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121430.tif"
    ##  [75] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121450.tif"
    ##  [76] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121500.tif"
    ##  [77] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121510.tif"
    ##  [78] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121520.tif"
    ##  [79] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121530.tif"
    ##  [80] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121540.tif"
    ##  [81] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121550.tif"
    ##  [82] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121600.tif"
    ##  [83] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121610.tif"
    ##  [84] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121620.tif"
    ##  [85] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121630.tif"
    ##  [86] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121640.tif"
    ##  [87] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121650.tif"
    ##  [88] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121700.tif"
    ##  [89] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121710.tif"
    ##  [90] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121720.tif"
    ##  [91] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121730.tif"
    ##  [92] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121740.tif"
    ##  [93] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121750.tif"
    ##  [94] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121800.tif"
    ##  [95] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121810.tif"
    ##  [96] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121820.tif"
    ##  [97] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121830.tif"
    ##  [98] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121840.tif"
    ##  [99] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121850.tif"
    ## [100] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121900.tif"
    ## [101] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121910.tif"
    ## [102] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121920.tif"
    ## [103] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121930.tif"
    ## [104] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121940.tif"
    ## [105] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708121950.tif"
    ## [106] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122000.tif"
    ## [107] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122010.tif"
    ## [108] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122020.tif"
    ## [109] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122030.tif"
    ## [110] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122040.tif"
    ## [111] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122050.tif"
    ## [112] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122100.tif"
    ## [113] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122110.tif"
    ## [114] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122120.tif"
    ## [115] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122130.tif"
    ## [116] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122140.tif"
    ## [117] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122150.tif"
    ## [118] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122200.tif"
    ## [119] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122210.tif"
    ## [120] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122220.tif"
    ## [121] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122230.tif"
    ## [122] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122240.tif"
    ## [123] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122250.tif"
    ## [124] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122300.tif"
    ## [125] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122310.tif"
    ## [126] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122320.tif"
    ## [127] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122330.tif"
    ## [128] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122340.tif"
    ## [129] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708122350.tif"
    ## [130] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130000.tif"
    ## [131] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130010.tif"
    ## [132] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130020.tif"
    ## [133] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130030.tif"
    ## [134] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130040.tif"
    ## [135] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130050.tif"
    ## [136] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130100.tif"
    ## [137] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130110.tif"
    ## [138] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130120.tif"
    ## [139] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130130.tif"
    ## [140] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130140.tif"
    ## [141] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130150.tif"
    ## [142] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130200.tif"
    ## [143] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130210.tif"
    ## [144] "ftp://ftp.bom.gov.au/anon/gen/gms/IDE00426.201708130220.tif"

#### Example using `get_satellite_imagery`

`get_satellite_imagery()` fetches BOM satellite GeoTIFF imagery, returning a raster stack object and takes three arguments. Files are available at ten minute update frequency with a 24 hour delete time. It is suggested to check file availability first by using `get_available_imagery()`. The arguments are:

-   `product_id`, a character value of the BOM product ID to download. Alternatively, a vector of values from `get_available_imagery()` may be used here. This argument is mandatory.

-   `scans` a numeric value for the number of scans to download, starting with the most recent and progressing backwards, *e.g.*, `1` - the most recent single scan available , `6` - the most recent hour available, `12` - the most recent 2 hours available, etc. Negating will return the oldest files first. Defaults to 1. This argument is optional.

-   `cache` a logical value that indicates whether or not to store image files locally for later use? If `FALSE`, the downloaded files are removed when R session is closed. To take advantage of cached files in future sessions, set `TRUE`. Defaults to `FALSE`. This argument is optional. Cached files may be managed with the `manage_bomrang_cache()` function.

``` r
# Use `avail` from prior and download only most recent scan
imagery <- get_satellite_imagery(product_id = avail, scans = 1)

# load the raster library to work with the GeoTIFF files
library(raster)
```

    ## Loading required package: sp

``` r
plot(imagery)
```

![](man/figures/get_satellite_imagery-1.png)

Meta
----

-   Please [report any issues or bugs](https://github.com/ropensci/bomrang/issues).

-   License:
    -   All code is licenced MIT

    -   All data is copyright Australia Bureau of Meteorology, BOM Copyright Notice <http://reg.bom.gov.au/other/copyright.shtml>

-   To cite *bomrang*, please use: 
        
        Adam H Sparks, Mark Padgham, Hugh Parsonage and Keith Pembleton (2017).
        bomrang: Fetch Australian Government Bureau of Meteorology Weather Data.
        The Journal of Open Source Software, 2(17).
        DOI: [10.21105/joss.00411](https://doi.org/10.21105/joss.00411)

    or the BibTeX entry:

    ```
    @article{AHSparks2017,
    doi = {10.21105/joss.00411},
    url = {https://doi.org/10.21105/joss.00411},
    year  = {2017},
    month = {sep},
    publisher = {The Open Journal},
    volume = {2},
    number = {17},
    author = {Adam H Sparks and Mark Padgham and Hugh Parsonage and Keith Pembleton},
    title = {bomrang: Fetch Australian Government Bureau of Meteorology Data in R},
    journal = {The Journal of Open Source Software}
    ```

-   Please note that this project is released with a
[Contributor Code of Conduct](CONDUCT.md). By participating in this project you
agree to abide by its terms.

References
----------

[Australian Bureau of Meteorology (BOM) Weather Data Services](http://www.bom.gov.au/catalogue/data-feeds.shtml)

[Australian Bureau of Meteorology (BOM) Weather Data Services Agriculture Bulletins](http://www.bom.gov.au/catalogue/observations/about-agricultural.shtml)

[Australian Bureau of Meteorology (BOM) Weather Data Services Observation of Rainfall](http://www.bom.gov.au/climate/how/observations/rain-measure.shtml)

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
