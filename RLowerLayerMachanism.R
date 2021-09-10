#1. a review of language
#R is an object oriented, functional, array programming language in which objects are specialized data structures, stored in RAM and accessed via names or symbols

#unlike in languages such as C and C++, we cant access memory locations directly

#the names and symbols themselves are objects that can be manipulated

#all objects are stored in RAM during program execution, which has signification implications ofr the analysis of massive dataset

#every object has attributes. Attributes can be listed with the attributes() function and set with the attr() function
#a key attribute is an object's class, which can be read and set with class() function


#2. data types
#atomic vectors: array that contain a single data type
#generic vectors: also called list, are collections of atomic vectors, lists are recursive in that they can also contain other lists

#we dont have to declare an object's data type or allocate space for it, the data type is determined implicitly from the object's contents, and the size grows or shrinks automatically depending on the type and number of elements the object ocntains

#atomic vectors that contain a single data type(logical, real, complex, character or raw)
passed<-c(T,T,F,T)
ages<-c(15,18,25,14,19)
cmplxNums<-c(1+2i,0+1i,39+3i,12+2i)
names<-c("Bob","Ted","Carol","Alice")
#each of the above is a one-dimensional atomic vector
#vectors of type "raw" hold raw bytes and arent discussed here

#many R data types are atomic vectors with special attributes
#for example, E doesnt have a scalar type. A scalar is an atomic vector with a single element. So K<-2 is a shortcut for k <-c(2)

#a matrix is an atomic vector that has a dimension attribute, dim, containing two elements(number of rows and number of columns)
x<-c(1,2,3,4,5,6,7,8)
class(x)
print(x)

#then add a dim attribute
attr(x,"dim")<-c(2,4)
#the object is now a 2x4 matrix of class matrix
print(x)

class(x)

attributes(x)
#row and column names can be attached by adding a dimnames attribute
attr(x, "dimnames")<-list(c("A1","A2"),c("B1","B2","B3","B4"))
print(x)

#a matrix can be returned to a one-dimensional vector by removing the dim attribute
attr(x,"dim")<-NULL
class(x)
print(x)

#ann arrary is an atomic vector with a dim attribute that has three or more elements
#we can attach labels with the dimnames attribute
#like one-dimensional vectors, matrices and arrays can be of type logical, numeric, character, complex or raw
#but note that we cant mix types in a single array

#the attr() allows to create arbitrary attributes and associate them with an object.
#attributes store additional information about an object and can be use by functions to determine how they process

#3. a number of special functions for setting attributes
dim()
dimnames()
names()
row.names()
class()
tsp() #time series object
#these special functions have restrictions on the vlaues that can be set
#their restrictions and the error messages they produce make coding errors less likely and more obvious

#4. generic vector or lists
#lists are collections of atomic vectors and/or other lists
#data frames are special type of list where each atomic vector in the collection has the same length

head(iris)

#containing five atomic vectors

unclass(iris) #easily seen by printing the data frame with unclass() function
attributes(iris)#obtaining the attributes 

set.seed(1234)
fit<-kmeans(iris[1:4],3)

names(fit)

unclass(fit)

#executing sapply(fit,class)
sapply(fit,class)
#in this example, cluster is an integer vector containing the cluster memberships, and centers is a matrix containing the cluster centroids(means on each variable for each cluster)
#size component is an integer is an integer vector containing the number of plants in each of the three clusters



#str() function displays the obejcts structure
#unclass() function can be used to examine the objects contents directly
#length() function indicates how many components the object contains
#the names() function provides the names of these components
#use the attributes() to examine the attributes of the object
#sapply() returns the class of each component of the object



#indexing
#the elements of any data object can be extracted via indexing
object[index]#where object is the vector and index is an integer vector, if the elements of the atomic vactor have been named, index can also be a character vector with these names


#indexing for  an atomic vector without named elements
x<-c(20,30,40)
x[c(2,3)]

#indexing for an atomic vector with named elements
x<-c(A=20, B=30, C=40)
x[c("B","C")]

#for lists, components(atomic vectors or other lists) can be extracted using object[index], where index is an integer vector

fit[c(2,7)]
fit$centers
fit
#note that components are returned as a list


#to get the elements in the component, use object[{integer}]
fit[2]
#a list is returned


fit[[2]]
#a matrix is returned

