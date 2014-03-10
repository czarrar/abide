#!/usr/bin/env python

# This script will determine the subjects to use
# It will to so by using only those subjects that have all the required derivatives
# across everything (so they have all that it takes...hehe)

import pickle
import numpy as np

# Get all the data
many_dfs = pickle.load(open("z_12_filter_subjects.pickle"))

# Remove the following subjects (only two of them)
subjects        = many_dfs[pipelines[0]][strategies[0]].index
sublist         = yaml.load(file('../22_process_3mm/CPAC_subject_list.yml'))
tmp             = { x['subject_id'] : x['rest'].keys()[0] for x in sublist }
include_subs    = [ k for k,v in tmp.iteritems() if v == 'rest_1_rest' ]
include_inds    = np.array([ (subjects == s).nonzero()[0][0] for s in include_subs ])
for i,pipeline in enumerate(pipelines):
    for j,strategy in enumerate(strategies):
        df          = many_dfs[pipeline][strategy]
        df          = df.ix[include_inds,:]
        many_dfs[pipeline][strategy] = df


# Keys
#pipelines   = ["cpac", "ccs", "niak", "dparsf"]
pipelines   = ["cpac", "ccs", "niak"]
strategies  = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
derivatives = ["falff", "reho", "dual_regression", "degree_weighted"]

npipelines  = len(pipelines)
nstrategies = len(strategies)
nsubjects   = len(subjects)

# Get which subjects to use for each pipeline and strategy
subs_to_use = np.zeros((npipelines, nstrategies, nsubjects))
for i,pipeline in enumerate(pipelines):
    for j,strategy in enumerate(strategies):
        df          = many_dfs[pipeline][strategy][derivatives]
        inds        = df.sum(1) == 4
        subs_to_use[i,j,:] = inds
        print "%s - %s: %i / %i subject" % (pipeline, strategy, inds.sum(), df.shape[0])

# Get final list of subjects
nmax        = npipelines * nstrategies
finals      = subs_to_use.sum((0,1))
final_inds  = finals == nmax
subjects    = many_dfs[pipelines[0]][strategies[0]].index
final_subs  = subjects[final_inds]

# Save
final_subs.tofile("z_final_sublist.txt", sep="\n")
