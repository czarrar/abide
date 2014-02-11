#!/usr/bin/env Rscript

library(yaml)
library(plyr)


###
# Figure Out Completed/Missing Subjects
###

sink.dir <- "/home2/data/Projects/ABIDE_Initiative/Derivatives/CCS/Eigen"

csubjs  <- list.files(file.path(sink.dir, "pipeline_filt_global"), pattern="session_1")
subjs   <- sub("_session_1", "", csubjs)
n       <- length(subjs)


sink.dirs <- file.path(sink.dir, sprintf("pipeline_%s", c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")))
suffix <- "centrality_outputs_zscore/_mask_mask_ccs_90percent_gm/_scan_rest_1/eigenvector_centrality_weighted_maths.nii.gz"

# Looks for smoothed weighted centrality maps
# for each subject and save subjs that are & aren't completed
subjs_ndone <- ldply(1:n, function(i) {
    tpaths      <- file.path(sink.dirs, csubjs[i], suffix)
    ret         <- file.exists(tpaths)
    names(ret)  <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")
    ret
}, .progress="text")

# Only keep those subjs with all 4 outputs
subjs_done <- subjs[rowSums(subjs_ndone) == 4]

subjs_bad <- subjs[rowSums(subjs_ndone) < 4]

###
# Filter the Subject YAML File
###

yml <- yaml.load_file("../28_centrality/start_CPAC_subject_list.yml")

# Loop through each subject in yaml
# and only keep those that HAVE NOT been done
yml.tokeep <- laply(yml, function(yml.subj) {
    if (yml.subj$subject_id %in% subjs_done) {
        return(FALSE)
    } else {
        return(TRUE)
    }
}, .progress="text")
cat("ALL: keeping", sum(yml.tokeep), "out of", length(yml), "\n")
yaml.save <- yml[yml.tokeep]

# Save
cat(as.yaml(yaml.save), file="start_CPAC_subject_list_01-24-14.yml")


###
# Filter the Subject YAML File per strategy
###

for (name in c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")) {
    yml <- yaml.load_file(sprintf("../28_centrality/quick_pack_rest_1_rest_%s.yml", name))

    # Loop through each subject in yaml
    # and only keep those that HAVE NOT been done
    yml.tokeep <- laply(yml, function(yml.subj) {
        if (yml.subj$subject_id %in% subjs[subjs_ndone[[name]]==1]) {
            return(FALSE)
        } else {
            return(TRUE)
        }
    }, .progress="text")
    cat(name, ": keeping", sum(yml.tokeep), "out of", length(yml), "\n")
    yaml.save <- yml[yml.tokeep]

    # Save
    cat(as.yaml(yaml.save), file=sprintf("quick_pack_rest_1_rest_reduced_%s.yml", name))
}

