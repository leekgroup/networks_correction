## PC correction

source("functions.R")
source("config.R")

# input arguments to the script
inputargs <- commandArgs(TRUE)
raw.file <- inputargs[1]
variable.genes.fn <- inputargs[2]
all.PC <- eval(parse(text=inputargs[3]))
save.fn <- inputargs[4]


load(raw.file)

genes.select <- read.delim(variable.genes.fn, sep = ",", stringsAsFactors = F)

if(all.PC){
	## estimate the number of PCs for each tissue
        print(names(gtex.rse))
        num.pc.estimates <- lapply(gtex.rse,pc.estimate)
        print(num.pc.estimates)
	
	## get PC loadings for each tissue
	pc.loadings <-  mclapply(gtex.rse, compute.pc.loadings)
	dat.expr <- mcmapply(pc.correct, rse.object = gtex.rse, loadings = pc.loadings, n.pc = num.pc.estimates, SIMPLIFY = FALSE)
	save(pc.loadings, num.pc.estimates, file = paste(datDir, "pc_loadings.Rdata", sep = ""))
}else{
	# argument 5 and 6 required only when allPC = FALSE
	num.pc.rm <- as.list(eval(parse(text = inputargs[5])))
	pcloadings.fn <- inputargs[6]
	load(pcloadings.fn)
	dat.expr <- mcmapply(pc.correct, rse.object = gtex.rse, loadings = pc.loadings, n.pc = num.pc.rm, SIMPLIFY = FALSE)
}

## select the most variable genes
dat.expr <- mclapply(dat.expr, function(x,gids){
  dat.sub <- x[gids,]
  dat.sub
  }, genes.select$x)

save(dat.expr, file = save.fn)

