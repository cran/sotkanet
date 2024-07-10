---
title: "Sotkanet API R tools"
output:
  rmarkdown::html_vignette:
    toc: TRUE
vignette: >
  %\VignetteIndexEntry{Sotkanet API R tools}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---







This [sotkanet](https://github.com/rOpenGov/sotkanet) R package provides access to data from the [Sotkanet portal](https://sotkanet.fi/sotkanet/en/index). Your [contributions](https://ropengov.org/community/) and [bug reports and other feedback](https://github.com/rOpenGov/sotkanet) are welcome.

## Introduction

The Sotkanet portal provides over 2000 demographic indicators across Finland and Europe. It is maintained by the National Institute for Health and Welfare (THL). For more information, see [Information about Sotkanet](https://sotkanet.fi/sotkanet/en/tietoa-palvelusta) and [API description](https://sotkanet.fi/sotkanet/en/ohje/74). 

The `sotkanet` R package enables access to the Sotkanet API using R facilitating the use of the data from the API. This package is part of [rOpenGov](https://ropengov.org).


## Installation

To install latest release version from CRAN, use:


``` r
install.packages("sotkanet")
```

To install development version from GitHub, use:


``` r
library(remotes)
remotes::install_github("ropengov/sotkanet")
```

Test the installation by loading the package:


``` r
library(sotkanet)
```


## Usage


### Listing availabe indicators

Load sotkanet and other packages used in the vignette.


``` r
library(sotkanet)
library(kableExtra)
library(ggplot2)
```



List available Sotkanet indicators using `sotkanet_indicators()`:


``` r
# Using a preset list of indicators to avoid a large download
indicators <- sotkanet_indicators(id = c(4, 5, 6, 127, 10012, 10027),
                                  type = "table", lang = "en")
kable(head(indicators))
```

List geographical regions with available indicators using `sotkanet_regions()`:


``` r
# List of the first few regions
regions <- sotkanet_regions(type = "table", lang = "en")
kable(head(regions))
```

### Querying Sotkanet data

To download the data, we need to know the indicator for it. You can look for the right indicator using aforementioned `sotkanet_indicators()` or by browsing the [Sotkanet website](https://sotkanet.fi/sotkanet/en/index). For example, the indicator no. 10012 responds to the (EU) GPD per capita in Purchasing Power Standards (PPS) dataset. The data can be downloaded with `get_sotkanet()` function. If we want, for example, the GPD data from Finland for 2000-2010, the function call is:


``` r
# Get the indicator data
dat <- get_sotkanet(indicators = 10012, years = 2000:2010,
                    genders = c("total"), lang = "en", regions = "Finland")

# The first few lines of the data
kable(head(dat)) %>%
  kable_styling() %>%
  scroll_box(width = "100%")
```

The data can also be downloaded by using interactive function `sotkanet_interactive()`. It gives user interactive alternative for downloading the dataset. This function can also print dataset citation, code for the `get_sotkanet()` call and fixity checksum. 

Dataset citation can be printed for any indicator using the function `sotkanet_cite()`. The citation for the GPD data is:


``` r
sotkanet_cite(10012, lang = "en")
```


## Examples

Let's now demonstrate the use of the package with two examples. For the first example we will use the GPD data from Nordic countries (Pohjoismaat) for 2000-2010 and draw a time series of the data comparing the countries.


``` r
# Get indicator data
dat <- get_sotkanet(indicators = 10012, years = 2000:2010,
                    genders = "total", lang = "en", region.category = "POHJOISMAAT")

indicator_name <- as.character(unique(dat$indicator.title))
indicator_source <- as.character(unique(dat$indicator.organization.title))

# Retrive metadata
dat_meta <- sotkanet_indicator_metadata(id = 10012)

# Visualize
library(ggplot2)
p <- ggplot(dat, aes(x = year, y = primary.value,
                     group = region.title, color = region.title)) + 
  geom_line() + ggtitle(paste0(indicator_name, " \n", indicator_source)) +
  labs(x = "Year", y = "Value",caption = paste0(
    "Data source: https://sotkanet.fi/sotkanet",  "\n", "Data date: ", dat_meta$`data-updated`)) +
  scale_x_continuous(breaks = seq(2000,2010, by = 1)) +
  theme(title = element_text(size = 10)) +
  theme(axis.title.x = element_text(size = 15)) +
  theme(axis.title.y = element_text(size = 15)) +
  theme(legend.title = element_text(size = 15))
print(p)
```

For the second example we will plot the population of Finnish municipalities against a measure of educational level.


``` r
# Get the data for the two indicators
dat <- get_sotkanet(indicators = c(127, 180), 
                    years = 2022, lang = "en",
                    genders = c("total"), region.category = c("KUNTA"))
# Pick the fields of interest and remove duplicates
datf <- dat[,c("region.title", "indicator.title", "primary.value")]
datf <- datf[!duplicated(datf),]
dw <- reshape(datf, idvar = "region.title",
              timevar = "indicator.title", direction = "wide")
names(dw) <- c("Municipality", "Population", "Education_level")

# Vizualise
p <- ggplot(dw, aes(x = log(Population), y = Education_level)) + geom_point(size = 3) +
  ggtitle("Education level vs. population size") +
    theme(title = element_text(size = 10)) +
  labs(y = "Education level", caption = "Data source: https://sotkanet.fi/sotkanet") +
  theme(axis.title.x = element_text(size = 15)) +
  theme(axis.title.y = element_text(size = 15)) +
  theme(legend.title = element_text(size = 15))
plot(p)
```


## Licensing and Citations

### Sotkanet data

Cite Sotkanet and link to [https://sotkanet.fi/sotkanet/fi/index](https://sotkanet.fi/sotkanet/). Also mention indicator provider.

* [Full license and terms of use](https://sotkanet.fi/sotkanet/en/tietoa-palvelusta).

Central points:

 * SOTKAnet REST API is meant for non-regular data queries. Avoid regular and repeated downloads.
 * SOTKAnet API can be used as the basis for other systems
 * Metadata for regions and indicators are under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) 
 * THL indicators are under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) 
 * Indicators provided by third parties can be used only by separate agreement!


### Sotkanet R package

This work can be freely used, modified and distributed under the [Two-clause BSD license](https://en.wikipedia.org/wiki/BSD_licenses).


``` r
citation("sotkanet")
#> Kindly cite the sotkanet R package as follows:
#> 
#>   Leo Lahti, Einari Happonen, Juuso Parkkinen, Joona Lehtomaki, Vesa
#>   Saaristo, Aleksi Lahtinen and Pyry Kantanen (rOpenGov 2024).
#>   sotkanet: Sotkanet Open Data Access and Analysis. R package version
#>   0.10.1 https://github.com/rOpenGov/sotkanet
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Misc{,
#>     title = {sotkanet: Sotkanet Open Data Access and Analysis},
#>     author = {Leo Lahti and Einari Happonen and Joona Lehtomäki and Juuso Parkkinen and Joona Lehtomaki and Vesa Saaristo and Pyry Kantanen and Aleksi Lahtinen},
#>     url = {https://github.com/rOpenGov/sotkanet},
#>     year = {2024},
#>     note = {R package version 0.10.1},
#>   }
#> 
#> Many thanks for all contributors!
```


## Suggestions and bug reports 

You can check the package [GitHub page](https://github.com/rOpenGov/sotkanet/issues) for known issues. You can can also use it to report new bugs and to make suggestions for improving the package.

## Session info

This vignette was created with 


``` r
sessionInfo()
```

