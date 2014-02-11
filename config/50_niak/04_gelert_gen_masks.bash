#!/usr/bin/env bash

# This script generates all the masks via gelert

odir="cluster_temp_files/gen_masks"
mkdir ${odir}

func_files=$(cat func_files.list | tr '\n' ' ')

for func_file in ${func_files}; do
    subject=$( basename ${func_file} | sed -e s/fmri_// -e s/_session_1_run1.nii.gz// )
    strat=$( dirname $( dirname ${func_file##/home2/data/Projects/ABIDE_Initiative/NIAK/processed/} ) )
    
    echo "SUBJECT: ${subject}"
    
    scriptfile="${odir}/script_${subject}_${strat}_session_1.sge"
    
    echo "" > ${scriptfile}
    echo "#! /bin/bash" >> ${scriptfile}
    echo "#$ -cwd" >> ${scriptfile}
    echo "#$ -S /bin/bash" >> ${scriptfile}
    echo "#$ -V" >> ${scriptfile}
    echo "#$ -q all.q" >> ${scriptfile}
    echo "#$ -j y" >> ${scriptfile}
    echo "#$ -o /data/Projects/ABIDE_Initiative/CPAC/abide/config/50_niak/cluster_temp_files/gen_masks/out_${subject}_${strat}_session_1.log" >> ${scriptfile}
    echo "" >> ${scriptfile}
    echo "source ~/.bashrc" >> ${scriptfile}
    echo "cd /data/Projects/ABIDE_Initiative/CPAC/abide/config/50_niak" >> ${scriptfile}
    echo "./02_gen_mask.bash ${func_file}" >> ${scriptfile}
    echo "" >> ${scriptfile}
    
    echo "qsub ${scriptfile}"
    qsub ${scriptfile}
done


