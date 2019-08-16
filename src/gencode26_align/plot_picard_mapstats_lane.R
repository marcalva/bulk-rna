
library(ggplot2)
library(reshape2)
library(gridExtra)
library(RColorBrewer)

setwd("../../")

picard = read.table("data/processed/gencode26_align/picard/all.picard.metrics", header=TRUE, check.names=FALSE, stringsAsFactors=FALSE, sep="\t", fill=TRUE)
mapstats = read.table("data/processed/gencode26_align/pass2/map_stats.txt", header=TRUE, check.names=FALSE, stringsAsFactors=FALSE)

rownames(picard) = paste(picard[,1], picard[,2], picard[,3], picard[,4], picard[,5], sep="_")
rownames(mapstats) = paste(picard[,1], picard[,2], picard[,3], picard[,4], picard[,5], sep="_")
mapstats = mapstats[rownames(picard),]

mapstats = mapstats[,-c(1:5)]

picard_mapstats = cbind(picard, mapstats)
picard_mapstats = picard_mapstats[order(picard_mapstats$flow_cell),]

# Features to plot
f2p = c("PCT_R2_TRANSCRIPT_STRAND_READS", "PCT_CODING_BASES", "PCT_UTR_BASES",
	"PCT_INTRONIC_BASES", "PCT_INTERGENIC_BASES", "PCT_MRNA_BASES", "MEDIAN_CV_COVERAGE",
	"MEDIAN_5PRIME_TO_3PRIME_BIAS", "MEDIAN_5PRIME_BIAS", "MEDIAN_3PRIME_BIAS",
	"num_input_reads", "uniq_map_perc", "mismatch_rate", "percent_multimap", "percent_chimeric")

picard_mapstats$flow_cell_lane = paste(picard_mapstats[,4], picard_mapstats[,5], sep="_")
# apply(picard_mapstats, 1, function(x) paste(x[4], x[5], sep="_"))
fcl = picard_mapstats$flow_cell_lane
fclu = unique(picard_mapstats$flow_cell_lane)
picard_mapstats$flow_cell = factor(picard_mapstats$flow_cell)
# There are 24 flow cell/lane pairs

myColors <- brewer.pal(length(levels(picard_mapstats$flow_cell)),"Set1")
names(myColors) = levels(picard_mapstats$flow_cell)

dir.create("data/processed/gencode26_align/", showWarnings = FALSE)
pdf("data/processed/gencode26_align/stats_per_lane.pdf", width=21)
for (f in f2p){
	df = melt(picard_mapstats[,c("flow_cell_lane", "flow_cell", f)])
	p1 = ggplot(df[fcl %in% fclu[1:12],], aes(x = flow_cell_lane, y = value, fill=flow_cell)) + geom_violin() + geom_jitter() + theme_bw() + ggtitle(f) + scale_fill_manual(values = myColors)
	p2 = ggplot(df[fcl %in% fclu[13:24],], aes(x = flow_cell_lane, y = value, fill=flow_cell)) + geom_violin() + geom_jitter() + theme_bw() + scale_fill_manual(values = myColors)
	grid.arrange(p1,p2, nrow=2)
}
dev.off()