#the difference can be important, depending on what we do with the results
#if we want to pass the results to a function that requires a matrix as input, we would want to use the double bracket notation

#to extract a single named component, we can use the $ notation
fit$centers
#this also explains why the $ notation works with data frames
#the data frame is a special case of a list, where each variable is represented as a component
iris$Sepal.Length

fit[[2]][1,]
#extracts the second component of fit(a matrix of means) and returns the first row(the means for the first cluster on each of the four variables)


set.seed(1234)
fit<-kmeans(iris[1:4],3)
means<-fit$centers#obtains the cluster means
library(reshape2)
dfm<-melt(means)
names(dfm) <-c("Cluster","Measurement","Centimeters")
dfm$Cluster <-factor(dfm$Cluster)#reshapes the data to a long form
head(dfm)
library(ggplot2)
ggplot(data=dfm, aes(x=Measurement, y=Centimeters, group=Cluster)) +
  geom_point(size=3, aes(shape=Cluster, color=Cluster))+
  geom_line(size=1, aes(color=Cluster))+
  ggtitle("Profiles for Iris Clusters")#plots a line graph

#this type of graph is possible because all the variables plotted use the same units of measurement(centimeters)
#if the cluster analysis involved variables on different scales, we would need to standardize the data before plotting and label the y-axis something like standardized scores

#5. control structures

#when the R interpreter processes code, it reads sequentially, line by line. If a line isnt a complete statement, it reads additional lines untial a fully formed statement can be constructured
3+2+5

3+2+
5  
#+ sign at the end of the first line indicates that the statement isnt complete
3+2
+5
#obviously doesnt work, because 3+2 is interpreted as a complete statement

#6. three control-flow functions

#for loops

for(var in seq){
  statement
}
#var is variable name and seq is an expression that evaluates to a vector, if there is only one statement, the curly braces are optional:
for(i in 1:5)print(1:i)

for(i in 5:1)print(1:i)

#IF() AND ELSE

if(condition){
  statements
}
else{
  statements
}
#the condition should be a one-element logical vector(T or F) and cant be missing(NA)
#else portion is optional. if there is only one statement, the curly braces are also optional

if(interactive()){
  plot(x,y)
  
}else{
  png("myplot.png")
  plot(x,y)
  dev.off()
}
#if the code is being run interactively, the interactive() function returns T and a plot is sent to the scree
#otherwise, the plot is saved to disk 

#IFELSE(), is a vectorized version of if()
#allows a function to process object without explicit looping
ifelse(test, yes, no) #where test is an object that has been coerced to logical mode, yes returns values for true elements of test, and no returns values for false elements of test

pvalues<-c(.0867,.0018,.0054,.1572,.0183,.5386)
results<-ifelse(pvalues<.05,"Significant","Not Significant")
results

results<-vector(mode="character",length=length(pvalues))
for(i in i:length(pvalues)){
  if(pvalues[i]<.05)results[i]<-"Significant"
  else results[i]<-"Not Significant"
}
#vectorized version is faster and more efficient

#7. other control strcutures
while()
  repeat()
switch()


#8. creating functions

functionname<-function(parameters){
  statements
  return(value)
}
#if there is more than one parameter, the parameters are separated by commas
#parameters can be passed by keyword, by position or both
#additionallym parameters can have default values

f<-function(x,y,z=1){
  result<-x+(2*y)+(3*z)
  return(result)
}
f(2,3,5)
f(2,3)
f(x=2,y=3)
f(z=4,y=2,3)
f(z=3,y=2,y=3,4,5,6)
#in the firt case, the parameters are passed by position(x=2, y=3, z=4)
#in the second case, the parameters are paased by position, and z defaults to 1
#in the third case, the parameters are passed by keyword, and z again defaults to 1
#in the final case, y and z are passsed by keyword, and x is assumed to be the first parameter not explicitly specified(x=3)
#this also demonstrates that parameters passed by keyword can appear in any order

#parameters are optional, but we must include the parentheses even if no values are being passed
#the return()function returns the object produced by the function. It is also optional, and if missing, the result of the last statement in the function are returned

args(f)
#args() function to veiw the parameter names and default values

#args() is designed for interactive viewing, if we need to obtain the parameter names and defaut values programmatically, use the formulas()function, it returns a list with the necessady information

#parameters are passed by value, not by reference
result<-lm(height~weight,data=women)
#if the woman dataset was very large, RAM could be used up quickly, this can become an issue when we r dealing with big data probelms
#we may need to use special techiniques


