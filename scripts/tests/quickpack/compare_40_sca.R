#!/usr/bin/env Rscript

source("functions.R")

context("SCA")



base.0 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/All_Output/pipeline_MerrittIsland/0051466_session_1"

base.1 <- "/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/SCA_Output/pipeline_nofilt_global/0051466_session_1"



###
# CC200 Timeseries
###

cat("Comparing time-series\n")

fsca.0 <- file.path(base.0, "roi_timeseries/_scan_rest_1_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0/_roi_CC200/roi_CC200.csv")

fsca.1 <- file.path(base.1, "roi_timeseries/_roi_CC200/_scan_rest_1_rest/roi_CC200.csv")

# Finally, I should read them in and compare them

sca.0 <- read.csv(fsca.0)
sca.1 <- read.csv(fsca.1)

expect_that(sca.0, equals(sca.1))



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
