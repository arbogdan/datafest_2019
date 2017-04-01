<style>
.small-code pre code {
  font-size: 1.2em;
}
</style>

Introduction to R
========================================================
author: Martha Miller, Eddie Pantridge
date: 2017-03-31
css: style.css 


Download R and R Studio
========================================================

https://www.r-project.org/

https://www.rstudio.com/products/rstudio/download/


Setting Variables
========================================================


```r
# Sets the variable x to 5
x <- 5

# Evaluates the variable 5
x
```

```
[1] 5
```


Data Types
========================================================


```r
s <- "HelloWorld" 
s
```

```
[1] "HelloWorld"
```


```r
x <- 5
y <- 0.2
z <- x + y
z
```

```
[1] 5.2
```

```r
as.character(z)
```

```
[1] "5.2"
```


Data Types (cont.)
========================================================


```r
b <- T 
b
```

```
[1] TRUE
```


```r
if (x > 5) {
  "Data"
} else {
  "Fest"
}
```

```
[1] "Fest"
```


Data Types (cont.)
========================================================


```r
my_vector <- c(1, 2, 3, 2, 1)
my_vector
```

```
[1] 1 2 3 2 1
```

```r
sum(my_vector)
```

```
[1] 9
```


Loops
========================================================


```r
1:5
```

```
[1] 1 2 3 4 5
```

```r
for (i in 1:5) {
  print(i * i)
}
```

```
[1] 1
[1] 4
[1] 9
[1] 16
[1] 25
```


Questions?
========================================================

Take 5 minutes to exeriments with different data types,
vectors, loops, if, etc.


Loading data
========================================================
class: small-code

Save and load the data.
















































```
Error in setwd("/Users/mm40078/Documents/projects/datafest2016/data/") : 
  cannot change working directory
```
