
utput:
  html_document:
    code_folding: hide
---

```r
## load library
library(knitr)

load("/work-zfs/abattle4/parsana/networks_correction/publication_figures/fig3/fig3.RData")
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
##            type         test
##          <fctr>        <dbl>
##  1 PC corrected 0.0012323269
##  2      half-PC 0.0014503423
##  3   quarter-PC 0.0017696745
##  4  exonic rate 0.0005043881
##  5       expeff 0.0005057095
##  6          RIN 0.0005115383
##  7     gene GC% 0.0005200036
##  8       multi3 0.0005074597
##  9       multi7 0.0005079930
## 10  uncorrected 0.0005086463
```

```r
plot.lung %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type         test
##          <fctr>        <dbl>
##  1 PC corrected 0.0012064635
##  2      half-PC 0.0016910588
##  3   quarter-PC 0.0021861530
##  4  exonic rate 0.0004996275
##  5       expeff 0.0005160997
##  6          RIN 0.0005054416
##  7     gene GC% 0.0005229998
##  8       multi3 0.0004884227
##  9       multi7 0.0004906885
## 10  uncorrected 0.0005199695
```

```r
plot.thyroid %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type         test
##          <fctr>        <dbl>
##  1 PC corrected 0.0012726160
##  2      half-PC 0.0015832765
##  3   quarter-PC 0.0019530591
##  4  exonic rate 0.0005043616
##  5       expeff 0.0004890049
##  6          RIN 0.0004997399
##  7     gene GC% 0.0005058996
##  8       multi3 0.0005008697
##  9       multi7 0.0004984602
## 10  uncorrected 0.0004970123
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
##  1 PC corrected 0.0007979738
##  2      half-PC 0.0009860122
##  3   quarter-PC 0.0013398350
##  4  exonic rate 0.0004435070
##  5       expeff 0.0004550659
##  6          RIN 0.0004640960
##  7     gene GC% 0.0004654815
##  8       multi3 0.0004350759
##  9       multi7 0.0004305493
## 10  uncorrected 0.0004596975
```

```r
plot.blood %>%
  group_by(type) %>%
  summarize(test = compute.auprc(recall, precision))
```

```
## # A tibble: 10 x 2
##            type         test
##          <fctr>        <dbl>
##  1 PC corrected 0.0013542627
##  2      half-PC 0.0019454824
##  3   quarter-PC 0.0025032838
##  4  exonic rate 0.0006202995
##  5       expeff 0.0005940520
##  6          RIN 0.0006328738
##  7     gene GC% 0.0006526779
##  8       multi3 0.0006482474
##  9       multi7 0.0006154906
## 10  uncorrected 0.0006206285
```
