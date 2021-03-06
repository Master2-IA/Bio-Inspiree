
######################################################
# Chargement des donn�es
######################################################
data100Tr10Clts <- read.table("100_tr_10_clts.csv", h=T, sep=";")
data100Tr10Clts <- data100Tr10Clts[order(data100Tr10Clts$Brownian, data100Tr10Clts$L�vis),]
attach(data100Tr10Clts)

data1Tr <- read.table("1_tr.csv", h=T, sep=";")
data1Tr <- data1Tr[order(data1Tr$Brownian, data1Tr$L�vis),]
attach(data1Tr)

data100TrRnd <- read.table("100_tr_rnd.csv", h=T, sep=";")
data100TrRnd <- data100TrRnd[order(data100TrRnd$Brownian, data100TrRnd$L�vis),]
attach(data100TrRnd)

data1000Tr10Clts <- read.table("1000_tr_10_clts.csv", h=T, sep=";")
data1000Tr10Clts <- data1000Tr10Clts[order(data1000Tr10Clts$Brownian, data1000Tr10Clts$L�vis),]
attach(data1000Tr10Clts)

data1000TrRnd <- read.table("1000_tr_rnd.csv", h=T, sep=";")
data1000TrRnd <- data1000TrRnd[order(data1000TrRnd$Brownian, data1000TrRnd$L�vis),]
attach(data1000TrRnd)



######################################################
# Affichage pour chaque r�partition
######################################################
# S�lection de la r�partition
dataToDisplay <- data1000Tr10Clts
dataToDisplay <- data1000TrRnd
dataToDisplay <- data100Tr10Clts
dataToDisplay <- data100TrRnd
dataToDisplay <- data1Tr

# Affichage
plot(x=dataToDisplay$Brownian, col=0, ylab="Ticks by trash")
points(dataToDisplay$Brownian, col=4)
points(dataToDisplay$Equiprobable, col=1)
points(dataToDisplay$Custom, col=2)
points(dataToDisplay$L�vis, col=3)
abline(h=mean(dataToDisplay$Brownian), col=4)
abline(h=mean(dataToDisplay$Equiprobable), col=1)
abline(h=mean(dataToDisplay$Custom), col=2)
abline(h=mean(dataToDisplay$L�vis), col=3)

# Boxplot
boxplot(x=data100Tr10Clts, names=c("Brownian", "Equipro.", "Custom", "L�vy"), ylab="Ticks by trash")
title("100 runs - 100 trashes - 10 clusters - std dev. of 3")

boxplot(x=data100TrRnd, names=c("Brownian", "Equipro.", "Custom", "L�vy"), ylab="Ticks by trash")
title("100 runs - 100 trashes - uniform distribution")

boxplot(x=data1Tr, names=c("Brownian", "Equipro.", "Custom", "L�vy"), ylab="Ticks by trash")
title("100 runs - 1 trash")

######################################################
# Compare quelle strat�gie est la meilleure en fonction
# de la r�partition des d�chets.
######################################################
mean(dataToDisplay$Brownian)
mean(dataToDisplay$Equiprobable)
mean(dataToDisplay$Custom)
mean(dataToDisplay$L�vis)

median(dataToDisplay$Brownian)
median(dataToDisplay$Equiprobable)
median(dataToDisplay$Custom)
median(dataToDisplay$L�vis)


dataToDisplay <- data100Tr10Clts
t.test(dataToDisplay$Brownian)
t.test(dataToDisplay$Equiprobable)
t.test(dataToDisplay$Custom)
t.test(dataToDisplay$L�vis)
sd(dataToDisplay$Brownian)
sd(dataToDisplay$Equiprobable)
sd(dataToDisplay$Custom)
sd(dataToDisplay$L�vis)
min(dataToDisplay$Brownian)
min(dataToDisplay$Equiprobable)
min(dataToDisplay$Custom)
min(dataToDisplay$L�vis)
max(dataToDisplay$Brownian)
max(dataToDisplay$Equiprobable)
max(dataToDisplay$Custom)
max(dataToDisplay$L�vis)

paste("min &", round(min(dataToDisplay$Brownian)), "&",
      round(min(dataToDisplay$Equiprobable)), "&",
      round(min(dataToDisplay$Custom)), "&",
      round(min(dataToDisplay$L�vis)), "\\")

paste("max &", round(max(dataToDisplay$Brownian)), "&",
      round(max(dataToDisplay$Equiprobable)), "&",
      round(max(dataToDisplay$Custom)), "&",
      round(max(dataToDisplay$L�vis)), "\\")

