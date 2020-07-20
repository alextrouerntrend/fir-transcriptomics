# Plant Computational Genommics lab @ UConn
# Author: Alex Trouern-Trend
# 2020-07-20

#### BACKGROUND
#####
# TRANSCRIPTOME STATISTICS
# Two methods of transcriptome construction by two clustering minimum identity.
# 
# Clustering methods
# 1. VSEARCH (single species) --> VSEARCH (multispecies)
#    xanadu path: `/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch`
# 2. VSEARCH (single species) --> Orthofinder (multispecies) --> VSEARCH (orthogroups)
#    xanadu path: `/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting'
#
# Clustering identities (VSEARCH (multispecies) and VSEARCH (orthogroups)), VSEARCH (single species) non-variable at 90%
# 1. 90%
#    xanadu path: $CLUST_PATH`/fir90`
# 2. 85%
#     xanadu path: $CLUST_PATH`/fir85`
#
# Input .tsv files generated from clustStats.py (https://github.com/alextrouerntrend/bioscripts/blob/master/utils/clustStats.py)
#     Data available at: 
#####

library(dplyr)
library(readr)
library(knitr)
library(stringr)

# load in the datasets from github (will take a moment)
link_v85 <- 'https://raw.github.com/alextrouerntrend/fir-transcriptomics/master/data/transcriptome_stats/v85.tsv'
link_v90 <- 'https://raw.github.com/alextrouerntrend/fir-transcriptomics/master/data/transcriptome_stats/v90.tsv'
link_o85 <- 'https://raw.github.com/alextrouerntrend/fir-transcriptomics/master/data/transcriptome_stats/o85.tsv'
link_o90 <- 'https://raw.github.com/alextrouerntrend/fir-transcriptomics/master/data/transcriptome_stats/o90.tsv'

v85 <- read.csv(link_v85, sep = "\t", stringsAsFactors = FALSE)
v90 <- read.csv(link_v90, sep = "\t", stringsAsFactors = FALSE)
o85 <- read.csv(link_o85, sep = "\t", stringsAsFactors = FALSE)
o90 <- read.csv(link_o90, sep = "\t", stringsAsFactors = FALSE)

# trim path from clustID
pathtrim85 <- substring(v85$ClustID, first = 7)
pathtrim90 <- substring(v90$ClustID, first = 7)
v85$ClustID <- pathtrim85
v90$ClustID <- pathtrim90

# Filtering requirements
t <- c("v85", "v90", "o85", "o90")
tfilt <- paste(t, "_filt", sep="")

for (i in t) {
  p <- get(i)
  p <- p[-1]
  assign(i, p)
}

idx = 1
for (i in t) {
  assign(tfilt[idx], get(i) %>%
  filter(str_detect(species, 'F')) %>% 
  filter(nchar(species) > 1))
  idx <- idx + 1
}
# Statistical summary
header <- c("transcriptome size", "mean cluster size", "mean seq length (full clusters)", "mean length variance", "mean % fraser", "mean % canaan", "mean % balsam")

tns <- c(t, tfilt)
tnsStats <- paste(tns, "_stats", sep="")


idx = 1 
for (i in tns) {
  p <- get(i)
  assign(tnsStats[idx], c(length(p$ClustID), mean(p$seqCount), mean(p$avgLen), mean(as.numeric(p$lenVariance), na.rm = TRUE), mean(p$fraser), mean(p$canaan), mean(p$balsam)))
  idx <- idx + 1
}

# Build summary table
vXstat <- as.data.frame(rbind(v85_stats, v90_stats, o85_stats, o90_stats, v85_filt_stats, v90_filt_stats, o85_filt_stats, o90_filt_stats))
colnames(vXstat) <- header
rn <- c("vsearch85", "vsearch90", "orthofinder85", "orthofinder90")
rn2 <- c(rn, paste(rn, "_filt", sep=""))
rownames(vXstat) <- rn2

# export summary table
write.csv(vXstat, file = "~/Documents/scientist/projects/xmas_NAR/fir_transcriptomics/data/transcriptome_stats/tn_summary.csv", quote = F, row.names = T)
