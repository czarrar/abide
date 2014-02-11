#!/usr/bin/env Rscript

# Subjects in working directories
for (i in 17:32) {
    cmd <- sprintf("ssh node%i ls /tmp/dparsf", i)
    cat(cmd, "\n")
    tmpdirs <- system(cmd, intern=T)
    
    n <- length(tmpdirs)
    cat("number of directories to remove:", n, "\n")
    
    if (n > 0) {
        cmd <- sprintf("ssh node%i rm -r /tmp/dparsf", i)
        cat(cmd, "\n")
        system(cmd)
    }
}
