#!/usr/bin/env bash

###
# Compile Anats and Funcs for New Preprocessing with ANTs
###

base="/home2/data/Projects/ABIDE_Initiative/CPAC"


## Mean Functional
#echo "3dTcat Func"
#3dTcat -prefix func_all.nii.gz ${base}/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/*/scan_rest_1_rest/func/mean_functional_in_mni.nii.gz
#
## Mean Functional
#echo "3dTstat Mean Func"
#3dTstat -mean -prefix func_mean.nii.gz func_all.nii.gz
#
## CV Functional
#echo "3dTstat CV Func"
#3dTstat -cvar -prefix func_cv.nii.gz func_all.nii.gz

# Mask Functional
echo "fslmaths/3dTstat Mask Func"
fslmaths func_all.nii.gz -bin func_all_bin.nii.gz
3dTstat -mean -prefix func_mask.nii.gz func_all_bin.nii.gz
rm func_all_bin.nii.gz
