#!/usr/bin/env python

in_base     = "/data/Projects/ABIDE_Initiative/Derivatives/DPARSF"
out_base    = "/data/Projects/ABIDE_Initiative/DPARSF/ReNormalize"

import os
from os import path as op
from glob import glob

def mkdir_if_not_exists(path):
    if not op.exists(path):
        os.makedirs(path)
    return

def rm_if_exists(path):
    if op.exists(path):
        os.remove(path)
    return

def glob_and_check(inpath_raw):
    inpath = glob(inpath_raw)
    if len(inpath) == 0:
        print "Missing path for %s" % inpath_raw
        return False
    elif len(inpath) > 1:
        print "More than one path for %s" % inpath_raw
        return False
    return True


part_paths = {
    "alff": "alff_Z_img/*/*/*hp*/*lp*/*.nii.gz", 
    "falff": "falff_Z_img/*/*/*hp*/*lp*/*.nii.gz", 
    "dual_regression": "dr_tempreg_maps_z_stack/*/*/_spatial_map_PNAS_Smith09_rsn10/*/*/*.nii.gz", 
    "reho": "reho_Z_img/*/*/*.nii.gz"
}

pipelines   = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]

raw_dir     = "/data/Projects/ABIDE_Initiative/CPAC/RawData"
sites       = os.listdir(raw_dir)
subjects_by_sites = { site : os.listdir(op.join(raw_dir, site)) for site in sites }
subjects    = [ sub for site,sublist in subjects_by_sites.iteritems() for sub in sublist ]

# Create output directories
for pipeline in pipelines:
    pipe_dir = op.join(out_base, "Results_%s" % pipeline)
    mkdir_if_not_exists(pipe_dir)
    for name in part_paths.keys():
        out_dir = op.join(pipe_dir, name)
        mkdir_if_not_exists(out_dir)

# Record any bad subjects
f = open('z_badsubs_soft_link.txt','w')

# Copy files
for pipeline in pipelines:
    print "PIPELINE: %s" % pipeline
    f.write("PIPELINE: %s\n" % pipeline)
    for subject in subjects:
        print "subject: %s" % subject
        
        for name,part_path in part_paths.iteritems():
            in_path     = op.join(in_base, "Output/pipeline_%s/%s_session_1" % (pipeline, subject), part_path)
            out_path    = op.join(out_base, "Results_%s" % pipeline, name, "Sub_%s_%s.nii" % (subject, name))
            raw_cmd     = "3dcopy %s %s"
            
            if glob_and_check(in_path):
                in_path = glob(in_path)[0]
                rm_if_exists(out_path)
                os.system(raw_cmd % (in_path, out_path))
            else:
                print "- missing subject %s with %s: %s" % (subject, name, in_path)
                f.write("%s - %s - %s\n" % (subject, name, in_path))
    
    f.write("\n")
    print ""


f.close()