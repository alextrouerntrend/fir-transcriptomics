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
stat_v85 <- c(length(v85$ClustID), mean(v85$seqCount), mean(v85$avgLen), mean(as.numeric(v85$lenVariance), na.rm = TRUE), mean(v85$fraser), mean(v85$canaan), mean(v85$balsam))
stat_v90 <- c(length(v90$ClustID), mean(v90$seqCount), mean(v90$avgLen), mean(as.numeric(v90$lenVariance), na.rm = TRUE), mean(v90$fraser), mean(v90$canaan), mean(v90$balsam))
stat_v85_filt <- c(length(v85_filt$ClustID), mean(v85_filt$seqCount), mean(v85_filt$avgLen), mean(as.numeric(v85_filt$lenVariance), na.rm = TRUE), mean(v85_filt$fraser), mean(v85_filt$canaan), mean(v85_filt$balsam))
stat_v90_filt <- c(length(v90_filt$ClustID), mean(v90_filt$seqCount), mean(v90_filt$avgLen), mean(as.numeric(v90_filt$lenVariance), na.rm = TRUE), mean(v90_filt$fraser), mean(v90_filt$canaan), mean(v90_filt$balsam))
stat_o85 <- c(length(o85$ClustID), mean(o85$seqCount), mean(o85$avgLen), mean(as.numeric(o85$lenVariance), na.rm = TRUE), mean(o85$fraser), mean(o85$canaan), mean(o85$balsam))
stat_o90 <- c(length(o90$ClustID), mean(o90$seqCount), mean(o90$avgLen), mean(as.numeric(o90$lenVariance), na.rm = TRUE), mean(o90$fraser), mean(o90$canaan), mean(o90$balsam))
stat_o85_filt <- c(length(o85_filt$ClustID), mean(o85_filt$seqCount), mean(o85_filt$avgLen), mean(as.numeric(o85_filt$lenVariance), na.rm = TRUE), mean(o85_filt$fraser), mean(o85_filt$canaan), mean(o85_filt$balsam))
stat_o90_filt <- c(length(o90_filt$ClustID), mean(o90_filt$seqCount), mean(o90_filt$avgLen), mean(as.numeric(o90_filt$lenVariance), na.rm = TRUE), mean(o90_filt$fraser), mean(o90_filt$canaan), mean(o90_filt$balsam))

# Build summary table
vXstat <- as.data.frame(rbind(stat_v85, stat_v90, stat_o85, stat_o90, stat_v85_filt, stat_v90_filt, stat_o85_filt, stat_o90_filt))
colnames(vXstat) <- header
rn <- c("vsearch85", "vsearch90", "orthofinder85", "orthofinder90")
rn2 <- c(rn, paste(rn, "_filt", sep=""))
rownames(vXstat) <- rn2

# export summary table
write.csv(vXstat, file = "~/Documents/scientist/projects/xmas_NAR/fir_transcriptomics/data/transcriptome_stats/tn_summary.csv", quote = F, row.names = T)
