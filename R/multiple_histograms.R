# https://www.r-bloggers.com/2023/08/how-to-plot-multiple-histograms-with-base-r-and-ggplot2/

# hist(x,
#      main = "Histogram Title",
#      xlab = "X-axis Label",
#      ylab = "Frequency")

# Using Base R to Plot Multiple Histograms ====================================
## Example 1: Creating Side-by-Side Histograms ================================

# To plot multiple histograms side by side using base R, you can make use of the par(mfrow) function. This function allows you to specify the number of rows and columns for your layout. Here’s an example:

# Create two example datasets
data1 <- rnorm(100, mean = 0, sd = 1)
data2 <- rnorm(100, mean = 2, sd = 1)

# Set up a side-by-side layout
par(mfrow = c(1, 2))

# Create the first histogram
hist(data1,
     main = "Histogram 1",
     xlab = "Value",
     ylab = "Frequency")

# Create the second histogram
hist(data2,
     main = "Histogram 2",
     xlab = "Value",
     ylab = "Frequency")


## Example 2: Creating Histograms on the same graph ===========================
par(mfrow = c(1, 1))
# Create two example datasets
data1 <- rnorm(100, mean = 0, sd = 1)
data2 <- rnorm(100, mean = 2, sd = 1)

xmin <- min(data1, data2)
xmax <- max(data1, data2)*1.2

# Create the first histogram
hist(
  data1,
  main = "Histogram 1",
  xlab = "Value",
  ylab = "Frequency",
  # col = "powderblue",
  col=rgb(1,0,0,0.5),
  xlim = c(xmin, xmax)
)

# Create the second histogram
hist(
  data2,
  main = "Histogram 2",
  xlab = "Value",
  ylab = "Frequency",
  # col = "pink",
  col=rgb(0,0,1,0.5),
  add = TRUE,
  xlim = c(xmin, xmax)
)

## example from Stack Overflow ================================================

set.seed(42)
p1 <- hist(rnorm(500,4))                     # centered at 4
p2 <- hist(rnorm(500,6))                     # centered at 6
plot( p1, col=rgb(0,0,1,1/4), xlim=c(0,10))  # first histogram
plot( p2, col=rgb(1,0,0,1/4), xlim=c(0,10), add=T)  # second



### my modified version ==========
set.seed(42)
# data centered at 4
data1 <- rnorm(500, 4)
# data centered at 6
data2 <- rnorm(500, 6)
# first histogram
hist(data1, col = rgb(0, 0, 1, 1 / 4), xlim = c(0, 10))
# second histogram
hist(data2,
     col = rgb(1, 0, 0, 1 / 4),
     xlim = c(0, 10),
     add = TRUE)

# Syntax for Creating a Histogram in ggplot2 ==================================

library(ggplot2)

# ggplot(data, aes(x = variable)) +
#   geom_histogram(binwidth = width, fill = "color") +
#   labs(title = "Histogram Title", x = "X-axis Label", y = "Frequency")

## Example 1: Creating Multiple Histograms ====================================

library(ggplot2)

# Create an example dataset
data <- data.frame(
  group = rep(c("Group A", "Group B"), each = 100),
  value = c(rnorm(100, mean = 0, sd = 1), rnorm(100, mean = 2, sd = 1))
)

head(data)
summary(data)
table(data$group)

# Create multiple histograms using facets
ggplot(data, aes(x = value)) +
  geom_histogram(binwidth = 0.5, fill = "steelblue") +
  labs(title = "Multiple Histograms", x = "Value", y = "Frequency") +
  facet_wrap(~ group, nrow = 1) +
  theme_minimal()


## stack overflow =============================================================

carrots <- data.frame(length = rnorm(100000, 6, 2))
cukes <- data.frame(length = rnorm(50000, 7, 2.5))

# Now, combine your two dataframes into one.
# First make a new column in each that will be
# a variable to identify where they came from later.
carrots$veg <- 'carrot'
cukes$veg <- 'cuke'

# and combine into your new data frame vegLengths
vegLengths <- rbind(carrots, cukes)
### geom_density ==============================================================
ggplot(vegLengths, aes(length, fill = veg)) + geom_density(alpha = 0.2)

### geom_histogram ============================================================
ggplot(vegLengths, aes(length, fill = veg)) +
  geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity')
