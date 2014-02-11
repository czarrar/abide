#!/usr/bin/env Rscript

# Subjects in working directories
for (i in 1:32) {
    cmd <- sprintf("ssh node%i ls /tmp", i)
    cat(cmd, "\n")
    tmpdirs <- system(cmd, intern=T)
    tmpdirs <- tmpdirs[grep("resting_preproc", tmpdirs)]
    
    n <- length(tmpdirs)
    cat("number of directories to remove:", n, "\n")
    
    if (n > 0) {
        for (tmpdir in tmpdirs) {
            cmd <- sprintf("ssh node%i rm -r /tmp/%s", i, tmpdir)
            cat(cmd, "\n")
            system(cmd)
        }
    }
}
