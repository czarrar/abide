#!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/config/20_process/C-PAC")

config_file         = "config_preprocessing.yml"
subject_list_file   = "CPAC_subject_list.yml"

import CPAC
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)
