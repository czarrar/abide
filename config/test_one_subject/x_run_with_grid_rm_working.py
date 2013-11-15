#!/usr/bin/env python

# Using a development version of CPAC
import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-10-04_v0-3-2/run/lib/python2.7/site-packages")

config_file         = "config_preprocessing_with_grid_rm_working.yml"
subject_list_file   = "CPAC_subject_list.yml"

import nipype
import CPAC
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)