#9. object scope
#the scope of the objects in R:
#objects created outside of any function are global
#objects created within a function are local
#local objects are discarded at the end of function execution, only objects passed back via the return() function are accessible after the function finishes executing
#global objects can be accessed(read) from within a function but not altered (unless the << operater used)
#objects passed to a function through parameters arent altered by the function, Copies of the objects are passed, not the objects themselves


#10. working with environment

#an environment in R consists of a frame and enclosure
#a frame is set of symbol-value pairs(object names and their content)
#an enclosure is a pointer to an envlosing environment
#the enclosing environment is also called the parent environment
#R allows to manipulate environments from within the language, reulting in fine-grained control over scope and the segregation of functions and data

#we can create a new environment with the new.env() function and create assignments in that environment with the assign() function, object values can be retrieved from an environment using the get() function

x<-5
myenv<-new.env()
assign("x","Homer",env=myenv)
ls()
ls(myenv)
x
get("x",env=myenv)

#an object x exists in the global environment and has the value 5
#an object called x ensits also in the environment myenv and has the value "Homer"

myenv<-new.env()
myenv$x<-"Homer"
myenv$x

#parent.env() function displays the parent environment.

parent.env(myenv)

#because functions are objects, they also have  environments.
#this is important when considering function closures(functions that are packaged with the state that existed when they were created)

trim<-function(p){
  trimit<-function(x){
    n<-length(x)
    lo<-floor(n*p)+1
    hi<-n+1-lo
    x<-sort.int(x,partial=unique(c(lo,hi)))[lo:hi]
  }
  trimit
}
#the trim(p) function returns a function that trims p percent of the high and low values from a vector
x<-1:10
trim10pct<-trim(.1)
y<-trim10pct(x)
y
trim20pct<-trim(.2)
y<-trim20pct(x)

#this works because the value of p is in the environment of the trimit() function and is saced with the function
ls(environment(trim10pct))
get("p", env=environment(trim10pct))

#R functions include the objects that existed in their environment when they were created

makeFunction <-function(k){
  f<-function(x){
    print(x+k)
  }
}
g<-makeFunction(10)
g(4)

ls(environment(g))
environment(g)$k

#if the object isnt found in its local environment, r searches in the parent environment, then the parent's parent environemnt and so on, until the object is found
#when it hasnt found, it throws an error, this is called lexical scoping

#learn more
#environments in R by Christopher Bare : http://mng.bz/uPYM
#Lexical scope and function closures in R by Darren Wilkinson: http://mng.bz/R286

#11. object oriented programming OOP
#OOP language is based on the use of generic functions
#each object has a class attribute that is used to determine what code to run when a cope of the object is passed to a generic function such as print() plot() , or summary()

#R has two separate OOP models, The S3 model is older, simpler and less structured. It is easier to use and most applications in R use this model
#S4 model is newer and more structured

#12. generic functions in R

#R uses the class of an object to determine what action to take when a generic function is called
summary(women)
fit<-lm(weight~height, data=women)
summary(fit)

summary

class(women)
class(fit)

#the function call summary(women) executes the function summary.data.frame(women) if it exists, or summary.default(women) otherwise
#similary, summary(fit) executes the function summary.lm(fit), or summary.default(fit) otherwise

#UseMethod() function dispatches the object to the generic function that has an extension matching the object's class

methods(summary)
#list all S3 generic functions available

#the number of functions returned depends on the packages we have installed on the machine

#we can view the code for the fucntions in the previous example by typing their names without the parentheses
summary.data.frame

summary.lm

summary.default

#Non-visible functions(functions in the methods list followed by asterisks) cant be viewed this way

#in these cases we can use the getAnywhere(summary.ecdf), viewing existing code is a great way to get ideas for our own functions

getAnywhere(summary.ecdf)


#we have seen classes such as numeric, matrix, data.frame, array, lm, glm and table, but the calss of an object can be any arbitrary string
#additionally, a generic function doesnt have to be print(), plot() or summary()
#any function can be generic

#the following listing defines a generic function called mymethod()

mymethod<-function(x,...)UseMethod("mymethod")
mymethod.a<-function(x)print("Using A")
mymethod.b<-function(x)print("Using B")
mymethod.default<-function(x)print("Using Default")

