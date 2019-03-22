# Introduction to R
 - use R as a basic calculator
 - variable assignment
 - basic data types
 - package installation & loading
 - data import/export
 - workflow control
 - write your own functions

## Get the tools
#### R : https://www.r-project.org/
#### RStudio : https://www.rstudio.com/

## Use R as a basic calculator

```r
> 1+1
[1] 2
> 2*5.5
[1] 11
> 2^5
[1] 32
> log(10)
[1] 2.302585
> (1+exp(1))/(1-exp(1))
[1] -2.163953
```

## Variable assignment

```r
> x=2
> y=2L
> z=x+y
> z
[1] 4
> typeof(x)
[1] "double"
> typeof(y)
[1] "integer"
> typeof(z)
[1] "double"
```

## Basic data types
### Numeric/Character
```r
> typeof(2)
[1] "double"
> typeof('A')
[1] "character"
> typeof(2L)
[1] "integer"
> is.numeric(2)
[1] TRUE
> is.numeric('A')
[1] FALSE
> is.character('A')
[1] TRUE
```

### Vector/Array

```r
> v=c(1,2,6)
> v^2
[1]  1  4 36
> m=array(c(1,2,3,4,5,6),c(2,3))
> m
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6
```

### List
```r
> l=list(1,2,3)
> l
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

> l[[2]]
[1] 2
> l2=list(name='John',age=20)
> l2
$name
[1] "John"

$age
[1] 20

> l2$name
[1] "John"
> l2$age
[1] 20
> length(l2)
[1] 2
```

### Data.frame
```r
> df=data.frame(x=c(1,2,3),y=c('A','B','C'))
> df
  x y
1 1 A
2 2 B
3 3 C
> dim(df)
[1] 3 2
> head(iris,5)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
> typeof(df)
[1] "list"
> df$x
[1] 1 2 3
```

## Package installation & loading

#### Install : Use RStudio
#### Load : library(MASS)

## data import/export
### save data.frame to CSV format
```r
> write.csv(iris,file='iris.csv')
> iris_data=read.csv('iris.csv')
> head(iris_data,5)
  X Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1 1          5.1         3.5          1.4         0.2  setosa
2 2          4.9         3.0          1.4         0.2  setosa
3 3          4.7         3.2          1.3         0.2  setosa
4 4          4.6         3.1          1.5         0.2  setosa
5 5          5.0         3.6          1.4         0.2  setosa
```

### general R objects via save/load
```r
> save(iris,file='iris.rdata')
> load('iris.rdata')
```

### Workflow control

#### If/else
```r
x=2
y=5
if (x>y){
  print(x)
}else{
  print(y)
}
[1] 5
```

#### For loop
```r
for (i in 1:5){
   print(i*i)
 }
[1] 1
[1] 4
[1] 9
[1] 16
[1] 25
```

## Write your own functions

```r
my_func = function(x,y){
  z=x+y
  return(z)
}
```

```r
my_func(2,4)
[1] 6
```
