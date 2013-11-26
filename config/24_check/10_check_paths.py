#!/usr/bin/env ipython

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
    "anatomical_brain": "anatomical_brain/mprage*.nii.gz", 
    "anatomical_reorient": "anatomical_reorient/mprage*.nii.gz", 
    "anatomical_to_mni_nonlinear_xfm": "anatomical_to_mni_nonlinear_xfm/*.nii.gz", 
    "mni_normalized_anatomical": "mni_normalized_anatomical/ants_deformed.nii.gz", 
    "ants_affine_xfm": "ants_affine_xfm/ants_Affine.txt"
}

func_suffixes = {
    "preprocessed": "preprocessed/_scan_%(scan)s/rest*.nii.gz", 
    "mean_functional": "mean_functional/_scan_%(scan)s/rest*.nii.gz", 
    "functional_brain_mask": "functional_brain_mask/_scan_%(scan)s/rest*.nii.gz", 
    "functional_nuisance_residuals": "functional_nuisance_residuals/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/residual.nii.gz", 
    "functional_freq_filtered": [
        "functional_freq_filtered/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_bandpass_freqs_*/bandpassed_demeaned_filtered.nii.gz", 
        "functional_nuisance_residuals/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/residual.nii.gz"
    ], # although this is a list only one path can exist for now
    "functional_mni": [
        "functional_mni/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/residual*.nii.gz", 
        "functional_mni/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_bandpass_freqs_*/bandpassed_demeaned_filtered*.nii.gz"
    ], 
    "functional_brain_mask_to_standard": "functional_brain_mask_to_standard/_scan_%(scan)s/rest*.nii.gz"
}

reg_suffixes = {
    "functional_to_anat_linear_xfm": "functional_to_anat_linear_xfm/_scan_%(scan)s/rest*.mat" 
#    "functional_to_mni_linear_xfm": "functional_to_mni_linear_xfm.mat"
}

derivative_suffixes = {
    "alff": "alff_Z_to_standard_smooth/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_hp_0.01/_lp_0.1/_fwhm_6/residual*.nii.gz", 
    "falff": "falff_Z_to_standard_smooth/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_hp_0.01/_lp_0.1/_fwhm_6/residual*.nii.gz", 
    "dr": [
        "dr_tempreg_maps_z_stack_to_standard/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_spatial_map_PNAS_Smith09_rsn10/*.nii.gz", 
        "dr_tempreg_maps_z_stack_to_standard/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_bandpass_freqs_*/_spatial_map_PNAS_Smith09_rsn10/*.nii.gz"
    ], 
    "reho": [
        "reho_Z_to_standard_smooth/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_fwhm_6/*.nii.gz", 
        "reho_Z_to_standard_smooth/_scan_%(scan)s/_csf_threshold_*/_gm_threshold_*/_wm_threshold_*/%(strategy)s/_bandpass_freqs_*/_fwhm_6/*.nii.gz"
    ]
}

all_suffixes = {}
all_suffixes.update(anat_suffixes)
all_suffixes.update(func_suffixes)
all_suffixes.update(reg_suffixes)
all_suffixes.update(derivative_suffixes)

# Base output directory
base_dir        = "/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-22"
pipelines       = { "nofilt": "MerrittIsland", "filt": "RameyBorough" }
strategies      = { "noglobal": "_compcor_ncomponents_5_selector_pc10.linear1.wm0.global0.motion1.quadratic1.gm0.compcor1.csf0", 
                    "global":  "_compcor_ncomponents_5_selector_pc10.linear1.wm0.global1.motion1.quadratic1.gm0.compcor1.csf0" }

# CPAC subject list
subject_file    = "CPAC_subject_list.yml"
sub_dict        = yaml.load(open(subject_file, 'r'))
scans           = sub_dict[0]['rest'].keys()


def check_file_path(init_dir, path_suffixes, templ):
    # Iterate through path suffixes, only keeping paths that exist
    if not isinstance(path_suffixes, list):
        path_suffixes = [path_suffixes]
    file_path = []
    for path_suffix in path_suffixes:
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
        file_path = op.join(init_dir, path_suffixes[0] % templ)
        file_exists = False
    else:
        file_exists = True
    
    return file_exists, file_path

# Loop through the different scans, pipelines, and strategies
# Generate a seperate yml file for each
# Now get the data in each subject's directory
templ = {}
exists = {}
paths = {}
for si,scan in enumerate(scans):                    # SCAN
    print "scan", scan
    templ["scan"] = scan
    exists[scan] = {}
    paths[scan] = {}
    
    for plabel,pipe in pipelines.iteritems():       # PIPELINE
        print "\tpipeline", plabel, pipe
        templ["pipeline"] = "pipeline_%s" % pipe
        exists[scan][plabel] = {}
        paths[scan][plabel] = {}
        
        for slabel,strat in strategies.iteritems(): # STRATEGY
            print "\t\tstrategies", slabel, strat
            templ["strategy"] = strat
            exists[scan][plabel][slabel] = {}
            paths[scan][plabel][slabel] = {}
            
            df_exists = { n : [] for n in all_suffixes.keys() }
            df_paths = { n : [] for n in all_suffixes.keys() }
            
            for orig_sub_resources in sub_dict:     # SUBJECT (MEAT)
                sub_resources = deepcopy(orig_sub_resources)
                print "\n\t\t\t" + sub_resources['subject_id']
                
                if sub_resources['unique_id']:
                    sub_dir = op.join(base_dir, templ["pipeline"], "%(subject_id)s_%(unique_id)s" % sub_resources)
                else:
                    sub_dir = op.join(base_dir, templ["pipeline"], sub_resources['subject_id'])
                
                for key,path_suffix in all_suffixes.iteritems():
                    e,p = check_file_path(sub_dir, path_suffix, templ)
                    df_exists[key].append(e)
                    df_paths[key].append(p)
            
            exists[scan][plabel][slabel] = df_exists
            paths[scan][plabel][slabel] = df_paths

# Get subject list
subs = []
for sub_resources in sub_dict:
    subs.append(sub_resources['subject_id'])

# Since there is only one scan here
if len(paths.keys()) == 1:
    print "collapsing scan"
    exists = exists[exists.keys()[0]]
    paths = paths[paths.keys()[0]]

# Convert to data frames
from pandas import DataFrame
print "saving"
for pipe in pipelines.keys():
    for strat in strategies.keys():
        DataFrame(exists[pipe][strat], index=subs).to_csv("zcheck_exists_%s_%s.csv" % (pipe,strat))
        DataFrame(paths[pipe][strat], index=subs).to_csv("zcheck_paths_%s_%s.csv" % (pipe,strat))
