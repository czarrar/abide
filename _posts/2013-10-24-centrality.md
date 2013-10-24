---
layout: post
title: "Centrality"
description: "Thoughts on improving the speed of degree centrality"
category: "cpac"
tags: [cpac, centrality, code]
---
{% include JB/setup %}

# Centrality Slow

It's weird that the centrality code takes so long because I thought I was able to get similar measures of voxelwise centrality with some R code in about 10ish minutes per participant. Seems to be taking a lot longer here.

## Code Changes to Increase Speed

We could make use of the CWAS code where I calculate the norm of the time-series. The correlation is taken as a dot product then.

Don't save the complete correlation matrix! Calculate in chunks of some voxels with every other voxel. This will lead to some redundant calculations but should be nicer on the memory and could be nicer on speed.

