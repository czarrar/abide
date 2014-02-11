#!/usr/bin/env bash

echo "" > rerun_subjects.txt
ids=$( qstat | tail -n +3 | awk '{print $1}' )

for id in ${ids}; do
    line_num=$( grep -n $id /home2/data/Projects/ABIDE_Initiative/Derivatives/NIAK/Eigen/pid.txt | sed s/':.*'//g )
    subj=$( sed -n "${line_num}p" /home2/data/Projects/ABIDE_Initiative/Derivatives/NIAK/Eigen/subs.txt )
    echo $subj >> rerun_subjects.txt
done

echo "see rerun_subjects.txt"