x<-1:5
y<-6:10
z<-10:15
class(x)<-"a"
class(y)<-"b"

mymethod(x)
mymethod(y)
mymethod(z)

class(z)<-c("a","b")

mymethod(z)

class(z)<-c("c","a","b")
mymethod(z)


#thedefualt method is used for object z because the object has class integer and no mymethod.integer() function has been defined

#an object can be asigned to more than one class(for example, buiding, resisdential and commercial)

#when z is assigned two classes, the first class is used to determine which generic function to call
#in the final example, there is no mymethod.c() function so the next class in line (a) is used 
#R searches the class list from left to right, looking for the first available generic function

#13. limitation of the S3 model
#the primarily limitation of the S3 object model is that fact that any class can be assigned to any object, there are no integrity checks

class(women)<-"lm"
summary(women)
#the data frame women is assigned class lm, which is nonsensical and leads to errors

#S4 OOP moedl is more formal and rigorous and designed to avoid the difficulties raised by the S3 model's less structured approach
#classes are defined as abstract objects that have slots containing specific types of information(that is, typed variables)
#object and method construction are formally defined, with rules that are enforced
#but programming using the S4 model is more complex and less interactive

#learn more about the S4 OOP model, see" A(Not So) Short Introduction to S4" nu Chistophe Genoolini(http://mng.bz/1VkD)

#14. writing efficient code

#a power use is someone who spends an hour tweaking their code so that it runs a second faster

#the easiest way to make code run faster is to beef up our hardware(RAM, processor speed and so on)
#as a general rule, it is more important to write code that is understandable and easy to maintain than it is to optimize its speed
#but when we are working with large datasets or highly repetitive tasks, speed can become an issue


#read in only the data we need
#use vectorization rather than loops whenever possible
#create objects of the correct size, rather than resizing repeatedly
#use parallelization for repetitive, independent tasks


#15. efficient data input

#when we are reading data from a delimited text file via the read.table() function
#we can achieve significant speed gains by specifying which variables are needed and  their types, this can be accomplished by including a colClasses parameter

my.data.frame<-read.table(mytextfile,header=T, sep=',', 
                          colClasses=c("numeric","numeric","character",
                                       NULL,"numeric",NULL,"character",NULL,
                                       NULL,NULL))
#will run faster than
my.data.frame<-read.table(mytextfile, header=T,sep=',')

#16. vectorization
#use vectorization rather than loops whenever possible
#which means using R functions that are designed to process vectors in a highly optimized manner
#examples in the base installation include ifelse(), colSums(), colMeans(), rowSums(), and rowMeans()

#the matrixStats package offers optimized functions for many additioanal calculations, including counts, sums, products, measures of central tendency and dispersion, quantiles, ranks and binning

#packages such as plyr, dplyr, reshape2 and data.table also provide functions that are highly optimized

set.seed(1234)
mymatrix<-matrix(rnorm(10000000), ncol=10)

#create a function called accum() that uses for loops to obtain the column sums
accum<-function(x){
  sums<-numeric(ncol(x))
  for(i in 1:ncol(x)){
    for(j in 1:nrow(x)){
      for(j in 1:nrow(x)){
        sums[i]<-sums[i]+x[j,i]
      }
    }
  }
}

#system.time() function can be used todetermine the amount of CPU and real time needed to run the function

system.time(accum(mymatrix))

#correctly sizing objects

set.seed(1234)
k<-100000
x<-rnorm(k)
#y starts as a one element vector and grows to be a 100,000 element vector containing the squared values of x
y<-0
system.time(for (i in 1:length(x))y[i]<-x[i]^2)

#if we first initialize y to be a vector with 100,000 elements, its just less than a second
y<-numeric(length=k)
system.time(for (i in 1:k)y[i]<-x[i]^2)


#parallelization
#involve chunking up a task, runnng the chunks simultaneously on two or more ores and combining the results
#the cores might be on the same computer or on different machines in a cluster
#takes that requires the repeated independent execution of a numerically intensive function are likely to benefit from paralllelization
#this includes many Monte Carlo methods, including bootstrapping

#many packages in R support parallelization(see "CRAN Task View: High-Performance and Parallel Computing with R)by Dirk Eddelbuettel, http://mng.bz/65sT)

#use the foreach and doParallel packages to see parallelization on a single computer

