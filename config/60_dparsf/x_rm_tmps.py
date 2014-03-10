#!/usr/bin/env python

import os

tmpdir = "/tmp/dparsf"

for i in xrange(1,33):
    print "========"
    
    cmd = "ssh node%i ls %s" % (i, tmpdir)
    print cmd
    os.system(cmd)
    
    cmd = "ssh node%i rm -rf %s" % (i, tmpdir)
    print cmd
    os.system(cmd)
    
    print "========"

