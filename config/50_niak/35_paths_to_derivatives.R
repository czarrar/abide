#!/usr/bin/env Rscript

library(plyr)

# This script will resample each of the derivatives

derivs          <- c("falff", "reho", "dual_regression", "degree_centrality")
deriv_folders   <- c("falff_Z_img", "reho_Z_img", "dr_tempreg_maps_z_files.*0003", "centrality_outputs_zscore.*weighted")

strats          <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")

inbase          <- "/data/Projects/ABIDE_Initiative/Derivatives/NIAK/Output"
inbase2         <- "/home2/data/Projects/ABIDE_Initiative/Derivatives/NIAK"

# TODO: expand this list at a later time
subfile         <- "/data/Projects/ABIDE_Initiative/CPAC/abide/for_grant/zarrar_abide_sublist.txt"
subjects        <- sprintf("%07i", as.integer(read.table(subfile)[,]))

# The different items to loop through
opts            <- expand.grid(list(strats=strats, subjects=subjects, derivs=derivs))
opts$deriv_folders <- sapply(opts$derivs, function(x) deriv_folders[x == derivs])

# Loop through the different path elements
# and get the derivative file path for each set
df              <- ddply(opts, .(strats, subjects, derivs), function(opt) {
    if (opt$derivs == "degree_centrality") {
        pathdir         <- file.path(inbase2, sprintf("Cent/pipeline_%s/%s_session_1/path_files_here", opt$strats, opt$subjects))
    } else {
        pathdir         <- file.path(inbase, sprintf("pipeline_%s/%s_session_1/path_files_here", opt$strats, opt$subjects))
    }
    
    pathfiles       <- list.files(pathdir, full.names=TRUE)
    paths           <- unlist(lapply(pathfiles, function(pf) as.character(read.table(pf)[,1])))

    deriv_folder    <- deriv_folders[opt$derivs == derivs]
    deriv_path      <- paths[grep(deriv_folder, paths)]

    c(deriv_paths=deriv_path)
}, .progress="text")

# double check paths
sum(!file.exists(df$deriv_paths))   # if non-zero, houston we have a problem

# add on the outputs
df$resamp_paths <- with(df, sub(".nii.gz", "_resampled.nii.gz", deriv_paths))

# Let's save this
write.csv(df, "z_df_filepaths.csv")



#inbase  <- "/home2/data/Projects/ABIDE_Initiative/NIAK/processed"
#outbase <- "/home2/data/Projects/ABIDE_Initiative/NIAK/resampled"
#master  <- "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/for_grant/rois/standard_3mm_niak.nii.gz"
#
####
## First let's create a duplicate directory structure
####
#
## Get some variables like strategy and site folder names
#strats  <- list.files(inbase)
#sites   <- list.files(file.path(inbase, strats[1]))
#
## Now create the different directories
#l_ply(strats, function(strat) {
#    dir.create(file.path(outbase, strat), showWarnings=F)
#    l_ply(sites, function(site) {
#        dir.create(file.path(outbase, strat, site), showWarnings=F)
#    })
#}, .progress="text")
#
#
####
## Second let's gather the input directory paths
####
#
#infiles     <- Sys.glob(file.path(inbase, "*", "*", "*.nii.gz"))
#outfiles    <- sub(inbase, outbase, infiles)
#n           <- length(infiles)
#
#
####
## Third let's do the resampling
####
#
#l_ply(1:n, function(i) {
#    raw_cmd <- "3dresample -input %s -master %s -prefix %s -rmode NN"
#    cmd     <- sprintf(raw_cmd, infiles[i], master, outfiles[i])
#    cat(cmd, "\n")
#    system(cmd)
#}, .progress="text")