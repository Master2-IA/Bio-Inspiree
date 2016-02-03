
######################################################
# Chargement des données
######################################################
data100Tr10Clts <- read.table("100_tr_10_clts.csv", h=T, sep=";")
data100Tr10Clts <- data100Tr10Clts[order(data100Tr10Clts$Brownian, data100Tr10Clts$Lévis),]
attach(data100Tr10Clts)

data1Tr <- read.table("1_tr.csv", h=T, sep=";")
data1Tr <- data1Tr[order(data1Tr$Brownian, data1Tr$Lévis),]
attach(data1Tr)

data100TrRnd <- read.table("100_tr_rnd.csv", h=T, sep=";")
data100TrRnd <- data100TrRnd[order(data100TrRnd$Brownian, data100TrRnd$Lévis),]
attach(data100TrRnd)



######################################################
# Affichage pour chaque répartition
######################################################
# Sélection de la répartition
dataToDisplay <- data100Tr10Clts
dataToDisplay <- data100TrRnd
dataToDisplay <- data1Tr

# Affichage
plot(x=dataToDisplay$Brownian, col=0, ylab="Ticks by trash")
points(dataToDisplay$Brownian, col=4)
points(dataToDisplay$Equiprobable, col=1)
points(dataToDisplay$Custom, col=2)
points(dataToDisplay$Lévis, col=3)
abline(h=mean(dataToDisplay$Brownian), col=4)
abline(h=mean(dataToDisplay$Equiprobable), col=1)
abline(h=mean(dataToDisplay$Custom), col=2)
abline(h=mean(dataToDisplay$Lévis), col=3)

######################################################
# Compare quelle stratégie est la meilleure en fonction
# de la répartition des déchets.
######################################################
mean(dataToDisplay$Brownian)
mean(dataToDisplay$Equiprobable)
mean(dataToDisplay$Custom)
mean(dataToDisplay$Lévis)



######################################################
# Affichage pour chaque stratégie
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

plot(x=data100Tr10Clts$Lévis, col=4, ylab="Ticks by trash")
points(data100TrRnd$Lévis, col=1)
points(data1Tr$Lévis, col=2)
abline(h=mean(data100Tr10Clts$Lévis), col=4)
abline(h=mean(data100TrRnd$Lévis), col=1)
abline(h=mean(data1Tr$Lévis), col=2)

######################################################
# Compare pour chaque stratégie quelle répartition
# est la plus adaptée.
#
# /!\ A ne pas confondre avec : quelle stratégie est
#     la meilleure pour une répartition donnée.
# /!\ 1 trash et 100 trashes ne sont pas comparables.
######################################################
mean(data100Tr10Clts$Brownian) # best, mais est-ce à cause de la chance?
mean(data100TrRnd$Brownian)
mean(data1Tr$Brownian)

mean(data100Tr10Clts$Equiprobable)
mean(data100TrRnd$Equiprobable)
mean(data1Tr$Equiprobable)

mean(data100Tr10Clts$Custom)
mean(data100TrRnd$Custom)
mean(data1Tr$Custom)

mean(data100Tr10Clts$Lévis)
mean(data100TrRnd$Lévis)
mean(data1Tr$Lévis)
