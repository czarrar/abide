#!/usr/bin/env bash

###
# Compile Anats and Funcs for New Preprocessing with ANTs
###

base="/home2/data/Projects/ABIDE_Initiative/CPAC"

#echo "3dTcat Anat"
#3dTcat -prefix anat_all.nii.gz ${base}/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/*/scan/anat/mni_normalized_anatomical.nii.gz
#
## Mean Anatomical
#echo "3dTstat Mean Anat"
#3dTstat -mean -prefix anat_mean.nii.gz anat_all.nii.gz
#
## CV Anatomical
#echo "3dTstat CV Anat"
#3dTstat -cvar -prefix anat_cv.nii.gz anat_all.nii.gz

# Mask
echo "fslmaths/3dTstat Mask Anat"
fslmaths anat_all.nii.gz -bin anat_all_bin.nii.gz
3dTstat -mean -prefix anat_mask.nii.gz anat_all_bin.nii.gz
rm anat_all_bin.nii.gz
