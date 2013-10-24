---
layout: post
title: "More QuickPack"
description: "Still getting quick pack code to work."
category: "cpac"
tags: [cpac, quickpack, code]
---
{% include JB/setup %}

I left off with some errors related to spatial regression. That error was related to the fact that if statements didn't exist in the QC so things like segmentation and registration results were being used to generate QC.

I now focused on just turning on ALFF/fALFF. I had to deal with some errors when run register option was off but I still wanted to register the outputs of this derivative. There also some other random issues that I forgot.

Now I have some issues with the apply registration. It seems that the ANTS apply ALFF registration fails when using the `c3d_affine_tool`. For some reason, the reference anatomical image is not being included in the command. In this case the reference is the `anatomical_brain`, which was in the input yml subject list file. It appears the needed gather directory isn't being written for any of the anatomicals. Ugh the anatomical error was a silly missing node.inputs.anat (was node.anat) so the anatomical file paths were just not being passed.

Now I'm facing all sorts of other random problems principally from the QC and log pages. I fixed a bunch of them, but now have an issue with `make_group_htmls` in `utils/create_all_qc.py`. I think this might be more of a major issue since it tries to call various steps like power and motion params, without checking if preprocessing was even run. I think this might mean that I can't use the QC pages along with my quick pack implementation, so will need to turn it off.