#!/usr/bin/env python

import os, sys
import numpy as np
from numpy.testing import *

from nose.tools import ok_, eq_, raises, with_setup
from nose.plugins.attrib import attr    # http://nose.readthedocs.org/en/latest/plugins/attrib.html

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")

from CPAC.network_centrality import calc_centrality

datafile = "/data/Projects/ABIDE_Initiative/CPAC/test_qp/Centrality_Working/resting_preproc_0051466_session_1/_mask_mask_abide_90percent_gm_3mm/_scan_rest_1_rest/resample_functional_to_template_0/residual_wtsimt_flirt.nii.gz"
template = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks/mask_abide_90percent_gm_3mm.nii.gz"
method_options = [True, False]
weight_options = [True, True]
option = 0
threshold = 0.001
allocated_memory = 1

calc_centrality(datafile, template, method_options, weight_options, option, threshold, allocated_memory)




#datafile = "/data/Projects/ABIDE_Initiative/CPAC/test_qp/Centrality_Working/resting_preproc_0051466_session_1/_mask_mask_abide_90percent_gm_4mm/_scan_rest_1_rest/resample_functional_to_template_0/residual_wtsimt_flirt.nii.gz"
#template = "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks/mask_abide_90percent_gm_4mm.nii.gz"
#method_options = [True, False]
#weight_options = [True, True]
#option = 0
#threshold = 0.266037302736
#allocated_memory = 12
#
#calc_centrality(datafile, template, method_options, weight_options, option, threshold, allocated_memory)
