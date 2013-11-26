#!/usr/bin/env Rscript

# I used nofilt global as the input

source("functions.R")

context("ALFF")

# This script will example the ALFF output 
# from the complete CPAC
# to the partial quick pack run

base.0 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1"

base.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/ALFF_Output/pipeline_nofilt_global/0051466_session_1"



###
# ALFF - RAW
###

# So first I want to know the ALFF output
alff.0 <- file.path(base.0, "alff_img/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_hp_0.01/_lp_0.1/residual_filtered_3dT.nii.gz")

# Then I want to know the QP ALFF output
alff.1 <- file.path(base.1, "alff_img/_scan_rest_1_rest/_scan_rest_1_rest/_hp_0.01/_lp_0.1/residual_filtered_3dT.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("ALFF maps in standard space with filtering", alff.0, alff.1)


###
# ALFF - Z Standard Smooth
###

# So first I want to know the ALFF output
alff.0 <- file.path(base.0,  "alff_Z_to_standard_smooth/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_hp_0.01/_lp_0.1/_fwhm_6/residual_filtered_3dT_maths_wimt_maths.nii.gz")

# Then I want to know the QP ALFF output
alff.1 <- file.path(base.1,  "alff_Z_to_standard_smooth/_scan_rest_1_rest/_scan_rest_1_rest/_hp_0.01/_lp_0.1/_scan_rest_1_rest/_scan_rest_1_rest/_fwhm_6/residual_filtered_3dT_maths_wimt_maths.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("Smoothed ALFF maps in standard space with filtering", alff.0, alff.1)


###
# fALFF - Z Standard Smooth
###

# So first I want to know the ALFF output
falff.0 <- file.path(base.0, "falff_Z_to_standard_smooth/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_hp_0.01/_lp_0.1/_fwhm_6/rest_3dc_tshift_RPI_3dv_automask_3dc_maths_wimt_maths.nii.gz")

# Then I want to know the QP ALFF output
falff.1 <- file.path(base.1, "falff_Z_to_standard_smooth/_scan_rest_1_rest/_scan_rest_1_rest/_hp_0.01/_lp_0.1/_scan_scan_rest_1_rest/_scan_rest_1_rest/_fwhm_6/functional_brain_mask_3dc_maths_wimt_maths.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("Smoothed fALFF maps in standard space with filtering", alff.0, alff.1)



