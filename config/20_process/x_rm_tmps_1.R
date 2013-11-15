#!/usr/bin/env Rscript

# Subjects in working directories
for (i in 1:16) {
    cmd <- sprintf("ssh node%i ls -d /tmp/resting_preproc_00*", i)
    cat(cmd, "\n")
    system(cmd)
    
    cmd <- sprintf("ssh node%i rm -rf /tmp/resting_preproc_00*", i)
    cat(cmd, "\n")
    system(cmd)
}
