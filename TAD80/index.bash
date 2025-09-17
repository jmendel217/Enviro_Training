#!/bin/bash

#SBATCH --time=06:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=index            # Job name
#SBATCH --ntasks=4                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e index-%j.err             # Error file for this job.
#SBATCH -o index-%j.out             # Output file for this job.
#SBATCH --account=coa_mki314_uksr   # Project allocation account name (REQUIRED)

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: sbatch ./index.bash [folder] [genome] [accession]

   folder      Path to the folder containing the raw reads. A directory named 'human
               genome' will be created to contain the dataset. Most recent dataset as
               of publishing will be used by default, unless instructed otherwise.
   
   genome      Name of the genome assembly. Defaults to 'GRCh38_p14' to represent the
               most recent human genome dataset.
   
   accession   NCBI accession number. Defaults to 'GCF_000001405.40' to represent the
               most recent human genome dataset.
   
   " >&2 ;
   exit 1 ;
fi ;

genome=$2
if [[ "$genome" == "" ]] ; then
   genome="GRCh38_p14"
fi ;

accession=$3
if [[ "$accession" == "" ]] ; then
   accession="GCF_000001405.40"
fi ;

dir=$(readlink -f $1) ;
gen="${genome%_*}" ;
ome="${genome#*_}" ;

# Source path to Conda environments
source /project/mki314_uksr/miniconda3/etc/profile.d/conda.sh

#---------------------------------------------------------
# Download and Unzip file
