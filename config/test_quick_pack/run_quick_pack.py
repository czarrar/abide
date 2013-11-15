#!/usr/bin/env python
# #!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
#sys.path.insert(1, "/home2/milham/Download/cpac_master")
import CPAC

## Everything (to test against)
#config_file         = "config.yml"
#subject_list_file   = "start_CPAC_subject_list.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)

# ALFF
config_file         = "config_10_alff.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, "me")

# REHO
config_file         = "config_20_reho.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)

# Centrality
config_file         = "config_30_centrality.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)

# SCA
config_file         = "config_40_sca.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)

# DR
config_file         = "config_50_dr.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)

# VMHC
config_file         = "config_60_dr.yml"
subject_list_file   = "subject_list_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)
