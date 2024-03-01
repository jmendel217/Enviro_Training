#!/bin/bash
#SBATCH --time=06:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=unzip            # Job name
#SBATCH --ntasks=2                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e unzip-%j.err             # Error file for this job.
#SBATCH -o unzip-%j.out             # Output file for this job.
#SBATCH --account=coa_mki314_uksr     # Project allocation account name (REQUIRED)

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: ./rename.bash folder
   folder	Path to the folder containing the zipped reads. The zipped reads must have .gz file type.
      " >&2 ;
   exit 1 ;
fi ;

# Specify the directory containing your files with "_#.fastq"
name_dir="$1"

# Iterate over each file in the specified directory
for fname in "$name_dir"/*.fastq; do
  name="${fname%\.*}"
  extension="${fname#$name}"
  newname="${name//_/.}"
  newfname="$newname""$extension"
  if [ "$fname" != "$newfname" ]; then
    echo mv "$fname" "$newfname"
    mv "$fname" "$newfname"
  fi
done