#the foreach package supports the foreach looping construct(iterating over the elements in a collection) and facilitates executing loops in parallel
#the doParallel package provides a parallel back end for the foreach package

#in principal components and factor analysis, a critical step is identifying the appropriate number of components or factors to extrct from the data
#one approach involves repeatedly performing an eigenanalysis of correlation matrices derived from random data that have the same number of rows and columns as the original data


install.packages("foreach")
install.packages("doParallel")
library(foreach)
library(doParallel)

eig<-function(n,p){
  x<-matrix(rnorm(100000),ncol=100)
  r<-cor(x)
  eigen(r)$values
}
n<-1000000
p<-100
k<-500

system.time(
  x<-foreach(i=1:k,.combine=rbind)%do%eig(n,p)
)

system.time(
  x<-foreach(i=1:k,.combine=rbind)%dopar%eig(n,p)
)
#first the packages are loaded and the number of cores is registered
#next, the function ofr eigenanalysis is definedm here 100,000x100 random data matrices are analyzed
#the eigh() function is executed 500 times using foreach and %do%
#%do% operator runs the function sequentially and the .combine=rbind option appends the results to object x as rows
#finally, the function is run in parallel using the %dopar% operator

#in this example, each iteration of the  eig() function was numerically intensive, didnt require access to other iterations, and didnt involve disk 1/0
#this is the type of situation that benefits the most from parallelization
#the ownside of parallelization is that it can make the code less portable- there is no guarantte that others will have the same hardware configuration that you do

#the four efficiency measures described can help us to process really large datasets, but when we are working with big datasets, methods like those descirbed in appendix G are required

#17. locating bottlenecks

#R provides tools for profiling programs in order to identify the most time consuming fucntions
#place the code to be profiled between Rrpof() and Pprof(NULL)
#then excecute summaryRprof() to get a summary of the time spent executing each function

?Rprof
?summaryRprof


#18. debugging

#common sources of errors

#an object name is misspelled or the object doesnt exist
#there is a misspecification of the parameters in a function call
#the contents of an object arent what the user expects, errors are often caused by passing objects that are NULL or contain NaN or NA values to a function that cant handle them

mtcars$Transmission <-factor(mtcars$a, levels=c(0,1), labels=c("Automatric","Manual"))
aov(mpg~Transmission,data=mtcars)

head(mtcars[c("mpg","Transmission")])

table(mtcars$Transmission)

#there are no cars with a manual transmission
#looking back at the original dataset, the variable am is coded 0=automatic, 1=mannual(not 1=automatic, 2=manual)

#the factor() function happily did what you aksed without warnings or errors, it set all cars with manual transmissions to automatic and all cars with automatic transmissions to missing

#19. debugging tools
#althoug examing object names, function parameters and function inputs will uncover many sources of error, sometimes we have to delve into the inner workings of functions and functions that call functions
#the internal debugger that comes with R can be useful

debug()#marks a function for debugging
undebug() #unmarks a function for debugging
browser()#allow single-stepping through the execution of a function
trace()#modifies a function to allow debug code to be temporarily inserted
untrace()#cancels tracing and removes the temporary code
trackback()#prints the sequence of function calls that led to the last uncaught error

#debug() function marks a function for debugging, when the function is executed, the brower() function is called and allows you to step through the function;s execution one line at a time
#the undebug() function truns this off, allowing the function to execute normally
#we can temporarily insert debugging code into a function with the trace() function, this is particularly useful when we are debugging base functions and CRAN-contributed functions that cant be edited directly

#if a function calls other function, it can be hard to determine where an error has occurredm in this case, executing the traceback() function immediately after an error will list the 
#sequence of function calls that led to the error, the last call is the one that produced the error

args(mad)

debug(mad)
mad(1:10)

#first, the arg() function is used to display the argument names and default values for the mad() function
#the debug flag is then set using debug(mad)
#now, whenever mad() is called, the browser() function is executed, allowing we to step through the function a line at a time
#the prompt changes to Browse[n], n indicates the browser level, the number increments with each recursive call

#in the browser() mode, other R commands can be executed, for example, ls() lists the objects in existence at a given point during the function's execution
#typing an object's name displays its content, if an object is named n,c, or Q, we mus tuse print(n), print(c) or print(Q) to view its contents
#we can change the values of objects by typing assignment statements

#we step through the function and execute the statements one at a time by entering the letter n or pressing the Return or Enter key
#the where statement indicates where we are in the stake of function calls being executed. With a single function, this isnt very interesting; but if we have functions that call other functions, it can be helpful

