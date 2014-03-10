#!/usr/bin/env Rscript

library(yaml)
library(plyr)

measure     <- "centrality_outputs_smoothed"

###
# Figure Out Completed/Missing Subjects
###


sink.dir    <- "/home2/data/Projects/ABIDE_Initiative/Derivatives/CPAC/Cent/Out/pipeline_rest_1"

# Get the list of subjects
yml     <- yaml.load_file("../22_process_3mm/CPAC_subject_list.yml")
subjs   <- laply(yml, function(x) x$subject_id, .progress="text")
csubjs  <- paste(subjs, "_session_1", sep="")
n       <- length(subjs)

# Loop through each subject and get the path
strats      <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")

paths.df <- ldply(strats, function(strat) {
    cat("\nstrategy:", strat, "\n")
    ldply(1:n, function(i) {
        subdir  <- file.path(sink.dir, csubjs[i])
        if (file.exists(subdir)) {
            path_fs <- file.path(subdir, "path_files_here", "*")
            cmd     <- sprintf("grep '%s.*_scan_%s.*binarize' %s", measure, strat, path_fs)
            path    <- system(cmd, intern=TRUE)
            path    <- sub(sprintf("%s.*txt:", dirname(path_fs)), "", path)
        } else {
            path <- c()
        }
        if (length(path) == 0) {
            exists  <- FALSE
            path    <- NA
        } else {
            exists  <- file.exists(path)
        }
        # I'm guessing if there are multiple outputs, ret should be multiline
        # might want to use str_split to do the split
        data.frame(
            subject     = subjs[i], 
            strategy    = strat, 
            path        = path, 
            exists      = exists
        )
    }, .progress="text")
})


###
# Filter the Subject YAML File
###

yml <- yaml.load_file("start_CPAC_subject_list.yml")

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
cat(as.yaml(yaml.save), file="start_CPAC_subject_list_12-26-13.yml")


###
# Filter the Subject YAML File per strategy
###

for (name in c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")) {
    yml <- yaml.load_file(sprintf("quick_pack_rest_1_rest_%s.yml", name))

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

