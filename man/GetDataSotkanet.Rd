% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetDataSotkanet.R
\name{GetDataSotkanet}
\alias{GetDataSotkanet}
\title{Retrieve Sotkanet Data (old version)}
\usage{
GetDataSotkanet(
  indicators = NULL,
  years = 1991:2015,
  genders = c("total"),
  regions = NULL,
  region.category = NULL,
  user.agent = NULL
)
}
\arguments{
\item{indicators}{Dataset identifier(s)}

\item{years}{vector of years c(2010, 2012, ... )}

\item{genders}{vector of genders ('male' | 'female' | 'total')}

\item{regions}{filter by selected regions only (default: all regions)}

\item{region.category}{filter by one or more of the following 15 valid
regions categories (default: all categories)
   \itemize{
     \item "ALUEHALLINTOVIRASTO"
     \item "ELY-KESKUS"
     \item "ERVA"
     \item "EURALUEET" (Eurozone)
     \item "EUROOPPA" (Europe)
     \item "HYVINVOINTIALUE" (welfare country)
     \item "KUNTA" (municipality)
     \item "MAA" (country)
     \item "MAAKUNTA" (region)
     \item "NUTS1"
     \item "POHJOISMAAT" (Nordic countries)
     \item "SAIRAANHOITOPIIRI (hospital district)
     \item "SEUTUKUNTA"
     \item "SUURALUE"
     \item "YTA"
   }}

\item{user.agent}{"User agent" defined by the user. Default is NULL which
will then use the package identifier "rOpenGov/sotkanet"}
}
\value{
data.frame
}
\description{
Retrieve selected data and combine into a single table. (This is an older version
 of the function. It is advised to use the new [get_sotkanet()] function instead.)
}
\details{
THL's open data license and limitation of liability

\strong{License}

The open data provided by National Institute for Health and Welfare is
licensed under CC BY 4.0. This license defines how open data can be utilized.
The licensing is based on a decision made by the Director General.

\strong{Limitation of Liability}

National Institute for Health and Welfare shall not be liable for any loss,
legal proceedings, claims, proceedings, demands, costs or damages regardless
of their cause or form, which can be directly or indirectly connected to
open data or use of open data published by National Institute for Health and
Welfare.
}
\examples{
\dontrun{dat <- GetDataSotkanet(indicators = 165)}
}
\references{
See citation("sotkanet")
}
\seealso{
For more information about dataset structure, see THL webpage at
\url{https://yhteistyotilat.fi/wiki08/pages/viewpage.action?pageId=27557907}

THL open data license website: \url{https://yhteistyotilat.fi/wiki08/x/AAadAg}
}
\author{
Maintainer: Leo Lahti \email{leo.lahti@iki.fi}, Pyry Kantanen
}
\keyword{utilities}
