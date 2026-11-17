#!/bin/bash
#SBATCH --job-name=it254-share
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=512M
#SBATCH --time=00:05:00
#SBATCH --output=share-%j.out

echo "Job ID: $SLURM_JOB_ID"
echo "Compute node: $(hostname)"
echo "Started: $(date)"
loop='start=$SECONDS; c=0; while (( SECONDS - start < 60 )); do (( c += 1 )); done; echo $c'

# Run N busy-loops in parallel; sets $total. Prints per-task counts when N <= 4.
run_loops() {
    local count=$1 dir i n
    dir=$(mktemp -d)
    for (( i = 1; i <= count; i++ )); do
        bash -c "$loop" > "$dir/$i" &
    done
    wait
    total=0
    for (( i = 1; i <= count; i++ )); do
        n=$(cat "$dir/$i")
        if (( count <= 4 )); then
            echo "Task $i increments: $n"
        fi
        (( total += n ))
    done
    rm -rf "$dir"
}

echo
echo "=== 1 busy-loop ==="
run_loops 1
total1=$total
echo "Total increments: $total1"

echo
echo "=== 4 busy-loops ==="
run_loops 4
total4=$total
echo "Total increments: $total4"

echo
echo "=== 100 busy-loops ==="
run_loops 100
total100=$total
echo "Total increments: $total100"

echo
echo "=== Comparison ==="
printf "%-8s %15s %15s %12s\n" "Loops" "Total" "Per loop" "% of 1-loop"
for pair in "1 $total1" "4 $total4" "100 $total100"; do
    read -r loops t <<< "$pair"
    printf "%-8s %15d %15d %11d%%\n" "$loops" "$t" $(( t / loops )) $(( t * 100 / total1 ))
done

echo
echo "Finished: $(date)"
