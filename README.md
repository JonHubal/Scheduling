# Scheduling
Original (busy) slurm - one core, run loop and reports how many increments it completed.
New (share) slurm - one core, split task into 4 threads and counts each.  The total might be LOWER than busy demonstrating the added cost of switching
The intent is to demonstrate that running 4 jobs on the same core doesn't save time as you are splitting the processor
Added another round of 100 tasks hopefully to visibly see the cost of switching.
