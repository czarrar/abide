#!/usr/bin/env Rscript

source("functions.R")

context("Dual Regression")

# This script will example the ALFF output 
# from the complete CPAC
# to the partial quick pack run

base.0 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1"

base.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/DR_Output/pipeline_nofilt_global/0051466_session_1"


###
# DR Z Stack 2 Standard
###

# So first I want to know the REHO output
dr.0 <- file.path(base.0, "dr_tempreg_maps_z_stack_to_standard/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_spatial_map_PNAS_Smith09_rsn10/temp_reg_map_z_wimt.nii.gz")

# Then I want to know the QP REHO output
dr.1 <- file.path(base.1, "dr_tempreg_maps_z_stack_to_standard/_scan_rest_1_rest/_scan_rest_1_rest/_spatial_map_PNAS_Smith09_rsn10/_scan_rest_1_rest/_scan_rest_1_rest/_scan_rest_1_rest/temp_reg_map_z_wimt.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("DR Z Stack 2 Standard", dr.0, dr.1)

