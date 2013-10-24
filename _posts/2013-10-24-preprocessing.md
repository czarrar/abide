---
layout: post
title: "Preprocessing"
description: ""
category: "preprocessing"
tags: [preprocessing]
---
{% include JB/setup %}

Facing a bit of a crisis with the preprocessing. Got a no space left on device error. This means that either the preprocessing and derivates takes up more space then we have on each node when running 4 simultaneous processes. Or it could mean that previous subject's working directory are not being deleted.

One thing to check is if in fact the subjects that were run, if their working directory was deleted. For a sample subject, it seems like their directory wasn't deleted. However, when I ran a test run on rocky, the working directory was deleted. I'm not sure if the issue on gelert is because I ran with gelert or the particular issue with the options that I selected.

I'm now deleting all the working directories on each node. This seems to be taking quite a long time. Will wait and have this finish before I run through a test gelert run to see if the working directory is removed on time.

Emailed Cameron and he suggested to focus on quick pack for now and take my time figuring out these issues on abide preprocessing.