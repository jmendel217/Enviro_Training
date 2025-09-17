#!/bin/bash

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: ./RUNME.bash [folder] [queue] [QOS]

   folder      Path to the folder containing the raw reads. The raw reads must be in FastQ format, and
               filenames must follow the format: <name>.<sis>.fastq, where <name> is the name
               of the sample, and <sis> is 1 or 2 indicating which sister read the file contains.
               Use only '1' as <sis> if you have single reads.
   partition   Select a partition (If not provided, coa_mki314_uksr will be used).
   qos		     Select a quality of service (If not provided, normal will be used).
   
   " >&2 ;
   exit 1 ;
fi ;

TOOL=$2
if [[ "$TOOL" == "" ]] ; then
   TOOL="standard"
fi ;

QUEUE=$3
if [[ "$QUEUE" == "" ]] ; then
   QUEUE="coa_mki314_uksr"
fi ;

QOS=$4
if [[ "$QOS" == "" ]] ; then
   QOS="normal"
fi ;

dir=$(readlink -f $1) ;
pac=$(dirname $(readlink -f $0)) ;
cwd=$(pwd) ;

#---------------------------------------------------------

cd $dir ;
for i in TAD80 ; do
   if [[ ! -d $i ]] ; then mkdir $i ; fi ;
done ;

for i in $dir/16.checkm2/output/good_quality/*.fa ; do 
   b=$(basename $i .fa) ;
   OPTS="SAMPLE=$b,FOLDER=$dir"
   # Launch job
   sbatch --export="$OPTS" -J "Trim-$b" --account=$QUEUE --partition=$QOS --error "$dir"/zz.out/"TAD80-$b"-%j.err -o "$dir"/zz.out/"TAD80-$b"-%j.out  $pac/run.pbs | grep .;
done ;

#---------------------------------------------------------
# Combine statistics outputs

#cd $dir/zz.stats
#paste *stats.txt  > bmtagger_statistics.txt

#---------------------------------------------------------

echo "Done: $(date)." ;
