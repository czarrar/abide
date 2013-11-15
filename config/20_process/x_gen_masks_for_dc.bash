#!/usr/bin/env bash

# Get base path
inputDir="/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96"

# Combine the data together
cmd="3dTcat -prefix /home2/data/Projects/ABIDE_Initiative/CPAC/tmp/MasksStack.nii.gz ${inputDir}/*/scan_res*/func/functional_brain_mask_to_standard.nii.gz"
echo $cmd
$cmd
 
# Get the brain mask
output="/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"

cmd="fslmaths /home2/data/Projects/ABIDE_Initiative/CPAC/tmp/MasksStack.nii.gz -Tmean /home2/data/Projects/ABIDE_Initiative/CPAC/tmp/mean.nii.gz"
echo $cmd
$cmd

cmd="fslmaths /home2/data/Projects/ABIDE_Initiative/CPAC/tmp/mean.nii.gz -thr 1 -bin ${output}/mask_abide_100percent.nii.gz"
echo $cmd
$cmd

cmd="fslmaths /home2/data/Projects/ABIDE_Initiative/CPAC/tmp/mean.nii.gz -thr 0.9 -bin ${output}/mask_abide_90percent.nii.gz"
echo $cmd
$cmd

cmd="3dcalc -a ${output}/mask_abide_90percent.nii.gz -b /home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks/MNI152_T1_GREY_2mm_25pc_mask.nii.gz -expr 'a*b' -prefix ${output}/mask_abide_90percent_gm.nii.gz"
echo $cmd
$cmd

