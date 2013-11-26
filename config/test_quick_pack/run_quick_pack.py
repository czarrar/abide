#!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

# #!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
#sys.path.insert(1, "/home2/milham/Download/cpac_master")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")
import CPAC

from memprof import *

## Everything (to test against)
#config_file         = "config.yml"
#subject_list_file   = "start_CPAC_subject_list.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)


## All the derivatives (using the above preprocessing)

otype               = "nofilt_global"
subject_list_file   = "files/quick_pack_rest_1_rest_%s.yml" % otype

## ALFF
#config_file         = "config_10_alff.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)

## REHO
#config_file         = "config_20_reho.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)

# Centrality
import time
start = time.clock()
config_file         = "config_30_centrality_3mm.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)
print "timing:", (time.clock() - start)

## SCA
#config_file         = "config_40_sca.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)
#
## DR
#config_file         = "config_50_dr.yml"
#PAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)

## VMHC
#config_file         = "config_60_vmhc.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)
