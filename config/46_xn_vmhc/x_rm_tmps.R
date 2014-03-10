#!/usr/bin/env Rscript

# Subjects in working directories
for (i in 1:32) {
    cmd <- sprintf("ssh node%i ls /tmp/cpac_eigen", i)
    cat(cmd, "\n")
    system(cmd)
    
    cmd <- sprintf("ssh node%i rm -rf /tmp/cpac_eigen", i)
    cat(cmd, "\n")
    system(cmd)    
}
