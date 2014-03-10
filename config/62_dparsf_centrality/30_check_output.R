#!/usr/bin/env Rscript

library(yaml)
library(plyr)


###
# Figure Out Completed/Missing Subjects
###

strats   <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")
sink.dirs <- file.path("/home2/data/Projects/ABIDE_Initiative/Derivatives/DPARSF/Output", sprintf("pipeline_%s", strats))

csubjs  <- list.files(sink.dirs[1], pattern="session_1")
subjs   <- sub("_session_1", "", csubjs)
n       <- length(subjs)

suffix <- "alff_img/_scan_rest_1/_scan_rest_1/_hp_0.01/_lp_0.1/residual_filtered_3dT.nii.gz"

# Looks for alff output
# for each subject and save subjs that are & aren't completed
subjs_ndone <- ldply(1:n, function(i) {
    tpaths      <- file.path(sink.dirs, csubjs[i], suffix)
    ret         <- sapply(tpaths, function(tpath) length(Sys.glob(tpath)))
    names(ret)  <- strats
    ret
}, .progress="text")

# Only keep those subjs with all 4 outputs
subjs_done <- subjs[rowSums(subjs_ndone) == 4]

# Who didn't complete?
for (i in 1:length(strats)) {
    strat <- strats[i]
    cat("FOR", strat, ":\n")
    subjs_bad <- subjs[subjs_ndone[,i]==0]
    nbad <- length(subjs_bad)
    cat(sprintf("You have %i subjects that are missing the alff output\n", nbad))
    if (nbad > 0) {
        cat(sprintf("They are %s", paste(subjs_bad, collapse=", ")), "\n")
    }
    cat("\n")
}
## look at all
cat("ACROSS ALL:\n")
subjs_bad <- subjs[rowSums(subjs_ndone) < 4]
nbad      <- length(subjs_bad)
cat(sprintf("You have %i subjects that are missing the alff output\n", nbad))
if (nbad > 0) {
    cat(sprintf("They are %s", paste(subjs_bad, collapse=", ")), "\n")
}
