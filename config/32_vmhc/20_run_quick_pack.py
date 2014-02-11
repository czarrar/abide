#!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

# #!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/zarrar/centrality_tests/lib/nipype')
#sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
#sys.path.insert(1, "/home2/milham/Download/cpac_master")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")
import CPAC

#from memprof import *

## Everything (to test against)
#config_file         = "config.yml"
#subject_list_file   = "start_CPAC_subject_list.yml"
#CPAC.pipeline.cpac_runner.run(config_file, subject_list_file)


## All the derivatives (using the above preprocessing)

#suffixes = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
suffixes = ["filt_global"]
#suffixes = ["filt_noglobal", "nofilt_noglobal"]

for suffix in suffixes:
    otype               = "rest_1"
    subject_list_file   = "../28_centrality/quick_pack_%s_rest_%s.yml" % (otype,suffix)

    # VMHC
    import time
    start = time.clock()
    config_file         = "config_vmhc.yml"
    CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)
    print "timing:", (time.clock() - start)
