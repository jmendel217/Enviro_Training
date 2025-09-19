#!/bin/bash

#SBATCH --time=24:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=blstp            # Job name
#SBATCH --ntasks=32                 # Number of cores for the job. Same as SBATCH -n
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e ./zz.out/blstp-%j.err    # Error file for this job.
#SBATCH -o ./zz.out/blstp-%j.out    # Output file for this job.
#SBATCH --account=coa_mki314_uksr   # Project allocation account name (REQUIRED)

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: sbatch ./BlastP_VFDB.bash [folder]

   folder      Path to the folder containing the '11.bakta' directory.

   " >&2 ;
   exit 1 ;
fi ;

dir=$(readlink -f $1) ;

cd $dir
if [[ ! -e 11.bakta ]] ; then
   echo "Cannot locate the 11.bakta directory, aborting..." >&2
   exit 1
elif [[ ! -e 13.vfdb ]] ; then
   echo "Cannot locate the 13.vfdb directory, aborting..." >&2
   exit 1
fi ;

for i in 13.vfdb/blastp ; do
   [[ -d $i ]] || mkdir $i
done

# Change enveomics & blastp paths to yours
enve=/project/mki314_uksr/enveomics/Scripts
blastp=/project/mki314_uksr/Software/ncbi-blast-2.15.0+/bin/blastp

# Source path to Conda environments
source /project/mki314_uksr/miniconda3/etc/profile.d/conda.sh

# These paths should remain the same
VFDB=$dir/13.vfdb/VFDB_setA_pro_edited

# The number of CPUs or threads
THR=32

#---------------------------------------------------------
# Run blastp search against VFDB database

cd $dir ;
for $i in $dir/11.bakta/results/* ; do
   b=$(basename $i)
   $blastp -query ./11.bakta/results/$b/$b.faa -db $VFDB -max_target_seq 5 -num_threads $THR \
   -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen" > ./13.vfdb/blastp/$b_VFDB.blastp
   perl $enve/BlastTab.best_hit_sorted.pl ./13.vfdb/blastp/$b_VFDB.blastp > ./13.vfdb/blastp/$b_VFDB.bh.blastp
   awk '{if($12 >= 55 && $3 >= 40)print$0}' ./13.vfdb/blastp/$b_VFDB.bh.blastp > ./13.vfdb/blastp/$b_VFDB.bh.filt.blastp
done

#---------------------------------------------------------

echo "Done: $(date)." ;