#typing cmoves out of single-step mode and executes the remainder of the current function. 
#Typing Q exits the function and returns us to the R prompt
#debug() function is useful when we have loops and want to see how values are changing, we can also embed the browser() function directly in code in order to help locate a problem


#let's say we have a variable X that should never be negative. Adding the code
if(x<0)browser()
#allows us to explore the current state of the function when the problem occurs
#we can take out the extra code when function is sufficiently debugged

#20. session options that support debugging

#when we have functions that call functions, two session options can help in debugging process
#nirmally, when R encounters an error, it prints an error message and exits the function
#setting options(error=traceback) prints the call stack(the seqyence of function calls that led to the error) as soon as an error occurs.
#this can help determine which function generated the error

#setting options(error=recover)also prints the call stack when an error occurs
#in addition, it prompts you to select one of the functions on the list and then invokes browser() in the corresponding environment
#typing c returns you to the list and typing 0 quits back to the R prompt

#using this recover() mode lets you explore the contents of any object in any function chosen from the sequence of functions called. By selectively viewing the contents of objects, we can frequently determine the origin of the problem
#to return to R's default state, set options(error=NULL)

f<-function(x,y){
  z<-x+y
  g(z)
}
g<-function(x){
  z<-round(x)
  h(z)
}
h<-function(x){
  set.seed(1234)
  z<-rnorm(x)
  print(z)
}
options(error=recover)
f(2,3)
f(2,-3)

#to learn more debugging in general and recover mode in particular, see Roger Peng's excellent "An Introduction to the Interactive Debugging Tools in R"
#http://mng.bz/GPR6

#21. Going further

#excellent sources of information on advanced programming in R
#R language definition:http://mng.bz/U4Cm is a good place to start
#Frames, Environments, and Scope in R and S-PLUS by John Fox(http://mng.bz/Kkbi) is a great article for gaining a better understanding of scope
#How R searches and finds stuff by Suraj Gupta(http://mng.bz/2o5B) is a blog article that can help understand
#efficient coding, see"FasterR!HigherR!StrongR!- A Guide to Speeding Up R Code for Busy People" by Robert Gentleman is a comprehensive yet highly accessible text for programmers tha twant to look under the hood

#P5C21
#1. reasons for creating packages
#to make a set of frequenty used functions easily accessible, along with the documentation on how to use them
#to create a set of examples and datasets that can be distributed to students in a classrom
#to create a program(a set of interrelated functions)that can be used to solve a siginificant analytic problem(such as imputing missing values)

#2. npar package
#it provides functions for nonparametric group comparisons
#this is a set of analytic techniques that can be used to compare two or more groups on an outcome variable that is not normally distributted or in situations where the variance of the outcome variable differs markedly across groups

pkg<-"npar_1.0.tar.gz"
loc<-"http://www.statmethods.net/RiA"
url<-paste(loc,pkg,sep="/")
download.file(url,pkg)
install.packages(pkg, repos=NULL,type="source")


#2. case study: the HLE data contains the health life expectancy(HLE),
#suppose we wanted to know whether HLE eatimates for women vary significantly by region

#our approach would be to use a one-way analysis of variance(ANOVA) 
#but ANOVA assumes the outcome variable is normally distributed and has a constamt variance across each of the four country regions

library(npar)
hist(life$hlef, xlab="Healthy Life Expectancy (years) at Age 65",
     main="Distribution of Healthy Lfe Expectancy for Women",  col="grey", breaks=10)
l
#the distribution of HLE scores from women can be visualized using this histogram
#clearly negatievly skewed with fewer scores at the low end 

#the variance of HLE scores across regions can be visualized using a side-by-side dot chart

library(ggplot2)
ggplot(data=life, aes(x=region, y=hlef))+
  geom_point(size=3, color="darkgrey")+
  labs(title="Distribution of HLE Estimates by Region",
       x="US Region", y="Healthy Life Expectancy at Age 65")+
  theme_bw()
#each dot reprents a state
#variances differ by region, with the greatest differences occuring between the Northeast and South

#because the data violates two important AVOVA assumptions(normality and homogeneity of variance), we need a different approach

#in this current case, we would only need to assume that the data are ordinal that higher scores indicate greater healthy life expectancy
#this makes a nonparametric approach a reasonabvle alternative for the current problem

