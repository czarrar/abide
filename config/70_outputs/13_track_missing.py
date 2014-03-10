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
many_dfs = pickle.load(open("z_12_filter_subjects.pickle"))

# Keys
pipelines   = ["cpac", "ccs", "niak", "dparsf"]
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


###
# CPAC
###

cpac_df     = many_dfs["cpac"]
cpac_summary= { strat : df.sum(0) for strat,df in cpac_df.iteritems() }
cpac_summary= pd.DataFrame(cpac_summary)

## So we can see that everything is good for all the other derivatives
## we only need to redo some of the eigenvector centralities


###
# CCS
###

ccs_df     = many_dfs["ccs"]
ccs_summary= { strat : df.sum(0) for strat,df in ccs_df.iteritems() }
ccs_summary= pd.DataFrame(ccs_summary)

## Everyone is missing some subjects but I wonder if those were just not
## analyzed (I think it was bad)?


###
# NIAK
###

niak_df     = many_dfs["niak"]
niak_summary= { strat : df.sum(0) for strat,df in niak_df.iteritems() }
niak_summary= pd.DataFrame(niak_summary)

## Everything is almost there for everyone
## There are some eigenvector missing for filt_global and filt_noglobal


###
# DPARSF
###

dparsf_df     = many_dfs["dparsf"]
dparsf_summary= { strat : df.sum(0) for strat,df in dparsf_df.iteritems() }
dparsf_summary= pd.DataFrame(dparsf_summary)

## Two of the files appear to be missing but I think that's because they are the functionals
## I will still need to make sure they are in the proper location as we will need them in
## the outputs
## Also for nofilt_global, we are missing eigenvector and degree centrality for four subjects

