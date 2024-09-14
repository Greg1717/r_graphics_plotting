# http://karolis.koncevicius.lt/posts/r_base_plotting_without_wrappers/

# Base plotting is as old as R itself yet for most users it remains mysterious. They might be using plot() or even know the full list of its parameters but most never understand it fully. This article attempts to demystify base graphics by providing a friendly introduction for the uninitiated.

# Deconstructing a plot =======================================================

# Quickly after learning R users start producing various figures by calling plot(), hist(), or barplot(). Then, when faced with a complicated figure, they start stacking those plots on top of one another using various hacks, like add=TRUE, ann=FALSE, cex=0. For most this marks the end of their base plotting journey and they leave with an impression of it being an ad-hoc bag of tricks that has to be learned and remembered but that otherwise is hard, inconsistent, and unintuitive. Nowadays even experts who write about base graphics or compare it with other systems share the same opinion. However, those initial functions everyone was using are only wrappers on top of the smaller functions that do all the work. And many would be surprised to learn that under the hood base plotting follows the paradigm of having a set of small functions that each do one thing and work well with one another.

# Let’s start with the simplest example.

plot(x = 0:10,
     y = 0:10,
     xlab = "x-axis",
     ylab = "y-axis",
     main = "my plot")

# The plot() function above is really just a wrapper that calls an array of lower level functions.

plot.new()
plot.window(xlim = c(0,10), ylim = c(0,10))
points(0:10, 0:10)
axis(1)
axis(2)
box()
title(xlab = "x-axis")
title(ylab = "y-axis")
title(main = "my plot")

# Written like this all the elements comprising the plot become clear. Every new function call draws a single object on top of the plot produced up until that point. It becomes easy to see which line should be modified in order to change something on the plot.

# Just as an example let’s modify the above plot by:
# 1) adding a grid,
# 2) removing the box around the plot,
# 3) removing the axis lines,
# 4) making axis labels bold,
# 5) turning the annotation labels red, and
# 6) shifting the title to the left.

plot.new()
plot.window(xlim = c(0,10), ylim = c(0,10))
grid()
points(0:10, 0:10)
axis(1, lwd = 0, font.axis=2)
axis(2, lwd = 0, font.axis=2)
title(xlab = "x-axis", col.lab = "red3")
title(ylab = "y-axis", col.lab = "red3")
title(main = "my plot", col.main = "red3", adj = 0)

# In each case to achieve the wanted effect only a single line had to be modified. And the function names are very intuitive. A person without any R experience would have no trouble saying which element on the plot is added by which line or changing some of the parameters.

# So, in order to construct a plot various functions are called one by one. But where do we get all the names for those functions? Do we need to remember hundreds of them? Turns out the set of all the things you might need to do on a plot is pretty limited.

# par()          # specifies various plot parameters
# plot.new()     # starts a new plot
# plot.window()  # adds a coordinate system to the plot region
#
# points()       # draws points
# lines()        # draws lines connecting 2 points
# abline()       # draws infinite lines throughout the plot
# arrows()       # draws arrows
# segments()     # draws segmented lines
# rect()         # draws rectangles
# polygon()      # draws complex polygons
#
# text()         # adds written text within the plot
# mtext()        # adds text in the margins of a plot
#
# title()        # adds plot and axis annotations
# axis()         # adds axes
# box()          # draws a box around a plot
# grid()         # adds a grid over a coordinate system
# legend()       # adds a legend

# The above list covers majority of the functionality needed to recreate almost any plot. And for demonstration example() can be used to quickly see what each of those functions do, i.e. example(rect). R also has some other helpful functions like rug() and jitter() to make some things easier but they are not crucial and can be implemented using the ones listed above.

# Function names are quite straightforward but what about their arguments? Indeed some of argument names, like cex can seem quite cryptic. But the argument name is always an abbreviation for a property of the plot. For example col is a shorthand for “color”, lwd stands for “line-width”, and cex means “character expansion”. Good news is that in general the same arguments stand for the same properties across all of base R functions. And for a specific function help() can always be used in order to get the list of all arguments and their descriptions.

# To further illustrate the consistency between arguments let’s return to the first example. By now it should be pretty clear, with one exception - the axis(1) and axis(2) lines. Where do those numbers: 1 and 2 came from? The numbers specify the positions around the plot and they start from 1 which refers to the bottom of the plot and go clockwise up to 4 which refers to the right side. The picture below demonstrates the relationship between numbers and four sides of the plot.