#3. comparing groups with the npar package

#we can use the npar package to compare independent groups on a numeric outcome ariable that is at least ordinal

#given a numerical dependent variable and a categorical grouping variable, it provides
#an omnibus kruskal=wallis test that the groups dont differ
#descriptive statistics for each group
#post-hoc comparisons(wilcoxon rank-sum tests)comparing groups two at a time. The test p-values can be adjusted to take multiple testing into account
#annotated side-by-side box plots for visualizing group differences

library(npar)
results <-oneway(hlef~region, life)
summary(results)
plot(results, col="lightblue",main="Multiple Comparisons", xlab="US Region", ylab="Healthy Life Expectancy (years)at Age 65")

#first, a kruskal-wallis test is performed, this ia an overall test of whether there are HLE differences between the regions
#the small p value suggests that there are

#next, descirptive statistics(sample size, median and median absolute deviation) are provided for each region
#the HLE estimates are highest for the Northeast(median=15.7 years) and lowest for tha south

#although the kruskal wallis test indicates that there are HLE differences among the regions, it doesnt indicate where the differences lie
#to determine this, we compare the groups two at a time using a Wilcoxon ramk sum test. 
#the difference between the south and the north central regions is statistically significant, whereas the difference between the northeast and north central regions isnt
#in fact, the south differs from each of the other regions, but the other regions dont differ from each other

#when computing multiple comparisons, we have to be concerned with alpha inflation: an increase in the probability of declaring groups to be significantly different when in fact they arent
#for six independent comparison upward(make each test more stringent and less likely to declare a difference)
#doing so keep the overrall family-wise error rate(the probability of finding one or more erroneous differences in a set of comparisons)at a reasonable level(say,.05)

#the oneway() function accomplishes this by calling the p.adjust() function in the base R installation
#the p.adjust() function adjusts p values to account for multiple comparisons using one of several methods
#the bonferonni correction is perhaps the most well known but the Holm correction is more powerful and thus set as the default

#differences among the groups are easiest to see with a graph, the plot produces the side by side box plots which is annotated with a key that 
#indicates the median and sample size for each group. A dotted horizontal line indicates the overall median for all observations combined

#4. developing the npar package

#npar package consistes of four functions: oneway(), print.oneway(), summary.oneway() and plot.oneway()
#the first is the primary function that computes the statistics, and the others are S3 object-oriented generic functions used to print and plot the results
#oneway indicates that there is a single grouping factor

#it is a good idea to place each function in a separate text file with a .R extension.
#this isnt strictly necessary, but it makes organizing the work easier
#additionally, it isnt necessary for the names of the functions and names of the files to match, but agagin, it is a good coding practice

#each file has a header consisting of a set of comments that start with the characters #'.
#the r interpreter ignores these lines, but we will use the roxygen2 package to trun the comments into our package documentation

#5. computing the statistics
oneway()#function in the oneway.R text file performs all the statistical computations required
oneway

#in the oneway.R text file, the header contains comments starting with #' that will be used by the roxygen2 package to create package documentation
#next, we will see function argument list. the user provides a formula of the form dependent variable-grouping variable and a data frame containing the data
#by default, approximate p values are computed and the groups are ordered by their median dependent variable values
#the user can choose from among eight adjustment methods, with the holm method(the first option in the list)chosen by default

#once the user enters the arguments, they are scanned for erros. The if() function tests that the formula isnt missing, that its a formula(variables~variables) and
#that there is only one variable on each side of the tilde(~)
#if any of these three conditions isnt true, the stop() function halts execution, prints an error message, and returns the user to the R prompt
#for debugging purposesm we can alter the error action with the options(error=) function

#match.arg(arg,choices) function ensures that the user has entered an argument that matches one of the strings in the choices character vector
#if a match isnt found, an error is thrown, and, again, oneway() exits.

#next, the model.frame() function is used to create a data frame containing the dependent variable as the first column and the grouping variable as the secnd column.
#in general, the model.fram() returns a data frame containing all the variables in a formula
#from this data frame, we can create a numeric vector(y) containing the dependent variable and a factor vector(g) containing the grouping variable
#the character vector vnames contains the variab;e ma,es

#if sort=T, we use the reorder() function to reorder the levels of the grouping variable g by the median dependent variable values y. This is the default
#the character vector groups contains the names of the groups, and the value k contains the number of groups

