#!/bin/bash
#SBATCH --job-name=it254-share
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=256M
#SBATCH --time=00:02:00
#SBATCH --output=share-%j.out

echo "Job ID: $SLURM_JOB_ID"
echo "Compute node: $(hostname)"
echo "Started: $(date)"
loop='start=$SECONDS; c=0; while (( SECONDS - start < 60 )); do (( c += 1 )); done; echo $c'
dir=$(mktemp -d)
for i in 1 2 3 4; do
    bash -c "$loop" > "$dir/$i" &
done
wait
total=0
for i in 1 2 3 4; do
    n=$(cat "$dir/$i")
    echo "Task $i increments: $n"
    (( total += n ))
done
rm -rf "$dir"
echo "Total increments: $total"
echo "Finished: $(date)"
