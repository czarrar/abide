#!/usr/bin/env ipython

# Horribly written script to get all the subject paths for each derivative and strategy and pipeline

import os, shutil, yaml
from os import path as op
from string import Template
from glob import glob

import numpy as np
import pandas as pd

raw_dir     = "/data/Projects/ABIDE_Initiative/CPAC/RawData"

#pipelines   = ["cpac", "ccs", "niak", "dparsf"]
pipelines   = ["cpac", "ccs", "niak"]
strategies  = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
derivatives = ["falff", "reho", "dual_regression", "degree_weighted"]
sites       = os.listdir(raw_dir)
subjects_by_sites = { site : os.listdir(op.join(raw_dir, site)) for site in sites }
subjects    = [ sub for site,sublist in subjects_by_sites.iteritems() for sub in sublist ]

def get_subject_paths(subj, derivative, config, templ_vars):
    import re
    
    #print "SUBJECT: %s" % subj
    
    # Setup template variables
    subj_templ = templ_vars.copy()
    subj_templ['subject']   = subj
    subj_templ['site']      = "*"
    subj_templ['csite']     = "*"
    subj_templ['csubject']  = str(int(subj))
    
    # Save info on files
    paths = {}
    
    for strategy,inpath_raw in config["derivatives"][derivative].iteritems():
        if isinstance(inpath_raw, dict):
            inpath_raw = inpath_raw[strat]
        
        outext  = op.splitext(inpath_raw)[1][1:]

        inpath  = Template(inpath_raw).safe_substitute(subj_templ) # substitute
        path    = glob(inpath)[0]
        if not op.exists(path):
            raise "error path: %s doesn't exist" % path
        
        paths[strategy] = path
            
    return paths

for derivative in derivatives:
    print "DERIVATIVE: %s" % derivative

    # Run it for all
    df = pd.DataFrame()

    # Subjects
    subjects = pd.read_table("z_final_sublist.txt", header=None).ix[:,0].tolist()
    subjects = [ "%07i" % s for s in subjects ]

    # Derivative
    derivative = derivatives[0]

    for pipeline in pipelines:
        print "Pipeline: %s" % pipeline
    
        config      = yaml.load(file(glob('10*_paths_%s.yml' % pipeline)[0], 'r'))
        templ_vars  = config['vars']
    
        dict_df = { k : [] for k in strategies }
    
        for subj in subjects:
            paths = get_subject_paths(subj, derivative, config, templ_vars)
            for k,v in paths.iteritems():
                dict_df[k].append(v)
    
        pipe_df  = pd.DataFrame(dict_df, columns=strategies, index=subjects)
        pipe_df['pipeline'] = pipeline
        df      = pd.concat((df, pipe_df))
    
    df.to_csv("z_paths_for_%s.csv" % derivative)