plot.new()
box()
mtext("1", side = 1, col = "red3")
mtext("2", side = 2, col = "red3")
mtext("3", side = 3, col = "red3")
mtext("4", side = 4, col = "red3")

# The same position numbers are used throughout the various different functions. Whenever a parameter of some function needs to specify a side, chances are it will do so using the numeric notation described above. Below are a few examples.

par(mar = c(0,0,4,4))        # margins of a plot: c(bottom, left, right , top)
par(oma = c(1,1,1,1))        # outer margins of a plot
axis(3)                      # side where axis will be displayed
text(x, y, "text", pos = 3)  # pos selects the side the "text" is displayed at
mtext("text", side = 4)      # side specifies the margin "text" will appear in


# Another important point is vectorization. Almost all the arguments for base plotting functions are vectorized. For example, when plotting rectangles the user does not have to add each point of each rectangle one by one within a loop. Instead he or she can draw all the related objects with one function call while at the same time specifying different positions and parameters for each.

plot.new()
plot.window(xlim = c(0,3), ylim = c(0,3))

rect(
  xleft = c(0, 1, 2),
  ybottom = c(0, 1, 2),
  xright = c(1, 2, 3),
  ytop = c(1, 2, 3),
  border = c("pink", "red", "darkred"),
  lwd = 10
)

# Here is another example producing a check board pattern.
plot.new()
plot.window(xlim = c(0,10), ylim = c(0,10))
xs <- rep(1:9, each = 9)
ys <- rep(1:9)
?rect
rect(xs-0.5, ys-0.5, xs+0.5, ys+0.5, col = c("white","darkgrey"))


# Constructing a plot =========================================================

# One of base R graphics strengths is it’s flexibility and potential for customization. It really shines when the user needs to follow a particular style found in an existing example or a template(4). Below are a few illustrations demonstrating how different base functions can work together and reconstruct various types of common figures from scratch.

# Annotated barplot of USA population growth over time.

x <- time(uspop)
y <- uspop

plot.new()
plot.window(xlim = range(x), ylim = range(pretty(y)))

rect(x-4, 0, x+4, y)
text(x, y, y, pos = 3, col = "red3", cex = 0.7)

mtext(x, 1, at = x, las = 2, cex = 0.7, font = 2)
axis(2, lwd = 0, las = 2, cex.axis = 0.7, font.axis = 2)
title("US population growth", adj = 0, col.main = "red2")

# In this case for each rectangle four sets of points had to be specified: x and y for the left bottom corner plus x and y for the top right corner. In the end, even so this is a more complicated example, we still added all the different pieces of information using single function calls to rect(), text(), and mtext().

# Parallel coordinates plot using the “iris” dataset.

palette(c("cornflowerblue", "red3", "orange"))

plot.new()
plot.window(xlim = c(1,4), ylim = range(iris[,-5]))
grid(nx = NA, ny = NULL)
abline(v = 1:4, col = "grey", lwd = 5, lty = "dotted")

matlines(t(iris[,-5]), col = iris$Species, lty = 1)

axis(2, lwd = 0, las = 2)
mtext(variable.names(iris)[-5], 3, at = 1:4, line = 1, col = "darkgrey")

legend(x = 1, y = 2, legend = unique(iris$Species), col = unique(iris$Species),
       lwd = 3, bty = 'n')

# In this example we used a special function matlines() that draws one line for each column in a matrix. We also did a few other things that were novel so far: changed the default numeric colors via palette(), and used factor levels for specifying the actual colors within matlines() and legend(). Changing palette allows us to customize the color scheme while passing factors for the color arguments guarantees that the same colors are consistently assigned to the same factor levels across all the different functions.

# Dot plot of death rates in Virginia in 1940.

colors <- hcl.colors(5, palette = "Zissou")
ys     <- c(1.25, 2, 1.5, 2.25)

plot.new()
plot.window(xlim = range(0,VADeaths), ylim = c(1,2.75))

abline(h = ys, col = "grey", lty = "dotted", lwd = 3)
points(VADeaths, ys[col(VADeaths)], col = colors, pch = 19, cex = 2.5)
text(0, ys, colnames(VADeaths), adj = c(0.25,-1), col = "lightslategrey")

