#!/bin/bash
#SBATCH --job-name=bwa-array
#SBATCH --mail-user=alexander.trouern-trend@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --mem=10G
#SBATCH --array=[1-74]%2
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.out
#SBATCH --partition=himem
#SBATCH --qos=himem

module load bwa

echo "host name : " `hostname`
echo This is array task number $SLURM_ARRAY_TASK_ID

READDIR="/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/data/reads/"
p="$(sed "${SLURM_ARRAY_TASK_ID}q;d" ../lib_uniq.txt)"
echo Mapping library $p to v90

fn="$(echo $p | awk -F"/" '{print $1 "\/" $3}')"

/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/analyses/mapping/bwa2/bwa-mem2/bwa-mem2 mem -t 16 index/v90.fnn "${READDIR}${p}R1.fastq" "${READDIR}${p}R2.fastq" > ./output_v90/${fn}out.sam
