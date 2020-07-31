#!/bin/bash
#SBATCH --job-name=bwa_index
#SBATCH --mail-user=alexander.trouern-trend@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 26
#SBATCH --mem=150G
#SBATCH -o bwa_%j.out
#SBATCH -e bwa_%j.err
#SBATCH --partition=general
#SBATCH --qos=general

module load samtools

for i in *.fnn; do
    bwa index -a is $i
done
