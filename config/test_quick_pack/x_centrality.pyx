cimport numpy as np

def cy_centrality(np.ndarray[double, ndim=2] cmat, np.ndarray[double, ndim=1] cent, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent[i] = cent[i] + cmat[i,j]*(cmat[i,j] > thresh)



import pyximport
pyximport.install(setup_args={'include_dirs': [np.get_include()]})
import x_centrality