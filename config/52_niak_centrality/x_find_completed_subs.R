#!/usr/bin/env Rscript

library(yaml)
library(plyr)


###
# Figure Out Completed/Missing Subjects
###

strats   <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")
sink.dirs <- file.path("/home2/data/Projects/ABIDE_Initiative/Derivatives/NIAK/Cent", sprintf("pipeline_%s", strats))

csubjs  <- list.files(sink.dirs[1], pattern="session_1")
subjs   <- sub("_session_1", "", csubjs)
n       <- length(subjs)

suffix <- "centrality_outputs_smoothed/_mask_mask_niak_90percent_gm/_scan_run1/_fwhm_6/_network_centrality_smooth_01/degree_centrality_weighted_maths_maths.nii.gz"

# Looks for smoothed weighted centrality maps
# for each subject and save subjs that are & aren't completed
subjs_ndone <- ldply(1:n, function(i) {
    tpaths      <- file.path(sink.dirs, csubjs[i], suffix)
    ret         <- sapply(tpaths, function(tpath) length(Sys.glob(tpath)))
    names(ret)  <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")
    ret
}, .progress="text")

# Are we good?
all(rowSums(subjs_ndone) == 4)
