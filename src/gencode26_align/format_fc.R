
setwd("../../")

fc = read.table("data/processed/gencode26_align/featureCounts/gencode26.featureCounts.txt", header=TRUE, skip=1, check.names=FALSE, stringsAsFactors=FALSE, sep="\t")

newnames = sapply(colnames(fc)[9:ncol(fc)], function(x) gsub("../../data/processed/gencode26_align/pass2/", "", x))
newnames = sapply(newnames, function(x) gsub("/.*bam", "",  x))

colnames(fc)[9:ncol(fc)] = newnames

write.table(fc, "data/processed/gencode26_align/featureCounts/gencode26.featureCounts.format.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)