axis(1, lwd = 0, font = 2)
title("deaths per 1000 in 1940 Virginia stratified by age, gender, and location")

legend("top", legend = rownames(VADeaths), col = colors, pch = 19, horiz = TRUE,
       bty = "n", title = "age bins")

# In this graph the groups were stratified by gender, age, and location For each group the y-axis hights were chosen manually and col() function was used to repeat those heights for all numbers within the matrix.


# Dual coordinate plot using the “mtcars” dataset. ============================

par(mar = c(4,4,4,4))
plot.new()

plot.window(xlim = range(mtcars$disp), ylim = range(pretty(mtcars$mpg)))

points(mtcars$disp, mtcars$mpg, col = "darkorange2", pch = 19, cex = 1.5)
axis(2, col.axis = "darkorange2", lwd = 2, las = 2)
mtext("miles per gallon", 2, col = "darkorange2", font = 2, line = 3)

plot.window(xlim = range(mtcars$disp), ylim = range(pretty(mtcars$hp)))

points(mtcars$disp, mtcars$hp, col = "forestgreen", pch = 19, cex = 1.5)
axis(4, col.axis = "forestgreen", lwd = 2, las = 2)
mtext("horse power", 4, col = "forestgreen", font = 2, line = 3)

box()
axis(1)
mtext("displacement", 1, font = 2, line = 3)
title("displacement VS mpg VS hp", adj = 0, cex.main = 1)


# Here we visualized two scatter plots, with different y-axes, on a single figure. The trick here is to change the coordinate system in the middle of the plot using plot.window(). But note that plots with double y-axes are frowned upon so do not take this example as a suggestion.

# Ridgeline Density Plot showing chicken weight distributions stratified by feed type. ==========

dens <- tapply(chickwts$weight, chickwts$feed, density)

xs <- Map(getElement, dens, "x")
ys <- Map(getElement, dens, "y")
ys <- Map(function(x) (x - min(x)) / max(x - min(x)) * 1.5, ys)
ys <- Map(`+`, ys, length(ys):1)

plot.new()
plot.window(xlim = range(xs), ylim = c(1,length(ys) + 1.5))
abline(h = length(ys):1, col = "grey")

Map(polygon, xs, ys, col = hcl.colors(length(ys), "Zissou", alpha = 0.8))

axis(1, tck = -0.01)
mtext(names(dens), 2, at = length(ys):1, las = 2, padj = 0)
title("Chicken weights", adj = 0, cex = 0.8)

# In this example majority of the work is done preparing the densities by transforming y values to a range of 0 - 1.5 and then adding a different offset for each feed type. To make the drawn densities overlap nicely we plot them starting from the topmost and going down. After that Map() and polygon() do all the work.


# Violin Plot of chicken weights versus feed type =============================

dens <- tapply(chickwts$weight, chickwts$feed, density)
cols <- hcl.colors(length(dens), "Zissou")

xs <- Map(getElement, dens, "y")
ys <- Map(getElement, dens, "x")

xs <- Map(c, xs, Map(rev, Map(`*`, -1, xs)))
ys <- Map(c, ys, Map(rev, ys))

xs <- Map(function(x) (x - min(x)) / max(x - min(x) * 1.1), xs)
xs <- Map(`+`, xs, 1:length(xs))

plot.new()
plot.window(xlim = range(xs), ylim = range(ys))
grid(nx = NA, ny = NULL, lwd = 2)

Map(polygon, xs, ys, col = cols)

axis(2, las = 1, lwd = 0)
title("Chicken weight by feed type", font = 2)

legend("top", legend = names(dens), fill = cols, ncol = 3, inset = c(0, 1),
       xpd = TRUE, bty = "n")


# Now the polygons are double sided, and so we need to mirror and duplicate the xs and ys. In the code above 5th and 6th lines do this job. After that the plotting is almost identical to the previous example. There is one additional trick used on the legend where we use “inset” to push it over to the other side.

# Correlation matrix plot using variables from the “mtcars” dataset. ==========

cors <- cor(mtcars)
cors
cols <- hcl.colors(200, "RdBu")[round((cors + 1)*100)]
cols
par(mar = c(5,5,0,0))
plot.new()
plot.window(xlim = c(0,ncol(cors)), ylim = c(0,ncol(cors)))

