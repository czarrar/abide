#!/usr/bin/env python

import os, yaml
from os import path as op

def run(cmd):
    print cmd
    os.system(cmd)

# First read in a quick pack file with all the paths
fn      = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/config/40_xinian/quick_pack_rest_1_nofilt_noglobal.yml"
subinfo = yaml.load(open(fn, 'r'))

# Second extract path to masks in standard space
masks   = [ si['functional_brain_mask_to_standard']['rest_1'] for si in subinfo ]

# Third combine the masks
cmd     = "fslmerge -t combined_masks.nii.gz %s" % ' '.join(masks)
run(cmd)

# Fourth get a 90% and 100% masks
odir    = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"
cmd     = "fslmaths combined_masks.nii.gz -Tmean -thr 0.9 %s/mask_ccs_90percent.nii.gz" % odir
run(cmd)
cmd     = "fslmaths combined_masks.nii.gz -Tmean -thr 1 %s/mask_ccs_100percent.nii.gz" % odir
run(cmd)

# Fifth combine that mask with the grey matter
odir    = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"
cmd     = "cd %s; fslmaths %s -mas %s %s" % (odir, "mask_ccs_90percent.nii.gz", "MNI152_T1_GREY_3mm_25pc_mask.nii.gz", "mask_ccs_90percent_gm.nii.gz")
run(cmd)
cmd     = "cd %s; fslmaths %s -mas %s %s" % (odir, "mask_ccs_100percent.nii.gz", "MNI152_T1_GREY_3mm_25pc_mask.nii.gz", "mask_ccs_100percent_gm.nii.gz")
run(cmd)
