% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_radar_imagery.R
\name{get_radar_imagery}
\alias{get_radar_imagery}
\title{Get \acronym{BOM} radar imagery}
\usage{
get_radar_imagery(product_id, path = NULL, download_only = FALSE)
}
\arguments{
\item{product_id}{Character. \acronym{BOM} product ID to download and import
as a \CRANpkg{magick} object.  Value is required.}

\item{path}{Character. A character string with the name where the downloaded
file is saved.  If not provided, the default value \code{NULL} is used which
saves the file in an \R session temp directory.}

\item{download_only}{Logical. Whether the radar image is loaded into the
environment as a \CRANpkg{magick} object or just downloaded.}
}
\value{
A \CRANpkg{magick} object of the most recent \acronym{radar} image snapshot
published by the \acronym{BOM}. If \code{download_only = TRUE} there will be
a \code{NULL} return value with the download path printed in the console as a
message.
}
\description{
Fetch \acronym{BOM} radar imagery from
\url{ftp://ftp.bom.gov.au/anon/gen/radar/} and return a
\code{\link[terra]{SpatRaster}} layer object.  Files available are the most
recent radar snapshot which are updated approximately every 6 to 10 minutes.
Suggested to check file availability first by using
\code{\link{get_available_radar}}.
}
\details{
Valid \acronym{BOM} \acronym{Radar} Product IDs for radar imagery
can be obtained from \code{\link{get_available_radar}}.
}
\examples{
\donttest{
# Fetch most recent radar image for Wollongong 256km radar
imagery <- get_radar_imagery(product_id = "IDR032")
imagery
}

}
\references{
Australian Bureau of Meteorology (\acronym{BOM}) radar images\cr
\url{http://www.bom.gov.au/australia/radar/}
}
\seealso{
\code{\link{get_available_radar}}
}
\author{
Dean Marchiori, \email{deanmarchiori@gmail.com}
}
