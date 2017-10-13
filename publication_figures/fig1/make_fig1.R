rm(list = ls())

## load libraries
#library(pcalg)
library(mvtnorm)
library(clusterGeneration)
library(sva)
#library(spacejam)
library(gridExtra)
library(gtable)
library(glasso)
library(huge)
library(devtools)
install_github('alyssafrazee/RSkittleBrewer')
library(RSkittleBrewer)
tropical = RSkittleBrewer('tropical')
library(ggplot2)
library(reshape2)
library(cowplot)
### Data: 5 features, 10 samples
p=8
n=10

V=diag(1,nrow=p,ncol=p)
V[1,3]=V[3,1]=.35
V[4,7]=V[7,4]=.3
V[1,8]=V[8,1]=.3
V.inv=solve(V)

colnames(V)=rownames(V)=colnames(V.inv)=rownames(V.inv)=paste(1:8)

A.generating=V
for(i in 1:p){
  for(j in 1:p){
    if(abs(V[i,j])>0.05){
      A.generating[i,j]=1
    }
    if(abs(V[i,j])<=0.05){
      A.generating[i,j]=0
    }
  }
}
g.generating=graph.adjacency(A.generating,mode="undirected", diag=FALSE,add.colnames=TRUE)

set.seed(4747)
data=rmvnorm((1000*n),mean=rep(1,p),sigma=V)
rownames(data)=1:(1000*n)
colnames(data)=1:8

cor.data=cor(data)

## Graph 
lambda=seq(1,0.01,length.out=200)
glasso.unconfounded.lambda=huge(data,lambda,method="glasso")
glasso.adjacency.unconfounded.lambda=glasso.unconfounded.lambda$path
glasso.graph.unconfounded.lambda=list()

for(i in 1:200){
  glasso.graph.unconfounded.lambda[[i]]=graph.adjacency(glasso.adjacency.unconfounded.lambda[[i]],mode="undirected", diag=FALSE)
}

############ Confounding ############
data.confounded=data
grp=rnorm(1000*n)
for(i in 2:6){
  data.confounded[,i] = data.confounded[,i] + 50*grp
}

rownames(data.confounded)=1:(1000*n)
colnames(data.confounded)=1:8

cor.data.confounded=cor(data.confounded)
colnames(cor.data.confounded)=rownames(cor.data.confounded)=1:8

colnames(data.confounded)=1:8
rownames(data.confounded)=1:10000 

glasso.confounded=huge(data.confounded,lambda,method="glasso")

glasso.adjacency.confounded=glasso.confounded$path
glasso.graph.confounded=list()
for(i in 1:200){
  glasso.graph.confounded[[i]]=graph.adjacency(glasso.adjacency.confounded[[i]],mode="undirected", diag=FALSE)
}

############ Correct for Confounding (Residuals from PC) ############
mod=matrix(1,nrow=dim(data.confounded)[1],ncol=1)
colnames(mod)="Intercept"
nsv=num.sv(t(data.confounded),mod)

ss=svd(data.confounded - colMeans(data.confounded))
grp.est=ss$u[,1]
data.corrected=data.confounded*0
for(i in 1:8){
  data.corrected[,i]=lm(data.confounded[,i] ~ grp.est)$residuals
}

rownames(data.corrected)=1:(1000*n)
colnames(data.corrected)=1:8

cor.data.corrected=cor(data.corrected)
colnames(cor.data.corrected)=rownames(cor.data.corrected)=1:8


glasso.corrected.lambda=huge(data.corrected,method="glasso",lambda)
glasso.graph.corrected.lambda=list()
for(i in 1:200){
  glasso.graph.corrected.lambda[[i]]=graph.adjacency(glasso.corrected.lambda$path[[i]],mode="undirected", diag=FALSE)
  
}

## For a given gene, samples are standard normal
z.data=data
for(j in 1:8){
  mean=mean(data[,j])
  sd=sd(data[,j])
  z.data[,j]=(data[,j]-mean)/sd
}

z.data.confounded=data.confounded
for(j in 1:8){
  mean=mean(data.confounded[,j])
  sd=sd(data.confounded[,j])
  z.data.confounded[,j]=(data.confounded[,j]-mean)/sd
}

z.data.corrected=data.corrected
for(j in 1:8){
  mean=mean(data.corrected[,j])
  sd=sd(data.corrected[,j])
  z.data.corrected[,j]=(data.corrected[,j]-mean)/sd
}

### Plots

col.expr=colorRampPalette(c("#d8b365", "#f5f5f5", "#5ab4ac"))
col.corr=colorRampPalette(c("#ef8a62", "#f7f7f7", "#67a9cf"))

at=seq(-1,1,length.out=50)
layout=layout.circle(g.generating)

## unconfounded data
print(levelplot(z.data[1:10,], xlab=list(label="Sample", cex=2), ylab=list(label="Gene", cex=2),at=at,
                col.regions=col.expr, scales=list(x=list(cex=2),y=list(cex=2),xlab=list(cex=2)),
                colorkey=list(labels=list(cex=2))))
