#!/bin/bash
#SBATCH --job-name=Orthogroupsam
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 6
#SBATCH --mem=20G
#SBATCH --partition=special
#SBATCH --qos=special
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alexander.trouern-trend@uconn.edu
#SBATCH -o Orthogroupsam_%j.out
#SBATCH -e Orthogroupsam_%j.err

module load vsearch

for TASK_ID in $(seq 1 $(wc -l Orthogroupsam | cut -f1 -d' '));
do
    echo "host name : " `hostname`
    echo This is array task number $TASK_ID

    BFPATH="/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting/balsam.fnn"
    CFPATH="/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting/canaan.fnn"
    FFPATH="/labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting/fraser.fnn"

    # Gather data
    OG=$(sed -n ${TASK_ID}p Orthogroupsam | cut -f 1 )
    BF=$(sed -n ${TASK_ID}p Orthogroupsam | cut -f 2 | sed 's/, /TXXXT/g')
    CF=$(sed -n ${TASK_ID}p Orthogroupsam | cut -f 3 | sed 's/, /TXXXT/g')
    FF=$(sed -n ${TASK_ID}p Orthogroupsam | cut -f 4 | sed 's/, /TXXXT/g')

    # Make a designated directory for orthogroup
    cd fir85

    DIR=$"id_${OG}"

    if [ ! -d "$DIR" ]
    then mkdir "$DIR"
    fi

    cd "$DIR"

    TRAN=($BFPATH $CFPATH $FFPATH)
    LIST=("$BF" "$CF" "$FF")

    IDX=0 #initialize index
    # run grabseqs to generate nucleotide multifasta for clustering
    for i in "${TRAN[@]}";
    do
      python /labs/Wegrzyn/Transcriptomics/xmas_trees/NAR/poola/transcriptomes/vsearch_splitting/grabseqs.py \
        -f $i \
        -l ${LIST[$IDX]} \
        -o ./${OG}.fnn
      IDX=$((IDX+1));
    done

    # Cluster at 90% identity
    vsearch --threads 6 --cluster_fast ${OG}.fnn --id 0.85 --centroids ${OG}_centroids.fnn --clusters ${OG}_;
    cd ../../
done
