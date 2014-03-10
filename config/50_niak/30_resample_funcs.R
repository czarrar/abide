#!/usr/bin/env Rscript

library(plyr)

# This script will look at every NIAK scan and resample each to the FSL MNI space

inbase  <- "/home2/data/Projects/ABIDE_Initiative/NIAK/processed"
outbase <- "/home2/data/Projects/ABIDE_Initiative/NIAK/resampled"
master  <- "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/for_grant/rois/standard_3mm.nii.gz"

###
# First let's create a duplicate directory structure
###

# Get some variables like strategy and site folder names
strats  <- list.files(inbase)
sites   <- list.files(file.path(inbase, strats[1]))

# Now create the different directories
l_ply(strats, function(strat) {
    dir.create(file.path(outbase, strat), showWarnings=F)
    l_ply(sites, function(site) {
        dir.create(file.path(outbase, strat, site), showWarnings=F)
    })
}, .progress="text")


###
# Second let's gather the input directory paths
###

infiles     <- Sys.glob(file.path(inbase, "*", "*", "*mask*.nii.gz"))
#infiles     <- Sys.glob(file.path(inbase, "*", "*", "*.nii.gz"))
outfiles    <- sub(inbase, outbase, infiles)
n           <- length(infiles)


###
# Third let's do the resampling
###

#l_ply(1:n, function(i) {
#    raw_cmd <- "3dresample -input %s -master %s -prefix %s -rmode NN"
#    cmd     <- sprintf(raw_cmd, infiles[i], master, outfiles[i])
#    cat(cmd, "\n")
#    system(cmd)
#}, .progress="text")

# can do it via SGE!!!
to.force    <- TRUE

dir.create("sge", showWarnings=F)
dir.create("sge/scripts", showWarnings=F)
dir.create("sge/logs", showWarnings=F)

# Create and run all the qsubs
for (i in 1:n) {
    # check input
    if (!file.exists(infiles[i])) {
        cat("Input path", infiles[i], "doesn't exist\n")
        stop("error")
    }
    
    # check output
    if (file.exists(outfiles[i])) {
        if (to.force) {
            cat("Output path", outfiles[i], "already exists...removing!\n")
            file.remove(outfiles[i])
        } else {
            cat("Output path", outfiles[i], "already exists...skipping\n")
            next
        }
    }
    
    prefix  <- sprintf("resample_funcs_%04i", i)
    
    lfn     <- sprintf("sge/logs/%s.log", prefix)
    sfn     <- sprintf("sge/scripts/%s.bash", prefix)
    
    raw_cmd <- "3dresample -input %s -master %s -prefix %s -rmode NN"
    cmd     <- sprintf(raw_cmd, infiles[i], master, outfiles[i])
        
    cat(
        "#!/usr/bash", 
        "", 
        paste("echo", cmd), 
        cmd, 
        sep="\n", 
        file=sfn
    )
    
    qcmd    <- sprintf("qsub -S /bin/bash -V -cwd -o %s -j y %s", lfn, sfn)
    cat(qcmd, "\n")
    system(qcmd)
}


