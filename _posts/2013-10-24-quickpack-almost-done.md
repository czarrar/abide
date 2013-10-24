---
layout: post
title: "QuickPack Almost Done"
description: ""
category: "cpac"
tags: [cpac, quickpack, code]
---
{% include JB/setup %}

# Recap

So from the other day, I was able to get ALFF/fALFF working with QC turned off. Now let me try reho.

# REHO

## 1st Attempt

First run got an error of course.

	from nipype.utils.filemanip import loadflat
	crashinfo = loadflat('/home2/data/Projects/ABIDE_Initiative/CPAC/test_qp/crash/crash-20131024-150154-milham-reho_map.a0.a0.npz')
	crashinfo['node'].run()

The error is related to reno map and need more than 3 values to unpack in line 55 of `compute_reho`. If we look at the inputs:

	crashinfo['node'].inputs.in_file

Then it seems that the `functional_brain_mask_to_standard.nii.gz` (a 3D image) is being input when it should be a 4D functional image such as `functional_mni.nii.gz`. This leads to a failure later when the shape of the input image is expected to have 4 dimensions but instead gets 3 with the mask.

So investigating the input to reho in `cpac_pipeline.py`, we see that it calls the following command that gets whatever the last node was saved:

	node, out_file = strat.get_leaf_properties()
	workflow.connect(node, out_file,
		reho, 'inputspec.rest_res_filt')

Whoops seems like a coding error in my part where the brain mask was being set as the leaf but shouldn't be.

## 2nd Attempt

This ran through without issue but the REHO maps weren't transformed to standard space. This is because the run register option is off. As a workaround, I'm creating another auto-set apply register option. This is the same thing I did with ALFF. It's possible that I should include the apply register option into the config file instead of always assuming you want to apply it. I also change this for all the other derivates (i.e., use an apply register option).

## QC Fix 

Cameron suggested to gravely continue after a failure in QC when running quick pack. Looking at the offending code again with this mindset, I realize that this approach could easily work. The following two lines get called to help create the html page which throw an error message:

	meanFD, meanDvars = get_power_params(qc_path, file_)
	mean_rms, max_rms = get_motion_params(qc_path, file_)

Those variables are then used in the html pages to indicate motion values. Since I haven't actually re-run preprocessing or given it those values, an error is thrown. To get around this, I put a try/except statement and when an exception is thrown I set all the values to 'NA'.

Excellent! The QC page looks good when running it now for REHO! Gives the REHO maps and a histogram!

