---
layout: post
title: "Simplistic QuickPAC"
description: "Updating CPAC to allow usage of data outside of the working directory for analysis"
category: "CPAC"
tags: []
---
{% include JB/setup %}

For the ABIDE dataset, we want to use a temporary working directory and split up preprocessing from the derivative generation. Currently, CPAC requires prior working directory output to run any subsequent steps. That is if you want to run REHO and have deleted the working directory, currently you can't use already output functional 4D data as input to the REHO processing.

To be able to do this easily, Cameron and I discussed a fairly viable solution. [TODO: describe that approach here]

My first step here is if a user specifies the pattern for the output, then I can go and generate the subject file list.

# Generating QuickPAC subject list


What is my focus now? Can I parse some input glob-type expression to get a list of directories for each subject and per scan or what not.

/home/data/Projects/ABIDE_Initiative/CPAC/Output/sym_links/pipeline_HackettCity/$strategy/$subject/$scan/.../file.nii.gz

strategy: *
subject: *_session_1
scan: scan_*

So now when I get the list of all possible files, I want to get the strategies, the subjects, and the scans. Or may just parse for each file, those three variables. Let's think of the simpler strategy of doing it for just one path. So say that I have the path: `/home/data/Projects/ABIDE_Initiative/CPAC/Output_20130710/sym_links/pipeline_HackettCity/_compcor_ncomponents_5_linear1.motion1.quadratic1.compcor1.CSF_0.98_GM_0.7_WM_0.98/0050026_session_1/scan_rest_1_rest/func/functional_nuisance_residuals.nii.gz`. I would compare this with the glob-like expression: `/home/data/Projects/ABIDE_Initiative/CPAC/Output/sym_links/pipeline_HackettCity/$strategy/$subject/$scan/func/functional_nuisance_residuals.nii.gz`. If I split the glob-like expression by the folder (i.e. '/'), and I would eat up anything that isn't a $ expression. When I get to the dollar expression, then I would use it's value, in this case * and match it? or maybe to keep it simple just have it be whatever's left? That would then satisfy the goal of having those three variables.

Ok so now that I'm thinking about this, I feel like the first step would be to set it up to easily use some pre-prepared file. Then it would create the inputs. So I could give it 

---

Goals for today:
- Get the preprocessing done
	(but I'm waiting on the registration to work and some symlinks to work)
- Get the code of quickpak to run somewhat
- Go back to testing code for integrating CPAC with CWAS
- Mention did to cameron next week

So it's 2:30 now and I'm looking to get out around 7. Let's say:

2:30 - 3:30 : code some stuff with quickpak
		this went a bit longer than i thought
3:30 - 4:30 : testing (focus on something specific)
		started this at 4:06. now it's 4:27 and have made some progress on getting the test code to rocky for testing.

4:30 - 5:00 : break / account for previous wasted time
5:00			  : check on preprocessing
5:15 - 7:00 : continue to work on quick pack


funcFlow = create_func_datasource(sub_dict['rest'], 'func_gather_%d' % num_strat)   # replace sub_dict['rest'] with something else
                                                   # and replace func_gather_%d with I guess this workflow or maybe with functional_mni?
funcFlow.inputs.inputnode.subject = subject_id

node     = funcFlow
out_file = 'outputspec.rest'

strat_initial.set_leaf_properties(anat_flow, 'outputspec.anat')
strat.update_resource_pool({'anatomical_brain':(anat_preproc, 'outputspec.brain')})
strat.update_resource_pool({'anatomical_reorient':(anat_preproc, 'outputspec.reorient')})



# We assume that the sub_dict, which is a key-value pair where the values are generally paths to functional files, has a key that is desired
sub_dict['nuisance']


# for ALFF: need functional_brain_mask, and the nuisance output
# for VMHC: need nuisance output and functional_to_anat_linear_xfm and functional_brain_mask, anatomical_brain, and anatomical_reorient
# for REHO: need nuisance output
# transform: functional_to_anat_linear_xfm, anatomical_to_mni_nonlinear_xfm, falff_Z_img, functional_to_anat_linear_xfm, anatomical_to_mni_nonlinear_xfm
# transform: functional_brain_mask_to_standard

# other spatial regression: functional_mni...

# functional_mni

Ok so I will have a file similar to CPAC_subject_list.yml but in addition to anat and rest, I would have relevant intermediate output files (e.g., functional_mni). This file is loaded as a dictionary by CPAC and thus it can easily be accessed from within the prep workflow script. A couple of possibilities exist to load these paths.

1. They can all be loaded at once into the strat resource pool.
2. Paths for a particular resource can be loaded at the point that the resource is created with some workflow. This is likely more ideal since there are a few instances where strat.set_leaf_properties is applied (e.g., after nuisance) and then this leaf is used downstream by another workflow. As you mentioned, the code would first check if the resource is in the sub_dict and if it exists, it will use that resource instead of running the whole workflow for it. The resource will be loaded as a datasource and with the create_func_datasource function already in CPAC.

Later when the the resource is fetched via the strategy class (strat variable), it is agnostic to the node related to that resource (e.g., if it is from a workflow or a datasource).