plot.z.data = melt(z.data[1:10,])
plot.z.data$Var1 <- factor(plot.z.data$Var1)
plot.z.data$Var2 <- factor(plot.z.data$Var2)
panela <- ggplot(plot.z.data, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.expr(50), limits = c(-2.5,2.5))+theme_bw() + xlab("Sample") + ylab("Gene")

# dev.copy2pdf(file="~/claire_fig1/cartoon_data_unconfounded_zscale_heatmap.pdf", width = 7, height = 5)
plot.cor.data = melt(cor.data)
plot.cor.data$Var1 <- factor(plot.cor.data$Var1)
plot.cor.data$Var2 <- factor(plot.cor.data$Var2)

panelb <- ggplot(plot.cor.data, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.corr(50), 
                       limits = c(-1,1))+theme_bw() + xlab("Gene") + ylab("Gene")

pdf("panelc.pdf", height = 3, width = 3)
plot(glasso.graph.unconfounded.lambda[[150]],layout=layout,vertex.label=1:8,vertex.size=50,edge.color="limegreen",edge.width=4, vertex.color="cornsilk")
# dev.copy2pdf(file="~/claire_fig1/cartoon_graph_glasso_unconfounded.pdf", width = 7, height = 5)
dev.off()
## confounded
plot.z.data.confounded = melt(z.data.confounded[1:10,])
plot.z.data.confounded$Var1 <- factor(plot.z.data.confounded$Var1)
plot.z.data.confounded$Var2 <- factor(plot.z.data.confounded$Var2)
paneld <- ggplot(plot.z.data.confounded, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.expr(50), limits = c(-2.5,2.5))+theme_bw() + xlab("Sample") + ylab("Gene")

# dev.copy2pdf(file="~/claire_fig1/cartoon_data_unconfounded_zscale_heatmap.pdf", width = 7, height = 5)
plot.cor.data.confounded = melt(cor.data.confounded)
plot.cor.data.confounded$Var1 <- factor(plot.cor.data.confounded$Var1)
plot.cor.data.confounded$Var2 <- factor(plot.cor.data.confounded$Var2)

panele <- ggplot(plot.cor.data.confounded, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.corr(50), 
                       limits = c(-1,1))+theme_bw() + xlab("Gene") + ylab("Gene")

pdf("panelf.pdf", height = 3, width = 3)
plot(glasso.graph.confounded[[150]],layout=layout,vertex.label=1:8,vertex.size=50,edge.color="limegreen",edge.width=4, vertex.color="cornsilk")
dev.off()

## corrected
plot.z.data.corrected = melt(z.data.corrected[1:10,])
plot.z.data.corrected$Var1 <- factor(plot.z.data.corrected$Var1)
plot.z.data.corrected$Var2 <- factor(plot.z.data.corrected$Var2)
panelg <- ggplot(plot.z.data.corrected, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.expr(50), limits = c(-2.5,2.5))+ theme_bw() + xlab("Sample") + ylab("Gene")

# dev.copy2pdf(file="~/claire_fig1/cartoon_data_u.corrected_zscale_heatmap.pdf", width = 7, height = 5)
plot.cor.data.corrected = melt(cor.data.corrected)
plot.cor.data.corrected$Var1 <- factor(plot.cor.data.corrected$Var1)
plot.cor.data.corrected$Var2 <- factor(plot.cor.data.corrected$Var2)

panelh <- ggplot(plot.cor.data.corrected, aes(Var1, Var2))+
  geom_tile(aes(fill = value))+ 
  scale_fill_gradientn(colours = col.corr(50), 
                       limits = c(-1,1))+theme_bw() + xlab("Gene") + ylab("Gene")

pdf("paneli.pdf", height = 3, width = 3)
plot(glasso.graph.corrected.lambda[[150]],layout=layout,vertex.label=1:8,vertex.size=50,edge.color="limegreen",edge.width=4, vertex.color="cornsilk")
dev.off()

fig1 <- plot_grid(panela + theme(legend.position="none"), 
  panelb + theme(legend.position="none"), 
  NULL, 
  paneld + theme(legend.position="none"), 
  panele + theme(legend.position="none"), 
  NULL, 
  panelg + theme(legend.position="none"), 
  panelh + theme(legend.position="none"), 
  NULL, 
                      labels=letters[1:9], ncol = 3)

legenda <- get_legend(panela + theme(legend.direction = "horizontal", legend.position = "top"))
legendb <- get_legend(panelb + theme(legend.direction = "horizontal", legend.position = "top"))
legend <- plot_grid(legenda, legendb, NULL, ncol = 3)
fig1 <- plot_grid( legend, fig1, rel_heights = c(.1, 1), ncol = 1)

pdf("merged.pdf", height = 6, width = 6)
print(fig1)
dev.off()
