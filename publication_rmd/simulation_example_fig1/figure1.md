



This report was automatically generated with the R package **knitr**
(version 1.17).


```r
---
title: "figure_1"
output:
  html_document:
    code_folding: hide
---

This is a simulation example that shows that confounders and batch effects impact reconstruction of gene co-expression networks. Using this example we also show that true underlying network structure can be reconstructed after principal component correction of gene expression data as described in the paper.

This script generates Figure 1 in the paper -- "Addressing confounding artifacts in reconstruction of gene co-expression networks"
```

```
## Error: <text>:8:6: unexpected symbol
## 7: 
## 8: This is
##         ^
```

```r
rm(list = ls())

## load libraries
#library(pcalg)
library(mvtnorm)
library(clusterGeneration)
```

```
## Loading required package: MASS
```

```r
library(sva)
```

```
## Loading required package: mgcv
```

```
## Loading required package: nlme
```

```
## This is mgcv 1.8-22. For overview type 'help("mgcv-package")'.
```

```
## Loading required package: genefilter
```

```
## Warning: replacing previous import 'stats::sd' by 'BiocGenerics::sd' when
## loading 'S4Vectors'
```

```
## Warning: replacing previous import 'stats::var' by 'BiocGenerics::var' when
## loading 'S4Vectors'
```

```
## Warning: replacing previous import 'stats::sd' by 'BiocGenerics::sd' when
## loading 'IRanges'
```

```
## Warning: replacing previous import 'stats::var' by 'BiocGenerics::var' when
## loading 'IRanges'
```

```
## 
## Attaching package: 'genefilter'
```

```
## The following object is masked from 'package:MASS':
## 
##     area
```

```r
#library(spacejam)
library(gridExtra)
library(gtable)
library(glasso)
library(huge)
```

```
## Loading required package: Matrix
```

```
## Loading required package: lattice
```

```
## Loading required package: igraph
```

```
## Loading required package: methods
```

```
## 
## Attaching package: 'igraph'
```

```
## The following objects are masked from 'package:stats':
## 
##     decompose, spectrum
```

```
## The following object is masked from 'package:base':
## 
##     union
```

```r
library(devtools)
install_github('alyssafrazee/RSkittleBrewer')
```

