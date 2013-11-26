#!/usr/bin/env bash

./cpac_centrality.py -i "/data/Projects/ABIDE_Initiative/CPAC/test_qp/Centrality_Working/resting_preproc_0051466_session_1/_mask_mask_abide_90percent_gm_3mm/_scan_rest_1_rest/resample_functional_to_template_0/residual_wtsimt_flirt.nii.gz" \
    -m "/home2/data/Projects/ABIDE_Initiative/CPAC/abide/templates/masks/mask_abide_90percent_gm_3mm.nii.gz" \
    --degree \
    --binarize --weighted \
    --pvalue 0.001 \
    --memlimit 4 \
    -o $(pwd)/tmp