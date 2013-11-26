#!/usr/bin/env Rscript

source("functions.R")

context("REHO")

# This script will example the ALFF output 
# from the complete CPAC
# to the partial quick pack run

base.0 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1"

base.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/Centrality_Output/pipeline_nofilt_global/0051466_session_1"



###
# Centrality Smoothed
###

centrality.0 <- file.path(base.0, "centrality_outputs_smoothed/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_mask_mask_abide_90percent_gm/_fwhm_6/_network_centrality_smooth_01/degree_centrality_weighted_maths_maths.nii.gz")

centrality.1 <- file.path(base.1, "centrality_outputs_smoothed/_mask_mask_abide_90percent_gm/_scan_rest_1_rest/_fwhm_6/_network_centrality_smooth_01/degree_centrality_weighted_maths_maths.nii.gz")

# Finally, I should read them in and compare them
compare_3D_brains("smoothed centrality maps", centrality.0, centrality.1)


# - verify standardization
# - see how standardization is done
