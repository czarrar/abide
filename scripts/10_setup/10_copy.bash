#!/usr/bin/env bash

# # Purpose
# 
# We want to copy over the two other preprocessed datasets onto rocky/sam


# # Details
# 
# The data are located in 
# * `/mnt/usb1` for Xinian's preprocessing, which includes application of Freesurfer
# * `/mnt/usb2` for Pierre's preprocessing


# # Execute

# Copying Xinian's Preprocessing
echo "Xinian's Data"
mkdir /data/Projects/ABIDE_Initiative/LFCD 2> /dev/null
cp -r /mnt/usb1/ABIDE /data/Projects/ABIDE_Initiative/LFCD/processed

# Copying Pierre's Preprocessing
echo "Pierre's Data"
mkdir /data/Projects/ABIDE_Initiative/NIAK 2> /dev/null
cp -r /mnt/usb2/abide_niak /data/Projects/ABIDE_Initiative/NIAK/processed
