---
layout: post
title: "Slow Processing"
description: "The processing on gelert appears to be running very slowly."
category: "processing"
tags: [preprocessing, derivatives]
---
{% include JB/setup %}

So not much has changed in the past 1.5 days that this has been running. By not much has changed, I mean that outputs for all subjects being run on gelert appear to exist but the process isn't finished. Several possibilities could exist:

- I'm using only 2 cores per participant.
- I accidentally ran eigen vector centrality.
- I used some other costly derivative option.

I double checked the config file and this looked ok. To isolate the issue, I might first see where the program is hanging. I can look into the log file that I made. It does seem like it is finished. The following derivatives are in the folder:

- alff
- centrality
- reho
- sca_roi
- spatial_regression
- timeseries

The log reports page also concurs that these nodes have been run.

So maybe the issue is that the process is stuck on something.  There are no crash reports but I can check the standard error  output from the gelert run. Damn there are some errors in here:

	Degrade mode - ENTERING - (pid=6970)  rename failed.  File in use?  exception=[Errno 2] No such file or directory
	Degrade mode - EXITING  - (pid=6970)   Rotation done or not needed at this time
	# ...
	/home2/data/Projects/CPAC_Regression_Test/2013-10-04_v0-3-2/run/lib/python2.7/site-packages/CPAC/network_centrality/uti
	ls.py:273: RuntimeWarning: invalid value encountered in divide
	r = np.dot(X.T, Y)/np.sqrt(np.multiply.outer(xx,yy))

This error/warning makes me think that I created the mask for centrality incorrectly. I should have possibly used a 100% mask instead of a 90% mask. Checking this with others but it does seem that it is a RuntimeWarning and not something else. The previous degrade mode error appears to be a registration issue?

Ok after speaking to Dan, he suggested to look at the time-stamp of the `c-pac_*.out` and it appears that stuff is being continually written. One possibility for the slowness is that on gelert we need to set a somewhat low memory limit for centrality (2gb), which might slow things down. However, this step (centrality) does seem to be computed and the .out shows stuff related to symlinks being done.

