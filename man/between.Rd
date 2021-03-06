% Generated by roxygen2 (4.0.1): do not edit by hand
\name{between}
\alias{between}
\title{Do values in a numeric vector fail in specified range?}
\usage{
between(x, left, right)
}
\arguments{
\item{x}{A numeric vector of values}

\item{left,right}{Boundary values}
}
\description{
This is a shortcut for \code{x >= left & x <= right}, implemented
efficiently in C++ for local values, and translated to the
appropriate SQL for remote tables.
}
\examples{
x <- rnorm(1e2)
x[between(x, -1, 1)]
}

