#!/usr/bin/env bash

base="/data/Projects/ABIDE_Initiative/CCS/processed"
subject_list="${base}/scripts/subjects_rest.list"

to_test=0   # only runs one subject

# Get subjects to run
subjects=$( cat ${subject_list} )

for subject in ${subjects}; do
    echo =======
    echo $subject

    subdir="${base}/${subject}"
    funcdir="${subdir}/func/rest_1"
    gsdir="${funcdir}/gs-removal"

    # We want to create a new soft linked version of the filtered data in native and standard space
    ## So let's do this in native space first
    cmd="ln -sf ${funcdir}/rest_pp_sm0.nii.gz ${funcdir}/rest_pp_filt_sm0.nii.gz"
    echo $cmd; eval $cmd
    ## Now in standard space
    cmd="ln -sf ${funcdir}/rest.sm0.mni152.nii.gz ${funcdir}/rest.filt.sm0.mni152.nii.gz"
    echo $cmd; eval $cmd

    # Same thing but with global signal corrected data
    ## Native space
    cmd="ln -sf ${gsdir}/rest_pp_sm0.nii.gz ${gsdir}/rest_pp_filt_sm0.nii.gz"
    echo $cmd; eval $cmd
    ## Standard space
    cmd="ln -sf ${gsdir}/rest.sm0.mni152.nii.gz ${gsdir}/rest.filt.sm0.mni152.nii.gz"
    echo $cmd; eval $cmd

    echo =======
    
    break & [[ $to_test -eq 1 ]]
done

