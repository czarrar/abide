#!/usr/bin/env Rscript

# This script will run the resampling through the grid

library(plyr)

to.force    <- FALSE

master      <- "/data/Projects/ABIDE_Initiative/CPAC/abide/for_grant/rois/standard_3mm.nii.gz"

dir.create("sge", showWarnings=F)
dir.create("sge/scripts", showWarnings=F)
dir.create("sge/logs", showWarnings=F)

# Get the paths and their parts
df <- read.csv("z_df_filepaths.csv")
n  <- nrow(df)

# Create and run all the qsubs
l_ply(1:n, function(i) {
    dfi     <- df[i,]
    
    dfi$deriv_paths     <- as.character(dfi$deriv_paths)
    dfi$resamp_paths    <- as.character(dfi$resamp_paths)
    
    # check input
    if (!file.exists(dfi$deriv_paths)) {
        cat("Input path", dfi$deriv_paths, "doesn't exist\n")
        return
    }
    
    # check output
    if (file.exists(dfi$resamp_paths)) {
        if (to.force) {
            cat("Output path", dfi$resamp_paths, "already exists...removing!\n")
            file.remove(dfi$resamp_paths)
        } else {
            cat("Output path", dfi$resamp_paths, "already exists...skipping\n")
            return
        }
    }
    
    prefix  <- sprintf("resample_derivs_%s_%s_%s", dfi$strats, dfi$subjects, dfi$derivs)
    
    lfn     <- sprintf("sge/logs/%s.log", prefix)
    sfn     <- sprintf("sge/scripts/%s.bash", prefix)
    
    raw_cmd <- "3dresample -input %s -master %s -prefix %s -rmode NN"
    cmd     <- sprintf(raw_cmd, dfi$deriv_paths, master, dfi$resamp_paths)
    
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
})

