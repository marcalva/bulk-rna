
setwd("../../")

mapstats = read.table("data/processed/gencode26_align/pass2/map_stats.txt", header=TRUE, check.names=FALSE, stringsAsFactors=FALSE, sep="\t")

samples = unique(mapstats[,"sample"])

hdr_names = c("num_input_reads", "uniq_map_num", "uniq_map_perc", "mismatch_rate", "num_multimap", "percent_multimap", "num_chimeric", "percent_chimeric")

stats_per_sample = as.data.frame(matrix(nrow=length(samples), ncol=length(hdr_names)))
rownames(stats_per_sample) = samples
colnames(stats_per_sample) = hdr_names

for (s in samples){
	ms = mapstats[mapstats[,"sample"] == s,]
	sums = colSums(ms[,c("num_input_reads", "uniq_map_num", "num_multimap", "num_chimeric")])
	ms$percent_reads = apply(ms, 1, function(x) as.numeric(x[6]) / sums[1])
	mismatch_rate = t(ms[,"mismatch_rate"]) %*% ms[,"percent_reads"]
	stats_per_sample[as.character(s),] = c(sums[1], sums[2], sums[2]/sums[1], mismatch_rate, sums[3], sums[3]/sums[1], sums[4], sums[4]/sums[1])
}

stats_per_sample[,"uniq_map_perc"] = stats_per_sample[,"uniq_map_perc"] * 100
stats_per_sample[,"percent_multimap"] = stats_per_sample[,"percent_multimap"] * 100
stats_per_sample[,"percent_chimeric"] = stats_per_sample[,"percent_chimeric"] * 100

write.table(stats_per_sample, "data/processed/gencode26_align/pass2/map_stats.persample.txt", row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")



