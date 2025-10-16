#!/bin/bash

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: ./RUNME.bash [source] [destination] [queue] [QOS]
   
   source      Path to the folder containing the files you want to copy
   destination Path to the folder where you want files to be copied to
   partition   Select a partition (if not provided, coa_mki314_uksr will be used)
   qos         Select a quality of service (if not provided, normal will be used)

   " >&2 ;
   exit 1 ;
fi ;

DEST=$2
if [[ "$DEST" == "" ]] ; then
   exit 1 ;
fi ;

QUEUE=$3
if [[ "$QUEUE" == "" ]] ; then
   QUEUE="coa_mki314_uksr"
fi ;

QOS=$4
if [[ "$QOS" == "" ]] ; then
   QOS="normal"
fi ;

SRCE=$(readlink -f $1)
pac=$(dirname $(readlink -f $0))
cwd=$(pwd)

#---------------------------------------------------------

cd $SRCE

for i in $SRCE/*.fastq ; do
   b=$(basename $i .fastq)
   OPTS="SAMPLE=$b,FOLDER=$SRCE"
   # Launch job
   sbatch --export="$OPTS" -J "Copy-$b" --account=$QUEUE --partition=$QOS --error "$DEST"/"Copy-$b"-%j.err -o "$DEST"/"Copy-$b"-%j.out  $pac/copy_run.pbs | grep .;
done

#---------------------------------------------------------

echo "Done: $(date)." ;
