### Data
Files presented below represent pre and post-filtering transcriptomes derived from both the vsearch and orthofinder strategy described in [the notebook](https://github.com/alextrouerntrend/fir-transcriptomics/blob/master/notebooks/reference_assembly.ipynb). Here I will describe the file naming scheme.
- "o" refers to orthofinder strategy
- "v" refers to vsearch-only strategy
- "85" refers to vsearch run at 85% identity
- "90" refers to vsearch run at 90% identity
- "filt" suffix refers to sets that have been filtered to meet species membership requirements

There are several subdirectories:
- [centroids](https://github.com/alextrouerntrend/fir-transcriptomics/tree/master/data/centroids): contain transcript headers for each transcriptome version
- [transcriptome stats](https://github.com/alextrouerntrend/fir-transcriptomics/tree/master/data/transcriptome_stats): contain overview statistics for each transcript cluster, one cluster per row. This directory also contains the summary table, [tn_summary.csv](https://github.com/alextrouerntrend/fir-transcriptomics/blob/master/data/transcriptome_stats/tn_summary.csv)
- [orthofinder](https://github.com/alextrouerntrend/fir-transcriptomics/tree/master/data/orthofinder): relevant files from orthofinder1 and orthofinder2 runs.
