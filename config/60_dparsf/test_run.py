#!/home2/dlurie/Enthought/Canopy_64bit/User/bin/python

# #!/usr/bin/env python

import sys
sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/zarrar/centrality_tests/lib/nipype')
#sys.path.insert(0, '/home2/data/Projects/CPAC_Regression_Test/nipype-installs/fcp-indi-nipype/running-install/lib/python2.7/site-packages')
sys.path.insert(1, "/home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC")
#sys.path.insert(1, "/home2/milham/Download/cpac_master")
sys.path.append("/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/lib/python2.7/site-packages")
import CPAC

# Test on 2 subjects
config_file         = "config.yml"
subject_list_file   = "test_quick_pack.yml"
CPAC.pipeline.cpac_runner.run(config_file, subject_list_file, 'test_quick_pack')