#next, a numeric matrix(sumstats) is created, containing the sample size, median and median absolute deviatin for each group
#the aggregate() function uses the getstats() function to calculate the summary statistics, and the remaining code formates the table
#so that groups are columns and statistics are rows(I thought this was more attractive)

#the statistical test are then computed
#the results of the kruskal wallis test are saved to a list called kw.
#the for() functions calculate every pairwise wilcoxon test. The results of these pairwise tests are saved in the wmc data frame

#herem Group.1 and Group.2 indicate the groups being compared to each other, W is the Wilcoxon statistic, and p is the (adjusted)pvalue for each comparison
#finally, the results are bundled up and returned as a list. The list contains seven components.

#6. set the class of the list to c("wmc","list")
#CALL: function call
#data: data frame containing the dependent and grouping variable
#sumstats: data frame with groups as columns and n, median, and mad as rows
#kw: five component list containing the results of the kruskai-wallis test
#method: one element character vector containing the method use to adjust p values for multiple comparisons
#wmc: four column data frame containing the multiple comparisons
#vnames: variable names

#although the list provides all the information required, we would rarely access the components directly
#instead we can create generic print(), summary(), and plot() functions to present this information in more concise and meaningful ways
print(results)
#produces basic information about the multiple comparisons








#7. printing the resulst

#following the S3 OOP guidelines, if an object has the class attribute "foo", then print(x) executes print.foo(x)
#if it exists or print.default(x) otherwise. The same goes for summary() and plot()

#because the oneway() function returns an object of class "oneway" ,we need to define print.oneway(), summary.oneway() and plot.oneway()

#summarizing the results

#summary() produces more comprehensive and processed output than the print() function

summary(results)

#the output includes the results of the kruskal wallis test, descriptive statistics for each group and the multiple comparisons
#in addition, the multiple comparison table is annotated with stars to highlight significant results

#8. plotting the results

plot(results, col="lightblue", main="Multiple Comparisons",
     xlab="US Region",
     ylab="Healthy Life Expectancy(years) at Age 65")
#plot() visualizae the results returned by the oneway() function 

#unlike standard box plots, this plot provides annotations that indicate the median and sample size for each group, and a dashed line indicating the overall group median

#see plot.R file

#9. adding sample data to the package
#when we are creating a package, it is a good idea to include one or more datasets that can be used to try out the included functions


#add data frames to a package as.rda files

region <-c(rep("North Central",12))
state<-c(rep("MA",12))
life <-data.frame(region.factor(region),state)
save(life, file='life.rda')

#save() function saves the data frame life.rda in the current working directory
#when we build the final package, we will move this file to a data subdirectory in the package file tree
#we can also need to create a.R file that documents the data frame

#10. creating the package documentation

#every R  package follows the same set of enforced guidelines for documentation

#each function in a package must be documented in the same fashion using LaTeX, a document markup language and typesetting system
#each function is placed in a separate .R file and the documentation for that function is placed in a .Rd file. Both the .R and .Rd files are text files

#there are two limitations to this approach, first, the documentation is stored eparately from the functions it describe
#if we change the function code, we have to seach out the documentation and change it as well
#second, the user has to learn LaTeX. 

#roxygen2 package can dramatically simplify the create of documentation, we place comments in the head of each .R file that will serve as the function's documentation
#then, the documentation is created using a simple markup language
#when the file is processed by Roxygen2, lines that start with #' are used to generate the LaTeX documentation(.Rd fie) automatically


#tags(roclets) for use with Roxygen2
#@title: function title
#@descirption: one-line function description
#@details: multiline function description(indent after the first line)
#@parm: function parameter
#@export:adds the function to the NAMESPACE
#@method generic class: documents a generic S3 method
#@return : value returned by the function
#@author: author(s) amd contact address(es)
#@examples: examples using the function
#@note: any notes about the operation of the function
#@aliases: additional aliases through which users can find documentation
#@references: references concerning the methodology employed by function


#a few additional markup elements are useful to know as you create documentation
#tage \code{text} print text in code font
#and \link{function} generates a hypertext link to an R function in the current package or elsewhere
#\item{text} generates an itemized list

?npar
help(package="npar")

#see the contents of the napr.R file
#note that the last line of this file must be blank. When the package is built, a call to ?npar will now produce a discription of the package, with a clickable link to an index of functions
