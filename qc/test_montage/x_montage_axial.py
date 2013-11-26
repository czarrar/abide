#!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-10-04_v0-3-2/run/lib/python2.7/site-packages")

# Let's try to re-create an axial image of the mean functional
# So I will need an underlay (mean_functional in mni)
underlay = "/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/0051565_session_1/scan_rest_1_rest/func/mean_functional_in_mni.nii.gz"
# and I will need an overlay which should be the outline of the MNI
overlay = "/home2/data/Projects/CPAC_Regression_Test/2013-10-04_v0-3-2/run/lib/python2.7/site-packages/CPAC/resources/templates/MNI152_Edge_AllTissues.nii.gz"
# the png_name
# the cbar
from CPAC.qc.utils import montage_axial, make_montage_axial
png_name = make_montage_axial(overlay, underlay, 'test', 'red')
png_name = montage_axial(overlay, underlay, 'test2', 'red')
from CPAC.qc.qc import create_montage
wf = create_montage('wf_test2', 'red', 'test3')
wf.base_dir = '.'
wf.inputs.inputspec.underlay = underlay
wf.inputs.inputspec.overlay = overlay
wf.run()
# this will output the stuff to a temporary working directory
# should have given a base directory

# Oh man this works with the old version.