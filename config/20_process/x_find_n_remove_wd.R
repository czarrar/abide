#!/usr/bin/env Rscript

# Subject who have finished running
cat("Getting finished jobs/subjects\n")
## Their Job IDs
all_ids <- as.character(read.table("/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-12/pid.txt")[,1])
cur_ids <- system("qstat | awk '{print $1}' | tail -n+3", intern=T)
finished_ids <- !(all_ids %in% cur_ids)
## Their Subject IDs
all_subs <- as.character(read.table("/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-12/sub.txt")[,1])
finished_subs <- all_subs[finished_ids]
finished_subs <- sub("_session_1", "", finished_subs)

# Are their any finished subjects with working directories still alive?    
for (i in 1:32) {
    cat(sprintf("\nNODE %i:\n", i))
    
    cat("...listing files\n")
    cmd         <- sprintf("ssh node%i ls -d /tmp/resting_preproc_00*", i)
    cat(cmd, "\n")
    paths       <- system(cmd, intern=T)
    
    node_subs   <- sub("resting_preproc_", "", basename(paths))
    node_subs   <- sub("_session_1", "", node_subs)
    
    rm_inds     <- node_subs %in% finished_subs
    if (any(rm_inds)) {
        cat(sprintf("...removing %i out of %i files\n", 
            sum(rm_inds), length(node_subs)))
        for (path in paths) {
            cmd <- sprintf("ssh node%i rm -rf %s", i, path)
            cat(cmd, "\n")
            system(cmd)
        }
    } else {
        cat(sprintf("...no files out of %i to remove\n", length(node_subs)))
    }
}