dataToDisplay <- data100TrRnd
t.test(dataToDisplay$Brownian)
t.test(dataToDisplay$Equiprobable)
t.test(dataToDisplay$Custom)
t.test(dataToDisplay$L�vis)
sd(dataToDisplay$Brownian)
sd(dataToDisplay$Equiprobable)
sd(dataToDisplay$Custom)
sd(dataToDisplay$L�vis)
min(dataToDisplay$Brownian)
min(dataToDisplay$Equiprobable)
min(dataToDisplay$Custom)
min(dataToDisplay$L�vis)
max(dataToDisplay$Brownian)
max(dataToDisplay$Equiprobable)
max(dataToDisplay$Custom)
max(dataToDisplay$L�vis)

paste("min &", round(min(dataToDisplay$Brownian)), "&",
      round(min(dataToDisplay$Equiprobable)), "&",
      round(min(dataToDisplay$Custom)), "&",
      round(min(dataToDisplay$L�vis)), "\\")

paste("max &", round(max(dataToDisplay$Brownian)), "&",
      round(max(dataToDisplay$Equiprobable)), "&",
      round(max(dataToDisplay$Custom)), "&",
      round(max(dataToDisplay$L�vis)), "\\")

dataToDisplay <- data1Tr
t.test(dataToDisplay$Brownian)
t.test(dataToDisplay$Equiprobable)
t.test(dataToDisplay$Custom)
t.test(dataToDisplay$L�vis)
sd(dataToDisplay$Brownian)
sd(dataToDisplay$Equiprobable)
sd(dataToDisplay$Custom)
sd(dataToDisplay$L�vis)

paste(round(min(dataToDisplay$Brownian)), "&",
      round(min(dataToDisplay$Equiprobable)), "&",
      round(min(dataToDisplay$Custom)), "&",
      round(min(dataToDisplay$L�vis)), "\\")

paste(round(max(dataToDisplay$Brownian)), "&",
      round(max(dataToDisplay$Equiprobable)), "&",
      round(max(dataToDisplay$Custom)), "&",
      round(max(dataToDisplay$L�vis)), "\\")

min(dataToDisplay$Equiprobable)
min(dataToDisplay$Custom)
min(dataToDisplay$L�vis)
max(dataToDisplay$Brownian)
max(dataToDisplay$Equiprobable)
max(dataToDisplay$Custom)
max(dataToDisplay$L�vis)

######################################################
# Affichage pour chaque strat�gie
######################################################
plot(x=data100Tr10Clts$Brownian, col=4, ylab="Ticks by trash")
points(data100TrRnd$Brownian, col=1)
points(data1Tr$Brownian, col=2)
abline(h=mean(data100Tr10Clts$Brownian), col=4)
abline(h=mean(data100TrRnd$Brownian), col=1)
abline(h=mean(data1Tr$Brownian), col=2)

plot(x=data100Tr10Clts$Equiprobable, col=4, ylab="Ticks by trash")
points(data100TrRnd$Equiprobable, col=1)
points(data1Tr$Equiprobable, col=2)
abline(h=mean(data100Tr10Clts$Equiprobable), col=4)
abline(h=mean(data100TrRnd$Equiprobable), col=1)
abline(h=mean(data1Tr$Equiprobable), col=2)

plot(x=data100Tr10Clts$Custom, col=4, ylab="Ticks by trash")
points(data100TrRnd$Custom, col=1)
points(data1Tr$Custom, col=2)
abline(h=mean(data100Tr10Clts$Custom), col=4)
abline(h=mean(data100TrRnd$Custom), col=1)
abline(h=mean(data1Tr$Custom), col=2)

plot(x=data100Tr10Clts$L�vis, col=4, ylab="Ticks by trash")
points(data100TrRnd$L�vis, col=1)
points(data1Tr$L�vis, col=2)
abline(h=mean(data100Tr10Clts$L�vis), col=4)
abline(h=mean(data100TrRnd$L�vis), col=1)
abline(h=mean(data1Tr$L�vis), col=2)

######################################################
# Compare pour chaque strat�gie quelle r�partition
# est la plus adapt�e.
#
# /!\ A ne pas confondre avec : quelle strat�gie est
#     la meilleure pour une r�partition donn�e.
# /!\ 1 trash et 100 trashes ne sont pas comparables.
######################################################
mean(data100Tr10Clts$Brownian) # best, mais est-ce � cause de la chance?
mean(data100TrRnd$Brownian)
mean(data1Tr$Brownian)

mean(data100Tr10Clts$Equiprobable)
mean(data100TrRnd$Equiprobable)
mean(data1Tr$Equiprobable)

mean(data100Tr10Clts$Custom)
mean(data100TrRnd$Custom)
mean(data1Tr$Custom)

mean(data100Tr10Clts$L�vis)
mean(data100TrRnd$L�vis)
mean(data1Tr$L�vis)
