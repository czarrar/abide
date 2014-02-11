#!/usr/bin/env Rscript

library(plyr)

# Functions
readfile <- function(f) {
    df <- read.csv(f)
    rownames(df) <- sprintf("%07i", as.numeric(df$X))
    df <- df[,-1]
    return(df)
}

rawfiles <- function(subs) {
    raw.paths0  <- file.path("/data/Projects/ABIDE_Initiative/CPAC/RawData", "*", subs, "session_1")
    raw.paths   <- Sys.glob(raw.paths0)
    if (length(raw.paths0) != length(raw.paths))
        stop("error")
    
    rest1.exists <- file.exists(file.path(raw.paths, "rest_1"))
    rest2.exists <- file.exists(file.path(raw.paths, "rest_2"))
    rest3.exists <- file.exists(file.path(raw.paths, "rest_3"))
    
    df.raw <- data.frame(
        rest1=rest1.exists*1, rest2=rest2.exists*1, rest3=rest3.exists*1, 
        row.names=subs
    )
    
    return(df.raw)
}

# Basics
strats    <- c("filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal")


###
# Check if missing raw data
###

ret <- llply(strats, function(strat) {
    df.exists <- readfile(sprintf("zcheck_exists_%s.csv", strat))
    df.paths  <- readfile(sprintf("zcheck_paths_%s.csv", strat))

    subs      <- rownames(df.exists)
    df.raw    <- rawfiles(subs)

    missing_subs  <- subs[df.raw$rest1 == 0]
    
    return(missing_subs)
})
print(ret)
# "0050155" "0050165"


###
# Check for subjects with missing functional outputs
###

ret <- llply(strats, function(strat) {
    df.exists <- readfile(sprintf("zcheck_exists_%s.csv", strat))
    df.paths  <- readfile(sprintf("zcheck_paths_%s.csv", strat))

    subs      <- rownames(df.exists)
    df.raw    <- rawfiles(subs)

    bad_subs  <- subs[df.exists$functional_mni == 0 & df.raw$rest1 == 1]
    
    return(bad_subs)
})
print(ret)
# This one subject has bad functional data...should re-run
# 0051275


###
# Check Scans 2 and 3
###

ret2 <- llply(strats, function(strat) {
    df.exists <- readfile(sprintf("zcheck_exists_%s.csv", strat))
    df.paths  <- readfile(sprintf("zcheck_paths_%s.csv", strat))

    subs      <- rownames(df.exists)
    df.raw    <- rawfiles(subs)
    
    paths2    <- sub("rest_1_rest", "rest_2_rest", as.character(df.paths$functional_mni))
    exists2   <- file.exists(Sys.glob(dirname(dirname(dirname(paths2)))))

    bad_subs2 <- subs[df.raw$rest2 == 1 & !exists2]
    
    return(bad_subs2)
})
print(ret2)

ret3 <- llply(strats, function(strat) {
    df.exists <- readfile(sprintf("zcheck_exists_%s.csv", strat))
    df.paths  <- readfile(sprintf("zcheck_paths_%s.csv", strat))

    subs      <- rownames(df.exists)
    df.raw    <- rawfiles(subs)
    
    paths3    <- sub("rest_1_rest", "rest_3_rest", as.character(df.paths$functional_mni))
    exists3   <- file.exists(exists3)

    bad_subs3 <- subs[df.raw$rest3 == 1 & !exists3]
    
    return(bad_subs3)
})
print(ret3)
