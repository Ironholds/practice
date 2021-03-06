% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/dates.R
\name{latest_release}
\alias{latest_release}
\title{Identify the Date of the Latest Release}
\usage{
latest_release(metadata)
}
\arguments{
\item{metadata}{a metadata object returned from \code{\link{get_package_metadata}}}
}
\description{
Takes package metadata obtained with \code{\link{get_package_metadata}}
and returns a date object containing the date of the most recent package release.
}
\examples{
\dontrun{
package_metadata <- get_package_metadata("abf2")
latest_release(package_metadata)
}
}

