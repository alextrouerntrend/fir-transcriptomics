#!/bin/bash
#SBATCH --job-name=bwa2_index
#SBATCH --mail-user=alexander.trouern-trend@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=3G
#SBATCH -o bwa_%j.out
#SBATCH -e bwa_%j.err
#SBATCH --partition=general
#SBATCH --qos=general

start=`date +%s`

for i in v*.fnn; do
    /labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/analyses/mapping/bwa2/bwa-mem2/bwa-mem2 index $i
done

end=`date +%s`
runtime=$((end-start))
echo $runtime