rect(row(cors) - 1, col(cors) - 1, row(cors), col(cors))
symbols(row(cors) - 0.5, col(cors) - 0.5, circles = as.numeric(abs(cors))/2,
        inches = FALSE, asp = 1, add = TRUE, bg = cols
)

mtext(rownames(cors), 1, at = 1:ncol(cors) - 0.5, las = 2)
mtext(colnames(cors), 2, at = 1:nrow(cors) - 0.5, las = 2)

# Here second line assigns colors for each correlation value by transforming correlation from a range of -1:1 to 0:200. Then we used rect() function to get the grid and symbols() for adding circles with specified radii. The resulting figure is similar to the one implemented by corrplot library(6).

# Summary

# R base plotting system has several polished and easy to use wrappers that are sometimes convenient but in the long run only confuse and hide things. As a result most R users are never properly introduced to the real functions behind the base plotting paradigm and are left confused by many of its perceived idiosyncrasies. However, if inspected properly, base plotting can become powerful, flexible, and intuitive. Under the hood of all wrappers the heavy lifting is done by a small set of simple functions that work in tandem with one another. Often a few lines of code is all it takes to produce an elegant and customized figure.

# par =========================================================================
# op <- par(mfrow = c(1, 1), # 2 x 2 pictures on one plot
#           pty = "s")       # square plotting region,
# independent of device size
## At end of plotting, reset to previous settings:
# par(op)

## Alternatively,
op <- par(no.readonly = TRUE) # the whole list of settable par's.
## do lots of plotting and par(.) calls, then reset:
par(op)
## Note this is not in general good practice

# hcl.colors ==================================================================
# Create a vector of n contiguous colors.
require("graphics")

# color wheels in RGB/HSV and HCL space
par(mfrow = c(2, 2))
pie(rep(1, 12), col = rainbow(12), main = "RGB/HSV")
pie(rep(1, 12), col = hcl.colors(12, "Set 2"), main = "HCL")
par(mfrow = c(1, 1))

## color swatches for RGB/HSV palettes
demo.pal <-
  function(n, border = if (n < 32) "light gray" else NA,
           main = paste("color palettes;  n=", n),
           ch.col = c("rainbow(n, start=.7, end=.1)", "heat.colors(n)",
                      "terrain.colors(n)", "topo.colors(n)",
                      "cm.colors(n)")) {
    nt <- length(ch.col)
    i <- 1:n; j <- n / nt; d <- j/6; dy <- 2*d
    plot(i, i+d, type = "n", yaxt = "n", ylab = "", main = main)
    for (k in 1:nt) {
      rect(i-.5, (k-1)*j+ dy, i+.4, k*j,
           col = eval(str2lang(ch.col[k])), border = border)
      text(2*j,  k * j + dy/4, ch.col[k])
    }
  }

demo.pal(16)

## color swatches for HCL palettes
hcl.swatch <- function(type = NULL, n = 5, nrow = 11,
                       border = if (n < 15) "black" else NA) {
  palette <- hcl.pals(type)
  cols <- sapply(palette, hcl.colors, n = n)
  ncol <- ncol(cols)
  nswatch <- min(ncol, nrow)

  par(mar = rep(0.1, 4),
      mfrow = c(1, min(5, ceiling(ncol/nrow))),
      pin = c(1, 0.5 * nswatch),
      cex = 0.7)

  while (length(palette)) {
    subset <- 1:min(nrow, ncol(cols))
    plot.new()
    plot.window(c(0, n), c(0, nrow + 1))
    text(0, rev(subset) + 0.1, palette[subset], adj = c(0, 0))
    y <- rep(subset, each = n)
    rect(rep(0:(n-1), n), rev(y), rep(1:n, n), rev(y) - 0.5,
         col = cols[, subset], border = border)
    palette <- palette[-subset]
    cols <- cols[, -subset, drop = FALSE]
  }

  par(mfrow = c(1, 1), mar = c(5.1, 4.1, 4.1, 2.1), cex = 1)
}
hcl.swatch()
hcl.swatch("qualitative")
hcl.swatch("sequential")
hcl.swatch("diverging")
hcl.swatch("divergingx")

## heat maps with sequential HCL palette (purple)
image(volcano, col = hcl.colors(11, "purples", rev = TRUE))

