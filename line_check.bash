#!/bin/bash
#SBATCH --time=06:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=lines            # Job name
#SBATCH --ntasks=2                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e lines-%j.err             # Error file for this job.
#SBATCH -o lines-%j.out             # Output file for this job.
#SBATCH --account=coa_mki314_uksr   # Project allocation account name (REQUIRED)

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: ./rename.bash folder
   folder	Path to the folder containing the reads. The zipped reads must have .fastq file type.
      " >&2 ;
   exit 1 ;
fi ;

# Specify the directory containing your files with "_#.fastq"
name_dir="$1"
touch "name_dir"/lines.txt

# Iterate over each file in the specified directory
for i in "name_dir"/*.fastq; do
  line_count=$(wc -l "i")
  echo "$i: $line_count;" >> "lines.txt"
done
  
