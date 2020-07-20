## Datasets

### TRANSCRIPTOME STATISTICS
Two methods of transcriptome construction by two clustering minimum identity.
    **Clustering methods**
	1. VSEARCH (single species) --> VSEARCH (multispecies)
	xanadu path: `/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch`
	2. VSEARCH (single species) --> Orthofinder (multispecies) --> VSEARCH (orthogroups)
	xanadu path: `/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting'

**Clustering identities** (VSEARCH (multispecies) and VSEARCH (orthogroups)), VSEARCH (single species) non-variable at 90%
	1. 90%
	xanadu path: `$CLUST_PATH/fir90`
	2. 85%
	xanadu path: `$CLUST_PATH/fir85`

Input .tsv files generated from clustStats.py (https://github.com/alextrouerntrend/bioscripts/blob/master/utils/clustStats.py)
