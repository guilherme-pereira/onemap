% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/test_segregation.R
\name{test_segregation}
\alias{test_segregation}
\title{test_segregation}
\usage{
test_segregation(x)
}
\arguments{
\item{x}{an object of class \code{onemap}, with data and additional information.}
}
\value{
an object of class onemap.segreg.test, which is a list with marker name,
H0 hypothesis being tested, the chi-square statistics, the associated p-values
and the \% of individuals genotyped. To see the object, it is necessary to print
it.
}
\description{
Using OneMap internal function test_segregation_of_a_marker(),
performs the Chi-square test to check if all markers in a dataset are following
the expected segregation pattern, i. e., 1:1:1:1 (A), 1:2:1 (B), 3:1 (C) and 1:1 (D)
according to OneMap's notation.
}
\details{
First, it identifies the correct segregation pattern and corresponding H0 hypothesis,
and then tests it.
}
\examples{
data(example.out) # Loads a fake outcross dataset installed with onemap
Chi <- test_segregation(example.out) # Performs the chi-square test for all markers
print(Chi) # Shows the results
}

