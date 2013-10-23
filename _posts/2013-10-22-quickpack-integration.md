---
layout: post
title: "QuickPack Integration"
description: "Continued to work on integrating a simplistic version of quick pack into CPAC."
category: "cpac"
tags: [cpac, quickpack]
---
{% include JB/setup %}

# Quick Pack Integration

## Background

Yesterday, I copied over the most recent version of `cpac_pipeline.py`. So today I can integration some code to call datasource nodes to pull the previously run files.

## Integration in Pipeline

It would be nice if the anatomical registration section was a little streamlined. I am not sure why 'ants_affine_xfm' isn't called 'anatomical_to_mni_linear_xfm' like with fnirt. This way one could reduce some code since there are lots of common elements across the fnirt and ants workflows. Note that in my little integration, I first have some code common to both registration outputs and then a section for some differences with ANTS.

The use of `strat.set_leaf_properties` is confusing because later in the code when you get this, it is unclear what is being gotten with all the if/else statements. Since everything is already in the `strat.update_resource_pool`, why not just get it from there with its name. This way the code will be more readable.

## Testing the New Pipeline Code

There were several issues I had to deal with during testing one participant. First, I needed the information present in the CPAC_subject_list.yml generated earlier. So I had to muddle with the code a bit so the new CPAC_subject_list included both the old information and the resource paths for all the outputs needed for generating the derivatives. There were also a set of variable scope issues when using create_log_node outside the function. Various minor issues also cropped up.

I am however still with an error. Now it seems that some connections were not found, specifically when creating the workflow for spatial regression. 