filled.contour(volcano, nlevels = 10,
               color.palette = function(n, ...)
                 hcl.colors(n, "purples", rev = TRUE, ...))

## list available HCL color palettes
hcl.pals("qualitative")
hcl.pals("sequential")
hcl.pals("diverging")
hcl.pals("divergingx")
hcl.pals()

# rect() ======================================================================
# Description
# rect draws a rectangle (or sequence of rectangles) with the given coordinates, fill and border colors.

# Usage
# rect(xleft, ybottom, xright, ytop, density = NULL, angle = 45,
#      col = NA, border = NULL, lty = par("lty"), lwd = par("lwd"),
#      ...)

require(grDevices)
## set up the plot region:
op <- par(bg = "thistle")
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "",
     main = "2 x 11 rectangles; 'rect(100+i,300+i,  150+i,380+i)'")
i <- 4*(0:10)
## draw rectangles with bottom left (100, 300)+i
## and top right (150, 380)+i
rect(100+i, 300+i, 150+i, 380+i, col = rainbow(11, start = 0.7, end = 0.1))
rect(240-i, 320+i, 250-i, 410+i, col = heat.colors(11), lwd = i/5)

## Background alternating  ( transparent / "bg" ) :
j <- 10*(0:5)

rect(125+j, 360+j,   141+j, 405+j/2, col = c(NA,0),
     border = "gold", lwd = 2)

rect(125+j, 296+j/2, 141+j, 331+j/5, col = c(NA,"midnightblue"))

mtext("+  2 x 6 rect(*, col = c(NA,0)) and  col = c(NA,\"m..blue\")")

## an example showing colouring and shading
plot(c(100, 200), c(300, 450), type= "n", xlab = "", ylab = "")
rect(100, 300, 125, 350) # transparent
rect(100, 400, 125, 450, col = "green", border = "blue") # coloured
rect(115, 375, 150, 425, col = par("bg"), border = "transparent")
rect(150, 300, 175, 350, density = 10, border = "red")
rect(150, 400, 175, 450, density = 30, col = "blue",
     angle = -30, border = "transparent")

legend(180, 450, legend = 1:4, fill = c(NA, "green", par("fg"), "blue"),
       density = c(NA, NA, 10, 30), angle = c(NA, NA, 30, -30))

par(op)

# plot() ======================================================================
# Generic function for plotting of R objects.
?base::plot

require(stats) # for lowess, rpois, rnorm
require(graphics) # for plot methods
head(cars)
plot(cars)
lines(lowess(cars))

plot(sin, -pi, 2*pi) # see ?plot.function

## Discrete Distribution Plot:
plot(table(rpois(100, 5)), type = "h", col = "red", lwd = 10,
     main = "rpois(100, lambda = 5)")

## Simple quantiles/ECDF, see ecdf() {library(stats)} for a better one:
plot(x <- sort(rnorm(47)), type = "s", main = "plot(x, type = \"s\")")

points(x, cex = .5, col = "dark red")

# points() ====================================================================
require(stats) # for rnorm
plot(-4:4, -4:4, type = "n")  # setting up coord. system
points(rnorm(200), rnorm(200), col = "red")
points(rnorm(100)/2, rnorm(100)/2, col = "blue", cex = 1.5)

op <- par(bg = "light blue")
x <- seq(0, 2*pi, length.out = 51)
## something "between type='b' and type='o'":
plot(x, sin(x), type = "o", pch = 21, bg = par("bg"), col = "blue", cex = .6,
     main = 'plot(..., type="o", pch=21, bg=par("bg"))')
par(op)

## Not run:
## The figure was produced by calls like
png("pch.png", height = 0.7, width = 7, res = 100, units = "in")
par(mar = rep(0,4))
plot(c(-1, 26), 0:1, type = "n", axes = FALSE)
text(0:25, 0.6, 0:25, cex = 0.5)
points(0:25, rep(0.3, 26), pch = 0:25, bg = "grey")

## End(Not run)

