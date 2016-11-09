#########################################################
#R script to plot 3D FES plots for multiple chains
#########################################################
wSize = 1200
hSize = 800
library(ggplot2)
library(gplots)
library(lattice)
library(akima)

system("mkdir r_plot")
# Load FES data for each of the 4 chains
chain1="fes.txt"

c1 = read.table(chain1)

pdf("r_plot/B-domain_FES.pdf")
a = filled.contour(interp(c1$V1, c1$V2, c1$V3),
	col=colorpanel(24,"dark blue", "beige", "dark red"),
	xlim=c(0,4), ylim=c(0,0.5), zlim=c(0,12),
	xlab=("B-domain distance (nm)"), ylab=("B-domain RMSD (nm)"),
    cex.axis=1.3, cex.lab=1.3)



dev.off()
