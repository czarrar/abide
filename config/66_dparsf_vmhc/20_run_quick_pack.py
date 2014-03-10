#!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

# #!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/zarrar/centrality_tests/lib/nipype')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")
import CPAC


## All the derivatives (using the above preprocessing)

config_file = "config_vmhc.yml"
#suffixes = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
#suffixes = ["filt_global", "filt_noglobal"]
suffixes = ["nofilt_global", "nofilt_noglobal"]

for suffix in suffixes:
    print "===="
    print suffix
    subject_list_file   = "../40_xinian/quick_pack_rest_1_%s.yml" % suffix
    
    import time
    start = time.clock()
    CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, suffix)
    print "timing:", (time.clock() - start)
    print "===="
