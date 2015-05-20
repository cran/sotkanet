## ----install, eval=FALSE-------------------------------------------------
#  install.packages("sotkanet")
#  library(sotkanet)

## ----install2, eval=FALSE------------------------------------------------
#  install.packages("devtools")
#  library(devtools)
#  install_github("ropengov/sotkanet")
#  library(sotkanet)

## ----sotkanetIndicators, warning=FALSE, message=FALSE--------------------
library(sotkanet) 
sotkanet.indicators <- SotkanetIndicators(type = "table")

library(knitr)
kable(head(sotkanet.indicators))

## ----sotkanetRegions, warning=FALSE, message=FALSE-----------------------
sotkanet.regions <- SotkanetRegions(type = "table")
knitr::kable(head(sotkanet.regions))

## ----sotkanetData, warning=FALSE, message=FALSE--------------------------
# Get indicator data
dat <- GetDataSotkanet(indicators = 10013, years = 1990:2012, 
       		       genders = c('female', 'male', 'total'), 
		       region.category = "EUROOPPA", region = "Suomi")

# Investigate the first lines in the data
knitr::kable(head(dat))

## ----sotkanetDataVisu, warning=FALSE, message=FALSE----------------------
# Pick indicator name
indicator.name <- as.character(unique(dat$indicator.title.fi))
indicator.source <- as.character(unique(dat$indicator.organization.title.fi))

# Visualize
library(ggplot2)
theme_set(theme_bw(20)); 
p <- ggplot(dat, aes(x = year, y = primary.value, group = gender, color = gender)) 
p <- p + geom_line() + ggtitle(paste(indicator.name, indicator.source, sep = " / ")) 
p <- p + xlab("Year") + ylab("Value") 
p <- p + theme(title = element_text(size = 10))
p <- p + theme(axis.title.x = element_text(size = 20))
p <- p + theme(axis.title.y = element_text(size = 20))
p <- p + theme(legend.title = element_text(size = 15))
print(p)

## ----sotkanetVisu3, warning=FALSE, message=FALSE-------------------------
selected.inds <- c(127, 178)
dat <- GetDataSotkanet(indicators = selected.inds, 
       			years = 2011, genders = c('total'))
# Pick necessary fields and remove duplicates
datf <- dat[, c("region.title.fi", "indicator.title.fi", "primary.value")]
datf <- datf[!duplicated(datf),]
dw <- reshape(datf, idvar = "region.title.fi", 
      		    timevar = "indicator.title.fi", direction = "wide")
names(dw) <- c("Municipality", "Population", "Migration")
p <- ggplot(dw, aes(x = log10(Population), y = Migration)) 
p <- p + geom_point(size = 3)
p <- p + ggtitle("Migration vs. population size") 
p <- p + theme(title = element_text(size = 15))
p <- p + theme(axis.title.x = element_text(size = 20))
p <- p + theme(axis.title.y = element_text(size = 20))
p <- p + theme(legend.title = element_text(size = 15))
print(p)

## ----sotkanetDataAll, warning=FALSE, message=FALSE, eval=FALSE-----------
#  # These indicators have problems with R routines:
#  probematic.indicators <- c(1575, 1743, 1826, 1861, 1882, 1924, 1952, 2000, 2001, 2033, 2050, 3386, 3443)
#  
#  # Get data for all indicators
#  datlist <- list()
#  for (ind in setdiff(sotkanet.indicators$indicator, probematic.indicators)) {
#    datlist[[as.character(ind)]] <- GetDataSotkanet(indicators = ind,
#    		years = 1990:2013, genders = c('female', 'male', 'total'))
#  }
#  
#  # Combine tables (this may require considerable time and memory
#  # for the full data set)
#  dat <- do.call("rbind", datlist)

## ----citation, message=FALSE, eval=TRUE----------------------------------
citation("sotkanet")

## ----sessioninfo, message=FALSE, warning=FALSE---------------------------
sessionInfo()

