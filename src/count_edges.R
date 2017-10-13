source("config")
count.edge <- vector("list", length = 5)
names(count.edge) <- c("raw", "rin","quarter_pc","half_pc","pc_corrected")
for(i in 1:length(count.edge)){
	count.edge[[i]] <- vector("list", length = 5)
	names(count.edge[[i]]) <- c("Lung", "Thyroid", "Adipose_Sub")
}

types.network = names(count.edge)

for(i in types.network){
	if(i == "rin"){
		filedir <- ringlasso
	}
	if(i == "pc_corrected"){
		filedir <- pcglasso
	}
	if(i == "raw"){
		filedir <- rawglasso
	}
	if(i == "half_pc"){
		filedir <- half.pcglasso
	}
	if(i == "quarter_pc"){
		filedir <- quarter.pcglasso
	}
	print(paste("Loading", i, "networks", sep = " "))
	fn <- c("Lung.Rdata", "Thyroid.Rdata", "Subcutaneous.Rdata")
	for(j in 1:length(fn)){
		load(paste(filedir, fn[j], sep = ""))
		count.edge[[i]][[j]] <- sapply(glasso.network, function(x){
			length(which(!is.na(x)))
			})
	}
	rm(glasso.network)
}


plot.tp <- unlist(count.edge, recursive = FALSE)
plot.tp <- do.call(rbind, plot.tp)

plot.tp <- melt(plot.tp)
plot.tp$tiss <- sapply(as.character(plot.tp$Var1), function(x) {strsplit(x, '[.]')[[1]][2]})
plot.tp$type <- sapply(as.character(plot.tp$Var1), function(x) {strsplit(x, '[.]')[[1]][1]})

ggplot(plot.tp, aes(x = tiss, y = value, fill = type)) + geom_boxplot() + theme_classic() + theme(text = element_text(size=12))+
xlab("Tissue") + ylab("# of edges")
ggsave("boxplot_edgecount.png")

#ggplot(plot.tp[which(plot.tp$type == "pc_corrected"),], aes(x = tiss, y = value, fill = tiss)) + geom_boxplot() + 
#scale_fill_manual(values = c("darkred", "darkgreen", "darkblue"))+ theme_classic(text = element_text(size=12))+
#xlab("Tissue") + ylab("# of edges")
#ggsave("boxplot_pc_edgecount.png")
