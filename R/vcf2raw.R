#######################################################################
#                                                                     #
# Package: onemap                                                     #
#                                                                     #
# File: vcf2raw.R                                                     #
# Contains: vcf2raw                                                   #
#                                                                     #
# Written by Gabriel Rodrigues Alves Margarido                        #
# copyright (c) 2015, Gabriel R A Margarido                           #
#                                                                     #
# First version: 10/14/2015                                           #
# Last update: 01/14/2016                                             #
# License: GNU General Public License version 2 (June, 1991) or later #
#                                                                     #
#######################################################################


##' Convert variants from a VCF file to OneMap file format
##'
##' Converts data from a standard VCF (Variant Call Format) file to the input
##' format required by OneMap, while trying to identify the appropriate marker
##' segregation patterns.
##'
##' Each variant in the VCF file is processed independently. Only biallelic SNPs
##' and indels for diploid variant sites are considered.
##'
##' Genotype information on the parents is required for all cross types. For
##' full-sib progenies, both outbred parents must be genotyped. For backcrosses,
##' F2 intercrosses and recombinant inbred lines, the \emph{original inbred
##' lines} must be genotyped. Particularly for backcross progenies, the
##' \emph{recurrent line must be provided as the first parent} in the function
##' arguments.
##'
##' First, samples corresponding to both parents of the progeny are parsed and
##' their genotypes identified, given that they are concordant above a provided
##' threshold. Marker type is determined based on parental genotypes.
##' Finally, progeny genotypes are identified and output is produced. Variants
##' for which parent genotypes cannot be determined are discarded.
##'
##' Reference sequence ID and position for each variant site are stored as special
##' fields denoted \code{CHROM} and \code{POS}.
##'
##' @param input path to the input VCF file.
##' @param output path to the output OneMap file.
##' @param cross type of cross. Must be one of: \code{"outcross"} for full-sibs;
##' \code{"f2 intercross"} for an F2 intercross progeny; \code{"backcross"};
##' \code{"riself"} for recombinant inbred lines by self-mating; or
##' \code{"risib"} for recombinant inbred lines by sib-mating.
##' @param parent1 \code{string} or \code{vector} of \code{strings} specifying
##' sample ID(s) of the first parent.
##' @param parent2 \code{string} or \code{vector} of \code{strings} specifying
##' sample ID(s) of the second parent.
##' @param min_class a real number between 0.0 and 1.0. For each parent and each
##' variant site, defines the proportion of parent samples that must be of the
##' same genotype for it to be assigned to the corresponding parent.
##' @author Gabriel R A Margarido, \email{gramarga@@gmail.com}
##' @seealso \code{read.outcross} for a description of the OneMap file format.
##' @keywords IO
##' @examples
##'
##'   \dontrun{
##'     vcf2raw(input="your_VCF_file.vcf",
##'             output="your_OneMap_file.raw",
##'             cross="your_cross_type",
##'             parent1=c("PAR1_sample1", "PAR1_sample2"),
##'             parent2=c("PAR2_sample1", "PAR2_sample2", "PAR2_sample3"),
##'             min_class=0.5)
##'   }
##'

vcf2raw <- function(input = NULL, output = NULL,
                    cross = c("outcross", "f2 intercross", "backcross", "riself", "risib"),
                    parent1 = NULL, parent2 = NULL, min_class = 1.0) {
  if (is.null(input)) {
    stop("You must specify the input file path.")
  }
  if (!file.exists(input)) {
    stop("Input file not found.")
  }
  if (is.null(output)) {
    stop("You must specify the output file path.")
  }
  cross <- match.arg(cross)
  if (is.null(parent1) || is.null(parent2)) {
    stop("You must specify at least one sample each as parents 1 and 2.")
  }

  convert <- .C("vcf2raw",
                as.character(input),
                as.character(output),
                as.character(cross),
                as.integer(length(parent1)),
                as.character(parent1),
                as.integer(length(parent2)),
                as.character(parent2),
                as.numeric(min_class),
                PACKAGE = "onemap")
}
