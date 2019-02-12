source("../src/config.R")
source("../src/functions.R")

## inputArguments
# inputargs <- commandArgs(TRUE)
# dat.fn <- inputargs[1]
# TOMType <- inputargs[2]
# save.fn <- inputargs[3]

signed_wgcna_fn <- dir(path = "/work-zfs/abattle4/parsana/networks_correction/networks", all.files=T, recursive=T, full.names = T)
signed_wgcna_fn <- signed_wgcna_fn[grep("signed_", signed_wgcna_fn)]
signed_wgcna_fn <- signed_wgcna_fn[grep(paste(c("raw", "rin", "mc", "/pc/"), collapse = "|"), signed_wgcna_fn)]
signed_wgcna_fn <- signed_wgcna_fn[c(3,4,1,2)]

print(signed_wgcna_fn)
modulesize_all <- lapply(signed_wgcna_fn, function(x){
	load(x)
	size_alltiss <- sapply(dat.net, function(y) {
		size_thistiss <- lapply(y, function(z) table(z$colors))
		#size_thistiss <- table(y[[50]]$colors)
		size_thistiss
	})
	size_alltiss
	})

names(modulesize_all) <- c("uncorrected", "rin", "mc", "pc")

num_modules <- lapply(modulesize_all, function(x){
	this_num_mod <- sapply(x, length)
	this_num_mod
	})

saveRDS(modulesize_all, file = "../results/wgcna_module_size.Rds")
