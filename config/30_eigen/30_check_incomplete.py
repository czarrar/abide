#!/usr/bin/env python

# This script will determine the subjects to use
# It will to so by using only those subjects that have all the required derivatives
# across everything (so they have all that it takes...hehe)

import pickle, yaml
import numpy as np
import pandas as pd

###
# Setup
###

# Get all the data
many_dfs = pickle.load(open("../70_outputs/z_12_filter_subjects.pickle"))

# Keys
pipelines   = ["cpac"]
#pipelines   = ["cpac", "ccs", "niak"]
strategies  = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
derivatives = ["falff", "reho", "dual_regression", "degree_weighted"]
subjects    = many_dfs[pipelines[0]][strategies[0]].index

npipelines  = len(pipelines)
nstrategies = len(strategies)
nsubjects   = len(subjects)

# Remove the following subjects (only two of them)
sublist         = yaml.load(file('../22_process_3mm/CPAC_subject_list.yml'))
tmp             = { x['subject_id'] : x['rest'].keys()[0] for x in sublist }
include_subs    = [ k for k,v in tmp.iteritems() if v == 'rest_1_rest' ]
include_inds    = np.array([ (subjects == s).nonzero()[0][0] for s in include_subs ])
for i,pipeline in enumerate(pipelines):
    for j,strategy in enumerate(strategies):
        df          = many_dfs[pipeline][strategy]
        df          = df.ix[include_inds,:]
        many_dfs[pipeline][strategy] = df
subjects        = many_dfs[pipelines[0]][strategies[0]].index


###
# CPAC
###

cpac_df     = many_dfs["cpac"]
cpac_summary= { strat : df.sum(0) for strat,df in cpac_df.iteritems() }
cpac_summary= pd.DataFrame(cpac_summary)

# I know that the eigenvector business is messed up for all the strategies
# let's get those subjects
all_subs = []
for strat,df in cpac_df.iteritems():
    all_subs += subjects[df.eigenvector_binarize == 0]
subs_redo = np.unique(all_subs)

# With the list of subjects in hand, we'll redo them
new_sublists = []
for strat in strategies:
    print "strategy: %s" % strat
    
    # Read in the current subject list
    print "...reading"
    sublist_file    = "../28_centrality/quick_pack_rest_1_rest_%s.yml" % strat
    with open(sublist_file, 'r') as f:
        sublist         = yaml.load(f)
    
    # Generate the new list of subjects to re-run
    print "...generating"
    new_sublist     = [ s for s in sublist if s['subject_id'] in subs_redo ]
    
    # Save the new subject list
    print "...saving"
    new_sublist_file = "quick_pack_missing_eigen_%s.yml" % strat
    with open(new_sublist_file, 'w') as f:
        yaml.dump(new_sublist, f)
    
    new_sublists.append(new_sublist)
