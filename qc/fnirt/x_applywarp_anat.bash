#!/usr/bin/env bash

# Here I will have a set of subjects
# For each subject, I will applywarp to
# the anatomical or functional

# Let's take the anatomical first
# Ok so say we have one sample subject
# let's find that subject: 0051576_session_1
# What's the path to this subject
# /home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/0051576_session_1
# Since all participants will share the initial component we will have

base="/home2/data/Projects/ABIDE_Initiative/CPAC"
strat="${base}/Output0723/sym_links/pipeline_HackettCity/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.98_GM_0.7_WM_0.98"

# Now let's get the subject paths
subdirs=$(ls -d ${strat}/*)

# Also let's go with a sample subject
for subdir in ${subdirs}; do
    sub=$(basename $subdir)
    echo "subject: ${sub}"

    # We need the file paths for
    # the brain, reference (1mm space), output, and warp file
    brain="${subdir}/scan/anat/anatomical_brain.nii.gz"
    ref="${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz"
    brain2std="${subdir}/scan/anat/mni_normalized_anatomical_1mm.nii.gz"
    warp="${subdir}/scan/anat/anatomical_to_mni_nonlinear_xfm.nii.gz"

    # Now we can call applywarp
    cmd="applywarp --in=${brain} --ref=${ref} --out=${brain2std} --warp=${warp}" 
    echo $cmd
    ${cmd}
done
