---
layout: post
title: "Run Preprocessing"
description: "Running the preprocessing on gelert"
category: "preprocessing"
tags: ["preprocessing", "gelert"]
---
{% include JB/setup %}

# Test for one subject

I want to first confirm that everything is working on at least one subject. All of this information is in the `config/test_one_subject` folder.

## Subject List

I setup the subject list with the GUI in the New Subject List section.

## Pipelines

I had previously setup the pipeline in the GUI so I just loaded that one. I made this one without any time-series extraction.

## Run

I've had some troubling running the pipeline. It wasn't able to find qsub so I switched to not using the grid. Then I had a problem with the symmetric templates. It seems that when I use 3mm for the standard-space resolution, it uses that info for the paths of symmetric MNI files. Since I don't have those files in 3mm, I changed the standard resolution to 2mm.

For testing purposing I am running first on rocky and not using the grid engine with gelert. I hit various problems (below are a few):

* The default parallelEnvironment should be mpi_smp
* I set the path to rocky's FSL and this didn't load so I'm using the fsl in PublicProgram, although this version is 4.1.9 whereas the one used on rocky is 5.0.
* I had to copy over the tissue priors to the PublicProgram rocky. For some reason, these weren't in the expected directories.

# All Participants

Now I have run it with all the participants using 2 cores per participant on gelert. The sym links directory doesn't get created properly so this may require some manual creation for the release. In addition, it appears that the qc html pages are not generated either. Not sure if this is due to the sym links issue or something different. However, the images for the qc have been created in the output directory.
