#!/usr/bin/env bash

###
# Compile Anats and Funcs for Preprocessing with FNIRT
###

base="/home2/data/Projects/ABIDE_Initiative/CPAC"

echo "3dTcat Func"
3dTcat -prefix func_all.nii.gz ${base}/Output0723/sym_links/pipeline_HackettCity/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.98_GM_0.7_WM_0.98/*/scan_rest_1_rest/func/mean_functional_in_mni_2mm.nii.gz

# Mean Functional
echo "3dTstat Mean Func"
3dTstat -mean -prefix func_mean.nii.gz func_all.nii.gz

# CV Functional
echo "3dTstat CV Func"
3dTstat -cvar -prefix func_cv.nii.gz func_all.nii.gz

# Mask Functional
echo "fslmaths/3dTstat Mask Func"
fslmaths func_all.nii.gz -bin func_all_bin.nii.gz
3dTstat -mean -prefix func_mask.nii.gz func_all_bin.nii.gz
rm func_all_bin.nii.gz
