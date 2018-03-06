# libraries
library(recount)
source("functions.R")

# Load GC attached data

load("/work-zfs/abattle4/parsana/networks_correction/data/raw_subset_gc_attached.Rdata")

## Three covariates currently discussed in the paper
multi3 <- c("smrin", "smexncrt", "gc")
gtex.rse.multi3 <- mclapply(gtex.rse.sub, covcorrect, multi3)

## couple more additional covariates based on gtex
multi7 <- c("smrin", "smexncrt", "gc", "smestlbs", "smrrnart", "smmncv", "smunmprt")
gtex.rse.multi7 <- mclapply(gtex.rse.sub, covcorrect, multi7)

## save
save(gtex.rse.multi3, file = "/work-zfs/abattle4/parsana/networks_correction/data/gtex_multi3.Rdata" )
save(gtex.rse.multi7, file = "/work-zfs/abattle4/parsana/networks_correction/data/gtex_multi7.Rdata" )
