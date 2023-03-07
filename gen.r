#!/usr/bin/env Rscript
path = getwd()
source(paste(path, "/install.r", sep=""))

rmarkdown::render("greeks.rmd",
                  output_file = glue::glue("pdf/output.pdf"))