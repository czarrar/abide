#!/usr/bin/env python

import os, shutil, yaml
from os import path as op
from string import Template
from glob import glob

import numpy as np
import pandas as pd


def mkdir_if_not_exists(path):
    if not op.exists(path):
        os.makedirs(path)
    return

def mkdirs_if_not_exist(*paths):
    for path in paths:
        mkdir_if_exists(path)
    return

raw_dir     = "/data/Projects/ABIDE_Initiative/CPAC/RawData"
out_dir     = "/data/Projects/ABIDE_Initiative/Outputs"

pipelines   = ["cpac", "ccs", "niak", "dparsf"]
strategies  = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_global"]
sites       = os.listdir(raw_dir)
subjects_by_sites = { site : os.listdir(op.join(raw_dir, site)) for site in sites }
subjects    = [ sub for site,sublist in subjects_by_sites.iteritems() for sub in sublist ]

def glob_and_check(inpath_raw):
    inpath = glob(inpath_raw)
    if len(inpath) == 0:
        print "Missing path for %s" % inpath_raw
        return False
    elif len(inpath) > 1:
        print "More than one path for %s" % inpath_raw
        return False
    return True

def check_subject_inputs(basedir, strat, subj, config):
    print "SUBJECT: %s" % subj
    
    file_folders = ["anat", "reg", "func", "derivatives"]
    
    # Setup template variables
    subj_templ = templ_vars.copy()
    subj_templ['subject'] = subj
    
    # Save info on files
    file_status = {}
    
    for folder in file_folders:
        print "..%s" % folder
                        
        for outprefix,inpath_raw in config[folder].iteritems():
            if isinstance(inpath_raw, dict):
                inpath_raw = inpath_raw[strat]
            
            outext = op.splitext(inpath_raw)[1][1:]
            
            # This is dealt with specially
            # as there can be many of these
            if outprefix == "roi_timeseries":
                for roi_name in subj_templ['roi_names']:
                    subj_templ['roi_name'] = roi_name               # add the roi name
                    inpath = Template(inpath_raw).safe_substitute(subj_templ) # substitute the template variables
                    is_exist = glob_and_check(inpath)
                    file_status["%s_%s" % (outprefix, roi_name)] = is_exist
            else:
                inpath = Template(inpath_raw).safe_substitute(subj_templ) # substitute
                is_exist = glob_and_check(inpath)
                file_status[outprefix] = is_exist
            
    return file_status
    
# Testing
config      = yaml.load(file('10_copy.yml', 'r'))
templ_vars  = config['vars']
res = check_subject_inputs(op.join(out_dir, pipelines[0]), strategies[0], subjects[0], config)


empty_data = np.zeros((len(subjects), len(res.keys())))
many_dfs = {}


for pipeline in pipelines:
    pipe_dir = op.join(out_dir, pipeline)
    mkdir_if_not_exists(pipe_dir)
    

    

for strategy in strategies:
    print "Strategy: %s" % strategy
    #strat_dir = op.join(out_dir, strategy)
    #mkdir_if_not_exists(strat_dir)
    
    df = pd.DataFrame(data=empty_data[:], index=subjects, columns=res.keys())
    
    for i,subj in enumerate(subjects):
        res = check_subject_inputs(op.join(out_dir, pipelines[0]), strategy, subj, config)
        df.ix[i,:] = res.values()
    
    many_dfs[strategy] = df        


    
    
    
    
    
    
    

def copy_subject_data(basedir, strat, subj, config):
    print "SUBJECT: %s" % subj
    
    file_folders = ["anat", "reg", "func", "derivatives"]
    
    subj_dir = op.join(basedir, strat, subj)
    mkdir_if_not_exists(subj_dir)
    
    # Setup template variables
    subj_templ = templ_vars.copy()
    subj_templ['subject'] = subj
    
    # Save all files to be copied
    files_to_copy = {}
    
    for folder in file_folders:
        print "..%s" % folder
        files_to_copy[folder] = []
        
        folder_dir = op.join(subj_dir, folder)
        mkdir_if_not_exists(folder_dir)
                
        for outprefix,inpath_raw in config[folder].iteritems():
            if isinstance(inpath_raw, dict):
                inpath_raw = inpath_raw[strat]
            
            outext = op.splitext(inpath_raw)[1][1:]
            
            # This is dealt with specially
            # as there can be many of these
            if outprefix is "roi_timeseries":
                for roi_name in templ_vars['roi_names']:
                    # Generate input and output paths
                    subj_templ['roi_name'] = roi_name               # add the roi name
                    inpath = Template(inpath_raw).safe_substitute(subj_templ) # substitute the template variables
                    inpath = glob(inpath)
                    outpath = op.join(folder_dir, "%s_%s.%s" % (outprefix, roi_name, outext))
                    files_to_copy[folder].append((inpath, outpath)) # save inputs and outputs
            else:
                inpath = Template(inpath_raw).safe_substitute(subj_templ) # substitute
                inpath = glob(inpath)
                outpath = op.join(folder_dir, "%s.%s" % (outprefix, outext))
                files_to_copy[folder].append((inpath, outpath))     # save
            
    return files_to_copy

print "...copying %s -> %s" % (inpath, outpath)
shutil.copy2(inpath, outpath)


