library(testthat)
suppressPackageStartupMessages(library(niftir))

compare_nonzeros <- function(msg, ref.file, comp.file) {
    test_that(msg, {
        ref.img     <- read.nifti.image(ref.file)
        comp.img    <- read.nifti.image(comp.file)
        
        ref.mask    <- ref.img!=0
        comp.mask   <- comp.img!=0
        
        expect_that(ref.mask, equals(comp.mask))
    })
}

compare_3D_brains <- function(msg, ref.file, comp.file) {
    test_that(msg, {
        ref.img     <- read.nifti.image(ref.file)
        comp.img    <- read.nifti.image(comp.file)
        expect_that(ref.img, equals(comp.img))
    })
}