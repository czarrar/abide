#!/usr/bin/env Rscript

source("functions.R")

context("REHO")

# This script will example the ALFF output 
# from the complete CPAC
# to the partial quick pack run

base.0 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1"

base.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/Reho_Output/pipeline_nofilt_global/0051466_session_1"



###
# Raw REHO
###

# So first I want to know the REHO output
reho.0 <- file.path(base.0, "raw_reho_map/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/ReHo.nii.gz")

# Then I want to know the QP REHO output
reho.1 <- file.path(base.1, "raw_reho_map/_scan_rest_1_rest/_scan_rest_1_rest/ReHo.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("raw REHO maps", reho.0, reho.1)


###
# REHO Z-Score Smoothing in Standard Space
###

reho.0 <- file.path(base.0, "reho_Z_to_standard_smooth/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_fwhm_6/ReHo_maths_wimt_maths.nii.gz")

reho.1 <- file.path(base.1, "reho_Z_to_standard_smooth/_scan_rest_1_rest/_scan_rest_1_rest/_scan_rest_1_rest/_scan_rest_1_rest/_fwhm_6/ReHo_maths_wimt_maths.nii.gz")

compare_3D_brains("z-score smoothed 2 standard REHO maps", reho.0, reho.1)



###
# Other 4D Data
###

#infile.0 <- "/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Working/resting_preproc_0051466_session_1/nuisance_0/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/residuals/residual.nii.gz"
#
#infile.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1/functional_nuisance_residuals/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/residual.nii.gz"
#
#infile.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/0051466_session_1/scan_rest_1_rest/func/functional_nuisance_residuals.nii.gz"
#
#ref.file    <- infile.0
#comp.file   <- infile.1
#
#ref.img     <- read.big.nifti4d(ref.file)
#comp.img    <- read.big.nifti4d(comp.file)
#
#library(biganalytics)
#ref.mask    <- colsd(ref.img)!=0
#comp.mask   <- colsd(comp.img)!=0
#expect_that(ref.mask, equals(comp.mask))
#
#mask        <- ref.mask | comp.mask
#
#ref.masked  <- do.mask(ref.img, mask)
#comp.masked <- do.mask(comp.img, mask)
#
#
#
#compare_3D_brains("raw inputs", infile.0, infile.1)
