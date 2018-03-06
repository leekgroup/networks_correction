---
title: "AUPRC -- wgcna networks"
output:
  html_document:
    code_folding: hide
---

```r
## load library
library(knitr)

load("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig2/fig2.RData")
library("pracma")
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
compute.auprc <- function(x,y){
	# x = filter(dat)$recall
	# y = filter(dat)$precision
	naid <- which(is.na(y))
	if(length(naid) > 0){
		x = x[-naid]
		y = y[-naid]
	}
	id <- order(x)
	auprc <- trapz(x[id],y[id])
	auprc
}

plot.sub %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type        test
##          <fctr>       <dbl>
##  1 PC corrected 0.002133816
##  2      half-PC 0.002111637
##  3   quarter-PC 0.003050323
##  4  exonic rate 0.001803722
##  5       expeff 0.001997304
##  6          RIN 0.002905990
##  7     gene GC% 0.002290882
##  8       multi3 0.002081592
##  9       multi7 0.002390889
## 10  uncorrected 0.002485568
```

```r
plot.lung %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type        test
##          <fctr>       <dbl>
##  1 PC corrected 0.001710185
##  2      half-PC 0.002236289
##  3   quarter-PC 0.003561092
##  4  exonic rate 0.002281564
##  5       expeff 0.003887010
##  6          RIN 0.002906986
##  7     gene GC% 0.003723040
##  8       multi3 0.001927181
##  9       multi7 0.002003882
## 10  uncorrected 0.003870623
```

```r
plot.thyroid %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type        test
##          <fctr>       <dbl>
##  1 PC corrected 0.002059336
##  2      half-PC 0.002363476
##  3   quarter-PC 0.003239028
##  4  exonic rate 0.002113089
##  5       expeff 0.002690770
##  6          RIN 0.002449922
##  7     gene GC% 0.002174051
##  8       multi3 0.002414837
##  9       multi7 0.002790421
## 10  uncorrected 0.002422588
```

```r
plot.muscle %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type         test
##          <fctr>        <dbl>
##  1 PC corrected 0.0009668461
##  2      half-PC 0.0017194144
##  3   quarter-PC 0.0025784800
##  4  exonic rate 0.0029729538
##  5       expeff 0.0020218357
##  6          RIN 0.0028118069
##  7     gene GC% 0.0030288878
##  8       multi3 0.0030980886
##  9       multi7 0.0033222644
## 10  uncorrected 0.0040714561
```

```r
plot.blood %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type        test
##          <fctr>       <dbl>
##  1 PC corrected 0.001881688
##  2      half-PC 0.003040856
##  3   quarter-PC 0.003492810
##  4  exonic rate 0.005112739
##  5       expeff 0.005105910
##  6          RIN 0.005025508
##  7     gene GC% 0.005323389
##  8       multi3 0.003103963
##  9       multi7 0.003718263
## 10  uncorrected 0.004981224
```
