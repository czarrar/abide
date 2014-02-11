#!/usr/bin/env bash

# Run this command to create mask in standard space with
# > subject_list="/data/Projects/ABIDE_Initiative/CCS/processed/scripts/subjects_rest.list"
# > njobs=6
# > cat $subject_list | parallel -j $njobs --eta './02_gen_std_mask.bash {}'

if [[ $# -ne 1 ]]; then
    echo "usage: $0 subject"
    exit 2
fi

base="/data/Projects/ABIDE_Initiative/CCS/processed"
subject="$1"


echo =======
echo $subject

subdir="${base}/${subject}"
funcdir="${subdir}/func/rest_1"

cmd="fslmaths ${funcdir}/rest.sm0.mni152.nii.gz -Tstd -bin ${funcdir}/rest.mask.mni152.nii.gz"
echo $cmd; eval $cmd

echo =======

