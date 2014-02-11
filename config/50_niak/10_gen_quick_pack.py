#!/usr/bin/env python

"""
Here I'll take a CPAC sym_links path and just extract the relevant pieces for a quickpak yaml file.

For this example, I'll be using the ldopa output in part because it has two scans so it can test me more.

/home2/data/PreProc/LDOPA/sym_links/pipeline_0/_compcor_ncomponents_5_linear1.motion1.compcor1.CSF_0.98_GM_0.7_WM_0.98/s1_/scan_placebo_func


INPUT:  /home2/data/PreProc/LDOPA/sym_links/pipeline_0/_compcor_ncomponents_5_linear1.motion1.compcor1.CSF_0.98_GM_0.7_WM_0.98/s1_/scan_ldopa_func/func/bandpass_freqs_0.01.0.1/functional_mni.nii.gz


OUTPUT:            
functional_mni:
    placebo_func: '/home2/data/Originals/LDOPA/s10/placebo/func.nii.gz',
    ldopa_func: '/home2/data/Originals/LDOPA/s10/ldopa/func.nii.gz',
    
"""

import os
import yaml
from collections import OrderedDict
from os import path as op
from glob import glob
from copy import deepcopy


###
# Set Suffixes
###

## Some Details
# Note that the value is the path within the subject scan directory
# This subpath can be a string or a string with glob expressions or a list of the previous two
# 
# Multiple paths cannot exist for now.
# This means that for a glob expression, only one path can come out.
# And for a list only one of the elements in the list can be a path that exists.
# 
# If a path that exists is found, it will then be used
##

anat_suffixes = {
#    "anatomical_brain": "mprage_sanlm.nii.gz",          # REGISTRATION
#    "anatomical_reorient": "reg/highres_rpi.nii.gz",    # VMHC?
#    "anatomical_to_mni_nonlinear_xfm": "reg/highres2standard_warp.nii.gz",  # REGISTRATION
#    "mni_normalized_anatomical": "reg/fnirt_highres2standard.nii.gz",      # NOT NEEDED
}

# Note that the native space and standard space paths repeat
# they are both in standard space
func_suffixes = {
#    "preprocessed": "rest_res.nii.gz",             # NOT NEEDED
#    "mean_functional": "rest_pp_mean.nii.gz",      # VMHC?
    "functional_brain_mask": "fmri_%(subject)s_session_1_%(scan)s_mask.nii.gz", # YES 
    "functional_nuisance_residuals": "fmri_%(subject)s_session_1_%(scan)s.nii.gz",  # YES (although not really used)
    "functional_freq_filtered": "fmri_%(subject)s_session_1_%(scan)s.nii.gz",    # YES
    "functional_mni": "fmri_%(subject)s_session_1_%(scan)s.nii.gz",      # YES
    "functional_brain_mask_to_standard": "fmri_%(subject)s_session_1_%(scan)s_mask.nii.gz" # Yes
}

reg_suffixes = {
#    "functional_to_anat_linear_xfm": "reg/example_func2highres.mat" # REGISTRATION 
#    "functional_to_mni_linear_xfm": "functional_to_mni_linear_xfm.mat"
}



# Base output directory
base_dir        = "/home2/data/Projects/ABIDE_Initiative/NIAK/processed"
pipelines       = { "nofilt": "nolp", "filt": "lp01" }
strategies      = { "noglobal": "gsc0", "global":  "gsc1" }

# CPAC subject list
subject_file    = "start_CPAC_subject_list.yml"
sub_dict        = yaml.load(open(subject_file, 'r'))
#scans           = [ k.replace("_rest", "") for k in sub_dict[0]['rest'].keys() ]
scans           = ["run1"]    # although they processed data for run2 and run3, we won't here for now.


def build_file_path(init_dir, path_suffixes, templ):
    # Iterate through path suffixes, only keeping paths that exist
    if not isinstance(path_suffixes, list):
        path_suffixes = [path_suffixes]
    file_path = []
    for path_suffix in path_suffixes:
        if path_suffix:
            file_path = file_path + glob(op.join(init_dir, path_suffix % templ))

    if len(file_path) > 1:
        print "\nWARNING: Currently only one file for '%s' is supported" % file_path
        print "CHOOSING first one '%s'\n" % file_path[0]
        file_path = file_path[0]
    elif len(file_path) == 0:
        file_path = ""
    else:
        file_path = file_path[0]
    
    if file_path == "":
        print "\nWARNING: file_path is empty", path_suffixes, "\n"
    
    return file_path


# Let's do a first pass to check if the subject data
filt_sub_dict   = []  # this is the list of subjects that we use for the quick-pack
bad_subs        = []
scan            = scans[0]
for orig_sub_resources in sub_dict:     # SUBJECT (MEAT)
    sub_resources = deepcopy(orig_sub_resources)
    print "\n\t\t\t" + sub_resources['subject_id']
    
    sub_files = glob(op.join(base_dir, "*", "*", "fmri_%s_session_1_run1.nii.gz" % sub_resources['subject_id']))
    
    if len(sub_files) == 4:
        sub_file = sub_files[0]
    else:
        print "ERROR: subdir %s doesn't exist" % sub_resources['subject_id']
        print "found %i" % len(sub_files)
        bad_subs.append(sub_resources['subject_id'])
        continue
    
    # Good
    print "...good"
    filt_sub_dict.append(sub_resources)

ofile = 'subs_exclude.yml'
with open(ofile, 'w') as yaml_file:
    yaml_file.write( yaml.dump(bad_subs) )


print
print "===== DONE CHECKING SUBJECTS ====="
print

# Loop through the different scans, pipelines, and strategies
# Generate a seperate yml file for each
# Now get the data in each subject's directory
templ = {}
for si,scan in enumerate(scans):                    # SCAN
    print "scan", scan
    templ["scan"] = scan
    
    for plabel,pipe in pipelines.iteritems():       # PIPELINE
        print "\tpipeline", plabel, pipe
        templ["pipeline"] = pipe
        
        for slabel,strat in strategies.iteritems(): # STRATEGY
            print "\t\tstrategies", slabel, strat
            templ["strategy"] = strat
            
            resources = []
            
            for orig_sub_resources in filt_sub_dict:     # SUBJECT (MEAT)
                sub_resources = deepcopy(orig_sub_resources)
                print "\n\t\t\t" + sub_resources['subject_id']
                templ["subject"] = sub_resources['subject_id']
                
                sub_file = glob(op.join(base_dir, "abide_release_%(strategy)s_%(pipeline)s" % templ, "*", "fmri_%(subject)s_*_run1.nii.gz" % templ))
                if len(sub_file) == 1:
                    sub_dir = op.dirname(sub_file[0])
                else:
                    print "ERROR: subdir %s doesn't exist" % sub_resources['subject_id']
                    continue
                                
                # Paths for each functional file
                for key,path_suffixes in func_suffixes.iteritems():
                    if key not in sub_resources:
                        sub_resources[key] = {}
                    sub_resources[key][scan] = build_file_path(sub_dir, path_suffixes, templ)
                
                resources.append(sub_resources)
            
            # Save resources into yaml file
            ofile = 'quick_pack_%s_%s_%s.yml' % (scan, plabel, slabel)
            with open(ofile, 'w') as yaml_file:
                yaml_file.write( yaml.dump(resources) )
            
            print "\t\t\twrote file", ofile, "\n"
