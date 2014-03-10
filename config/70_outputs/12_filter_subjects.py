#!/usr/bin/env ipython

import os, shutil, yaml
from os import path as op
from string import Template
from glob import glob
import pickle

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
strategies  = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
file_folders= ["func", "derivatives"]
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

def check_subject_inputs(basedir, strat, subj, site, config, templ_vars):
    import re
    
    print "SUBJECT: %s" % subj
    
    # Setup template variables
    subj_templ = templ_vars.copy()
    subj_templ['subject']   = subj
    subj_templ['site']      = site
    subj_templ['csite']     = re.sub("_[a-z1-9]$", "", site)
    subj_templ['csubject']  = str(int(subj))
    
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
print "Testing"

print "...cpac"
config      = yaml.load(file('10a_paths_cpac.yml', 'r'))
templ_vars  = config['vars']
res = check_subject_inputs(op.join(out_dir, pipelines[0]), strategies[2], subjects_by_sites['MaxMun_c'][0], 'MaxMun_c', config, templ_vars)

print "...ccs"
config      = yaml.load(file('10b_paths_ccs.yml', 'r'))
templ_vars  = config['vars']
res = check_subject_inputs(op.join(out_dir, pipelines[1]), strategies[2], subjects_by_sites['MaxMun_c'][0], 'MaxMun_c', config, templ_vars)

print "...niak"
config      = yaml.load(file('10c_paths_niak.yml', 'r'))
templ_vars  = config['vars']
res = check_subject_inputs(op.join(out_dir, pipelines[2]), strategies[2], subjects_by_sites['MaxMun_c'][0], 'MaxMun_c', config, templ_vars)

print "...dparsf"
config      = yaml.load(file('10d_paths_dparsf.yml', 'r'))
templ_vars  = config['vars']
res = check_subject_inputs(op.join(out_dir, pipelines[3]), strategies[2], subjects_by_sites['MaxMun_c'][0], 'MaxMun_c', config, templ_vars)

#import code
#code.interact(local=locals())


# Run it for all
pipeline_dfs = {}

for pipeline in pipelines:
    print "Pipeline: %s" % pipeline
    pipe_dir = op.join(out_dir, pipeline)
    mkdir_if_not_exists(pipe_dir)
    
    config      = yaml.load(file(glob('10*_paths_%s.yml' % pipeline)[0], 'r'))
    templ_vars  = config['vars']
    
    strategy_dfs = {}
    
    for strategy in strategies:
        print "Strategy: %s" % strategy
        #strat_dir = op.join(out_dir, strategy)
        #mkdir_if_not_exists(strat_dir)
        
        empty_data = np.zeros((len(subjects), len(res.keys())))
        df = pd.DataFrame(data=empty_data[:], index=subjects, columns=res.keys())
        i = 0
        
        for site,site_subjects in subjects_by_sites.iteritems():            
            templ_vars['site'] = site
    
            for j,subj in enumerate(site_subjects):
                res = check_subject_inputs(op.join(out_dir, pipeline), strategy, subj, site, config, templ_vars)
                df.ix[i,:] = res.values()
                i += 1
    
        strategy_dfs[strategy] = df
        
        print ""
    
    pipeline_dfs[pipeline] = strategy_dfs
    
    print ""

# Save
with open('z_12_filter_subjects.pickle', 'wb') as handle:
    pickle.dump(pipeline_dfs, handle)