##-------- Showing all the extra & some char graphics symbols ---------
pchShow <-
  function(extras = c("*",".", "o","O","0","+","-","|","%","#"),
           cex = 3, ## good for both .Device=="postscript" and "x11"
           col = "red3", bg = "gold", coltext = "brown", cextext = 1.2,
           main = paste("plot symbols :  points (...  pch = *, cex =",
                        cex,")")) {
    nex <- length(extras)
    np  <- 26 + nex
    ipch <- 0:(np-1)
    k <- floor(sqrt(np))
    dd <- c(-1,1)/2
    rx <- dd + range(ix <- ipch %/% k)
    ry <- dd + range(iy <- 3 + (k-1)- ipch %% k)
    pch <- as.list(ipch) # list with integers & strings
    if(nex > 0) pch[26+ 1:nex] <- as.list(extras)
    plot(rx, ry, type = "n", axes  =  FALSE, xlab = "", ylab = "", main = main)
    abline(v = ix, h = iy, col = "lightgray", lty = "dotted")
    for(i in 1:np) {
      pc <- pch[[i]]
      ## 'col' symbols with a 'bg'-colored interior (where available) :
      points(ix[i], iy[i], pch = pc, col = col, bg = bg, cex = cex)
      if(cextext > 0)
        text(ix[i] - 0.3, iy[i], pc, col = coltext, cex = cextext)
    }
  }

pchShow()
pchShow(c("o","O","0"), cex = 2.5)
pchShow(NULL, cex = 4, cextext = 0, main = NULL)


## ------------ test code for various pch specifications -------------
# Try this in various font families (including Hershey)
# and locales.  Use sign = -1 asserts we want Latin-1.
# Standard cases in a MBCS locale will not plot the top half.
TestChars <- function(sign = 1, font = 1, ...) {
  MB <- l10n_info()$MBCS
  r <- if(font == 5) { sign <- 1; c(32:126, 160:254)
  } else if(MB) 32:126 else 32:255
  if (sign == -1) r <- c(32:126, 160:255)
  par(pty = "s")
  plot(c(-1,16), c(-1,16), type = "n", xlab = "", ylab = "",
       xaxs = "i", yaxs = "i",
       main = sprintf("sign = %d, font = %d", sign, font))
  grid(17, 17, lty = 1) ; mtext(paste("MBCS:", MB))
  for(i in r) try(points(i%%16, i%/%16, pch = sign*i, font = font,...))
}
TestChars()
try(TestChars(sign = -1))
TestChars(font = 5)  # Euro might be at 160 (0+10*16).
# macOS has apple at 240 (0+15*16).
try(TestChars(-1, font = 2))  # bold


# lines() =====================================================================
plot(cars, main = "Stopping Distance versus Speed")
lines(stats::lowess(cars))
# lowess() ====================================================================
# This function performs the computations for the LOWESS smoother which uses locally-weighted polynomial regression.

# lowess(x, y = NULL, f = 2/3, iter = 3, delta = 0.01 * diff(range(x)))

require(graphics)

plot(cars, main = "lowess(cars)")
lines(lowess(cars), col = 2)
lines(lowess(cars, f = .2), col = 3)
legend(5, 120, c(paste("f = ", c("2/3", ".2"))), lty = 1, col = 2:3)


# mosaicplot ==================================================================
require(stats)
?Titanic
head(Titanic)
mosaicplot(Titanic, main = "Survival on the Titanic", color = TRUE)
## Formula interface for tabulated data:
mosaicplot(~ Sex + Age + Survived, data = Titanic, color = TRUE)

mosaicplot(HairEyeColor, shade = TRUE)
## Independence model of hair and eye color and sex.  Indicates that
## there are more blue eyed blonde females than expected in the case
## of independence and too few brown eyed blonde females.
## The corresponding model is:
fm <- loglin(HairEyeColor, list(1, 2, 3))
pchisq(fm$pearson, fm$df, lower.tail = FALSE)

mosaicplot(HairEyeColor, shade = TRUE, margin = list(1:2, 3))
## Model of joint independence of sex from hair and eye color.  Males
## are underrepresented among people with brown hair and eyes, and are
## overrepresented among people with brown hair and blue eyes.
## The corresponding model is:
fm <- loglin(HairEyeColor, list(1:2, 3))
pchisq(fm$pearson, fm$df, lower.tail = FALSE)

## Formula interface for raw data: visualize cross-tabulation of numbers
## of gears and carburettors in Motor Trend car data.
mosaicplot(~ gear + carb, data = mtcars, color = TRUE, las = 1)
# color recycling
mosaicplot(~ gear + carb, data = mtcars, color = 2:3, las = 1)

