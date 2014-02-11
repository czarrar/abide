#!/usr/bin/env bash

# Run this command to create mask in standard space with
# > ls -d /home2/data/Projects/ABIDE_Initiative/NIAK/processed/*/*/*.nii.gz > func_files.list
# > njobs=10
# > cat func_files.list | parallel -j $njobs --eta './02_gen_masks.bash {}'

if [[ $# -ne 1 ]]; then
    echo "usage: $0 infile"
    exit 2
fi

infile="$1"
meanfile="${infile%%.nii.gz}_mean.nii.gz"
outfile="${infile%%.nii.gz}_mask.nii.gz"

cmd="rm -f ${meanfile} ${outfile}"
echo $cmd; eval $cmd

cmd="fslmaths ${infile} -Tmean ${meanfile}"

cmd="3dAutomask -prefix ${outfile} -dilate 2 ${infile}"
echo $cmd; eval $cmd
