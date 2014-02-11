#!/usr/bin/env python

from __future__ import print_function

import os, yaml
from os import path as op

def run(cmd):
    print(cmd)
    os.system(cmd)

# First read in a quick pack file with all the paths
fn      = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/config/50_niak/quick_pack_run1_nofilt_noglobal.yml"
subinfo = yaml.load(open(fn, 'r'))

# Second extract path to masks in standard space
masks   = [ si['functional_brain_mask_to_standard']['run1'] for si in subinfo ]
for mask in masks:
    if not op.exists(mask):
        print("missing: %s" % mask)

# Third combine the masks
cmd     = "fslmerge -t combined_masks.nii.gz %s" % ' '.join(masks)
print(cmd, file=open("tmp.cmd", "w")) # for some reason, running it directly doesn't work
run("bash tmp.cmd")

# Fourth get a 90% and 100% masks
odir    = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"
cmd     = "fslmaths combined_masks.nii.gz -Tmean -thr 0.9 -bin %s/mask_niak_90percent.nii.gz" % odir
run(cmd)
cmd     = "fslmaths combined_masks.nii.gz -Tmean -thr 1 -bin %s/mask_niak_100percent.nii.gz" % odir
run(cmd)

# Fifth get the grey matter mask into the same space as niak's data
odir    = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"
cmd     = "cd %s; 3dresample -input MNI152_T1_GREY_3mm_25pc_mask.nii.gz -master mask_niak_90percent.nii.gz -prefix MNI152_T1_GREY_3mm_25pc_mask_niak.nii.gz -rmode NN" % odir
run(cmd)

# Fifth combine that mask with the grey matter
odir    = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks"
cmd     = "cd %s; fslmaths %s -mas %s %s" % (odir, "mask_niak_90percent.nii.gz", "MNI152_T1_GREY_3mm_25pc_mask_niak.nii.gz", "mask_niak_90percent_gm.nii.gz")
run(cmd)
cmd     = "cd %s; fslmaths %s -mas %s %s" % (odir, "mask_niak_100percent.nii.gz", "MNI152_T1_GREY_3mm_25pc_mask_niak.nii.gz", "mask_niak_100percent_gm.nii.gz")
run(cmd)