# text ========================================================================

plot(-1:1,
     -1:1,
     type = "n",
     xlab = "Re",
     ylab = "Im")
K <- 16
text(exp(1i * 2 * pi * (1:K) / K), col = 2)

## The following two examples use latin1 characters: these may not
## appear correctly (or be omitted entirely).
plot(1:10, 1:10, main = "text(...) examples\n~~~~~~~~~~~~~~", sub = "R is GNU ©, but not ® ...")
mtext("«Latin-1 accented chars»: éè øØ å<Å æ<Æ", side = 3)
points(c(6, 2),
       c(2, 1),
       pch = 3,
       cex = 4,
       col = "red")
text(6, 2, "the text is CENTERED around (x,y) = (6,2) by default", cex = .8)
text(2,
     1,
     "or Left/Bottom - JUSTIFIED at (2,1) by 'adj = c(0,0)'",
     adj = c(0, 0))
text(4, 9, expression(hat(beta) == (X ^ t * X) ^ {
  -1
} * X ^ t * y))
text(4, 8.4, "expression(hat(beta) == (X^t * X)^{-1} * X^t * y)", cex = .75)
text(4, 7, expression(bar(x) == sum(frac(x[i], n), i == 1, n)))

## Two more latin1 examples
text(5,
     10.2,
     "Le français, c'est façile: Règles, Liberté, Egalité, Fraternité...")
text(5,
     9.8,
     "Jetz no chli züritüütsch: (noch ein bißchen Zürcher deutsch)")

# table =============
# contingency tables

# table(...,
#       exclude = if (useNA == "no") c(NA, NaN),
#       useNA = c("no", "ifany", "always"),
#       dnn = list.names(...), deparse.level = 1)


require(stats) # for rpois and xtabs
## Simple frequency distribution
table(rpois(100, 5))
## Check the design:
head(warpbreaks)
summary(warpbreaks)
with(warpbreaks, table(wool, tension))

state.division
table(state.division, state.region)

# simple two-way contingency table
with(airquality, table(cut(Temp, quantile(Temp)), Month))

a <- letters[1:3]
table(a, sample(a))                    # dnn is c("a", "")
table(a, sample(a), deparse.level = 0) # dnn is c("", "")
table(a, sample(a), deparse.level = 2) # dnn is c("a", "sample(a)")

## xtabs() <-> as.data.frame.table() :
UCBAdmissions ## already a contingency table
DF <- as.data.frame(UCBAdmissions)
class(tab <- xtabs(Freq ~ ., DF)) # xtabs & table
## tab *is* "the same" as the original table:
all(tab == UCBAdmissions)
all.equal(dimnames(tab), dimnames(UCBAdmissions))

a <- rep(c(NA, 1 / 0:3), 10)
table(a)                 # does not report NA's
table(a, exclude = NULL) # reports NA's
b <- factor(rep(c("A", "B", "C"), 10))
table(b)
table(b, exclude = "B")
d <- factor(rep(c("A", "B", "C"), 10), levels = c("A", "B", "C", "D", "E"))
table(d, exclude = "B")
print(table(b, d), zero.print = ".")

## NA counting:
is.na(d) <- 3:4
d. <- addNA(d)
d.[1:7]
table(d.) # ", exclude = NULL" is not needed
## i.e., if you want to count the NA's of 'd', use
table(d, useNA = "ifany")

## "pathological" case:
d.patho <- addNA(c(1, NA, 1:2, 1:3))[-7]
is.na(d.patho) <- 3:4
d.patho
## just 3 consecutive NA's ? --- well, have *two* kinds of NAs here :
as.integer(d.patho) # 1 4 NA NA 1 2
##
## In R >= 3.4.0, table() allows to differentiate:
table(d.patho)                   # counts the "unusual" NA
table(d.patho, useNA = "ifany")  # counts all three
table(d.patho, exclude = NULL)   #  (ditto)
table(d.patho, exclude = NA)     # counts none

## Two-way tables with NA counts. The 3rd variant is absurd, but shows
## something that cannot be done using exclude or useNA.
with(airquality, table(OzHi = Ozone > 80, Month, useNA = "ifany"))
with(airquality, table(OzHi = Ozone > 80, Month, useNA = "always"))
with(airquality, table(OzHi = Ozone > 80, addNA(Month)))
