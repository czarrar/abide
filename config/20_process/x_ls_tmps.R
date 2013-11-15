#!/usr/bin/env Rscript

# Subjects in working directories
for (i in 1:32) {
    cmd <- sprintf("ssh node%i ls -d /tmp/resting_preproc_00*", i)
    cat(cmd, "\n")
    system(cmd)
    cat("\n")
}