```
## Skipping install of 'RSkittleBrewer' from a github remote, the SHA1 (00881122) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```r
library(RSkittleBrewer)
tropical = RSkittleBrewer('tropical')
library(ggplot2)
library(reshape2)
library(cowplot)
```

```
## 
## Attaching package: 'cowplot'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     ggsave
```

```r
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
```

```
## Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:11% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:22% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso) with lossless screening....in progress:30% Conducting the graphical lasso (glasso) with lossless screening....in progress:30% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:32% Conducting the graphical lasso (glasso) with lossless screening....in progress:32% Conducting the graphical lasso (glasso) with lossless screening....in progress:33% Conducting the graphical lasso (glasso) with lossless screening....in progress:34% Conducting the graphical lasso (glasso) with lossless screening....in progress:34% Conducting the graphical lasso (glasso)....done.                                          
```

```r
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
```

```
## Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:11% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:22% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso) with lossless screening....in progress:30% Conducting the graphical lasso (glasso) with lossless screening....in progress:30% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:31% Conducting the graphical lasso (glasso) with lossless screening....in progress:32% Conducting the graphical lasso (glasso) with lossless screening....in progress:32% Conducting the graphical lasso (glasso) with lossless screening....in progress:33% Conducting the graphical lasso (glasso) with lossless screening....in progress:34% Conducting the graphical lasso (glasso) with lossless screening....in progress:34% Conducting the graphical lasso (glasso) with lossless screening....in progress:35% Conducting the graphical lasso (glasso) with lossless screening....in progress:35% Conducting the graphical lasso (glasso) with lossless screening....in progress:36% Conducting the graphical lasso (glasso) with lossless screening....in progress:36% Conducting the graphical lasso (glasso) with lossless screening....in progress:37% Conducting the graphical lasso (glasso) with lossless screening....in progress:37% Conducting the graphical lasso (glasso) with lossless screening....in progress:38% Conducting the graphical lasso (glasso) with lossless screening....in progress:38% Conducting the graphical lasso (glasso) with lossless screening....in progress:39% Conducting the graphical lasso (glasso) with lossless screening....in progress:39% Conducting the graphical lasso (glasso) with lossless screening....in progress:40% Conducting the graphical lasso (glasso) with lossless screening....in progress:40% Conducting the graphical lasso (glasso) with lossless screening....in progress:41% Conducting the graphical lasso (glasso) with lossless screening....in progress:41% Conducting the graphical lasso (glasso) with lossless screening....in progress:42% Conducting the graphical lasso (glasso) with lossless screening....in progress:42% Conducting the graphical lasso (glasso) with lossless screening....in progress:43% Conducting the graphical lasso (glasso) with lossless screening....in progress:43% Conducting the graphical lasso (glasso) with lossless screening....in progress:43% Conducting the graphical lasso (glasso) with lossless screening....in progress:44% Conducting the graphical lasso (glasso) with lossless screening....in progress:44% Conducting the graphical lasso (glasso) with lossless screening....in progress:45% Conducting the graphical lasso (glasso) with lossless screening....in progress:46% Conducting the graphical lasso (glasso) with lossless screening....in progress:46% Conducting the graphical lasso (glasso) with lossless screening....in progress:47% Conducting the graphical lasso (glasso) with lossless screening....in progress:47% Conducting the graphical lasso (glasso) with lossless screening....in progress:48% Conducting the graphical lasso (glasso) with lossless screening....in progress:48% Conducting the graphical lasso (glasso) with lossless screening....in progress:49% Conducting the graphical lasso (glasso) with lossless screening....in progress:49% Conducting the graphical lasso (glasso) with lossless screening....in progress:50% Conducting the graphical lasso (glasso) with lossless screening....in progress:50% Conducting the graphical lasso (glasso) with lossless screening....in progress:51% Conducting the graphical lasso (glasso) with lossless screening....in progress:51% Conducting the graphical lasso (glasso) with lossless screening....in progress:52% Conducting the graphical lasso (glasso) with lossless screening....in progress:52% Conducting the graphical lasso (glasso) with lossless screening....in progress:53% Conducting the graphical lasso (glasso) with lossless screening....in progress:53% Conducting the graphical lasso (glasso) with lossless screening....in progress:54% Conducting the graphical lasso (glasso) with lossless screening....in progress:54% Conducting the graphical lasso (glasso) with lossless screening....in progress:55% Conducting the graphical lasso (glasso) with lossless screening....in progress:55% Conducting the graphical lasso (glasso) with lossless screening....in progress:56% Conducting the graphical lasso (glasso) with lossless screening....in progress:56% Conducting the graphical lasso (glasso) with lossless screening....in progress:57% Conducting the graphical lasso (glasso) with lossless screening....in progress:57% Conducting the graphical lasso (glasso) with lossless screening....in progress:58% Conducting the graphical lasso (glasso) with lossless screening....in progress:58% Conducting the graphical lasso (glasso) with lossless screening....in progress:59% Conducting the graphical lasso (glasso) with lossless screening....in progress:59% Conducting the graphical lasso (glasso) with lossless screening....in progress:60% Conducting the graphical lasso (glasso) with lossless screening....in progress:60% Conducting the graphical lasso (glasso) with lossless screening....in progress:61% Conducting the graphical lasso (glasso) with lossless screening....in progress:61% Conducting the graphical lasso (glasso) with lossless screening....in progress:62% Conducting the graphical lasso (glasso) with lossless screening....in progress:62% Conducting the graphical lasso (glasso) with lossless screening....in progress:63% Conducting the graphical lasso (glasso) with lossless screening....in progress:63% Conducting the graphical lasso (glasso) with lossless screening....in progress:64% Conducting the graphical lasso (glasso) with lossless screening....in progress:64% Conducting the graphical lasso (glasso) with lossless screening....in progress:65% Conducting the graphical lasso (glasso) with lossless screening....in progress:65% Conducting the graphical lasso (glasso) with lossless screening....in progress:65% Conducting the graphical lasso (glasso) with lossless screening....in progress:66% Conducting the graphical lasso (glasso) with lossless screening....in progress:67% Conducting the graphical lasso (glasso) with lossless screening....in progress:67% Conducting the graphical lasso (glasso) with lossless screening....in progress:68% Conducting the graphical lasso (glasso) with lossless screening....in progress:68% Conducting the graphical lasso (glasso) with lossless screening....in progress:69% Conducting the graphical lasso (glasso) with lossless screening....in progress:69% Conducting the graphical lasso (glasso) with lossless screening....in progress:70% Conducting the graphical lasso (glasso) with lossless screening....in progress:70% Conducting the graphical lasso (glasso) with lossless screening....in progress:71% Conducting the graphical lasso (glasso) with lossless screening....in progress:71% Conducting the graphical lasso (glasso) with lossless screening....in progress:72% Conducting the graphical lasso (glasso) with lossless screening....in progress:72% Conducting the graphical lasso (glasso) with lossless screening....in progress:73% Conducting the graphical lasso (glasso) with lossless screening....in progress:73% Conducting the graphical lasso (glasso) with lossless screening....in progress:74% Conducting the graphical lasso (glasso) with lossless screening....in progress:74% Conducting the graphical lasso (glasso) with lossless screening....in progress:75% Conducting the graphical lasso (glasso) with lossless screening....in progress:75% Conducting the graphical lasso (glasso) with lossless screening....in progress:76% Conducting the graphical lasso (glasso) with lossless screening....in progress:76% Conducting the graphical lasso (glasso) with lossless screening....in progress:77% Conducting the graphical lasso (glasso) with lossless screening....in progress:77% Conducting the graphical lasso (glasso) with lossless screening....in progress:78% Conducting the graphical lasso (glasso) with lossless screening....in progress:78% Conducting the graphical lasso (glasso) with lossless screening....in progress:79% Conducting the graphical lasso (glasso) with lossless screening....in progress:79% Conducting the graphical lasso (glasso) with lossless screening....in progress:80% Conducting the graphical lasso (glasso) with lossless screening....in progress:80% Conducting the graphical lasso (glasso) with lossless screening....in progress:81% Conducting the graphical lasso (glasso) with lossless screening....in progress:81% Conducting the graphical lasso (glasso) with lossless screening....in progress:82% Conducting the graphical lasso (glasso) with lossless screening....in progress:82% Conducting the graphical lasso (glasso) with lossless screening....in progress:83% Conducting the graphical lasso (glasso) with lossless screening....in progress:83% Conducting the graphical lasso (glasso) with lossless screening....in progress:84% Conducting the graphical lasso (glasso) with lossless screening....in progress:84% Conducting the graphical lasso (glasso) with lossless screening....in progress:85% Conducting the graphical lasso (glasso) with lossless screening....in progress:85% Conducting the graphical lasso (glasso) with lossless screening....in progress:86% Conducting the graphical lasso (glasso) with lossless screening....in progress:86% Conducting the graphical lasso (glasso) with lossless screening....in progress:87% Conducting the graphical lasso (glasso) with lossless screening....in progress:87% Conducting the graphical lasso (glasso) with lossless screening....in progress:88% Conducting the graphical lasso (glasso) with lossless screening....in progress:88% Conducting the graphical lasso (glasso) with lossless screening....in progress:89% Conducting the graphical lasso (glasso) with lossless screening....in progress:89% Conducting the graphical lasso (glasso) with lossless screening....in progress:90% Conducting the graphical lasso (glasso) with lossless screening....in progress:90% Conducting the graphical lasso (glasso) with lossless screening....in progress:91% Conducting the graphical lasso (glasso) with lossless screening....in progress:91% Conducting the graphical lasso (glasso) with lossless screening....in progress:92% Conducting the graphical lasso (glasso) with lossless screening....in progress:92% Conducting the graphical lasso (glasso) with lossless screening....in progress:93% Conducting the graphical lasso (glasso) with lossless screening....in progress:93% Conducting the graphical lasso (glasso) with lossless screening....in progress:94% Conducting the graphical lasso (glasso) with lossless screening....in progress:94% Conducting the graphical lasso (glasso) with lossless screening....in progress:95% Conducting the graphical lasso (glasso) with lossless screening....in progress:95% Conducting the graphical lasso (glasso) with lossless screening....in progress:96% Conducting the graphical lasso (glasso) with lossless screening....in progress:96% Conducting the graphical lasso (glasso) with lossless screening....in progress:97% Conducting the graphical lasso (glasso) with lossless screening....in progress:97% Conducting the graphical lasso (glasso) with lossless screening....in progress:98% Conducting the graphical lasso (glasso) with lossless screening....in progress:98% Conducting the graphical lasso (glasso) with lossless screening....in progress:99% Conducting the graphical lasso (glasso)....done.                                          
```

```r
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
```

```
## Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:0% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:1% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:2% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:3% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:4% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:5% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:6% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:7% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:8% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:9% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:10% Conducting the graphical lasso (glasso) with lossless screening....in progress:11% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:12% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:13% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:14% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:15% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:16% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:17% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:18% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:19% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:20% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:21% Conducting the graphical lasso (glasso) with lossless screening....in progress:22% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:23% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:24% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:25% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:26% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:27% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:28% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso) with lossless screening....in progress:29% Conducting the graphical lasso (glasso)....done.                                          
```

```r
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
```

This part generates plots for each figure panel and saves it in a pdf


```
## png 
##   2
```

```
## png 
##   2
```

```
## png 
##   2
```

```
## png 
##   2
```
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.3.1 (2016-06-21)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: CentOS release 6.7 (Final)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] cowplot_0.8.0           reshape2_1.4.2         
##  [3] ggplot2_2.2.1           RSkittleBrewer_1.1     
##  [5] devtools_1.13.3         huge_1.2.7             
##  [7] igraph_1.1.2            lattice_0.20-35        
##  [9] Matrix_1.2-11           glasso_1.8             
## [11] gtable_0.2.0            gridExtra_2.3          
## [13] sva_3.22.0              genefilter_1.56.0      
## [15] mgcv_1.8-22             nlme_3.1-131           
## [17] clusterGeneration_1.3.4 MASS_7.3-47            
## [19] mvtnorm_1.0-6           knitr_1.17             
## 
## loaded via a namespace (and not attached):
##  [1] splines_3.3.1        colorspace_1.3-2     stats4_3.3.1        
##  [4] blob_1.1.0           survival_2.41-3      XML_3.98-1.9        
##  [7] rlang_0.1.2          withr_2.0.0          DBI_0.7             
## [10] BiocGenerics_0.21.3  bit64_0.9-7          plyr_1.8.4          
## [13] stringr_1.2.0        munsell_0.4.3        memoise_1.1.0       
## [16] evaluate_0.10.1      labeling_0.3         Biobase_2.34.0      
## [19] IRanges_2.8.2        parallel_3.3.1       curl_2.8.1          
## [22] AnnotationDbi_1.36.2 Rcpp_0.12.13         xtable_1.8-2        
## [25] scales_0.5.0         S4Vectors_0.12.2     annotate_1.52.1     
## [28] bit_1.1-12           digest_0.6.12        stringi_1.1.5       
## [31] grid_3.3.1           tools_3.3.1          bitops_1.0-6        
## [34] magrittr_1.5         RCurl_1.95-4.8       lazyeval_0.2.0      
## [37] tibble_1.3.4         RSQLite_2.0          pkgconfig_2.0.1     
## [40] httr_1.3.1           R6_2.2.2             git2r_0.19.0
```

```r
Sys.time()
```

```
## [1] "2017-10-11 01:40:40 EDT"
```

