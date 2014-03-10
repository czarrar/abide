#!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

# #!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/zarrar/centrality_tests/lib/nipype')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")
import CPAC


suffixes = ["filt_global", "filt_noglobal", "nofilt_global", "nofilt_noglobal"]
#suffixes = ["filt_noglobal", "nofilt_noglobal"]

for suffix in suffixes:
    otype               = "rest_1"
    subject_list_file   = "quick_pack_missing_eigen_%s.yml" % suffix

    # Centrality
    import time
    start = time.clock()
    config_file         = "config_eigen.yml"
    CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, otype)
    print "timing:", (time.clock() - start)
