## linear model data correction

source("functions.R")
source("config.R")

# input arguments to the script
inputargs <- commandArgs(TRUE)
raw.file <- inputargs[1]
cov.name <- inputargs[2]
save.fn <- inputargs[3]

load(raw.file)

dat.expr <- mclapply(dat.expr, covcorrect, cov.name)

save(dat.expr, file = save.fn)

