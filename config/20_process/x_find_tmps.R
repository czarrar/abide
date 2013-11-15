#!/usr/bin/env Rscript

# Subjects in working directories
subs <- c()    
for (i in 1:32) {
    cmd <- sprintf("ssh node%i ls -d /tmp/resting_preproc_00*", i)
    cat(cmd, "\n")
    res <- system(cmd, intern=T)
    res <- sub("resting_preproc_", "", basename(res))
    res <- sub("_session_1", "", res)
    subs <- c(subs, res)
}
subs <- sort(subs)

# Subject who have finished running
## Their Job IDs
all_ids <- as.character(read.table("/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-12/pid.txt")[,1])
cur_ids <- system("qstat | awk '{print $1}' | tail -n+3", intern=T)
finished_ids <- !(all_ids %in% cur_ids)
## Their Subject IDs
all_subs <- as.character(read.table("/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-12/sub.txt")[,1])
finished_subs <- all_subs[finished_ids]
finished_subs <- sub("_session_1", "", finished_subs)

# Are their any finished subjects with working directories still alive?
subs %in% finished_subs

# Can we remove those subjects?






# Subjects in sink directory
outsubs <- list.files("/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-12/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96")
outsubs <- sub("_session_1", "", outsubs)
outsubs <- sort(outsubs)

# Compare
#sapply(subs, function(x) any(x == outsubs))

# Subjects in the working directory but not output directory
subs[subs %in% outsubs]



###
# Subject in the output directory but not in the working directory
###

no.wd <- outsubs[!(outsubs %in% subs)]
base <- "/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-05/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96"
restdir <- sprintf("%s/%s_session_1/scan_rest_1_rest", base, no.wd)
func2mni <- file.path(restdir, "func/functional_mni.nii.gz")
file.exists(func2mni)


###
# Subjects with a working directory and output directory
###
yes.wd <- outsubs[outsubs %in% subs]
base <- "/home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-11-05/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96"
restdir <- sprintf("%s/%s_session_1/scan_rest_1_rest", base, yes.wd)
func2mni <- file.path(restdir, "func/functional_mni.nii.gz")
file.exists(func2mni)


###
# Subjects with information that directory was removed
###
rmdirs.stdout <- system('grep "removing dir" /home2/data/Projects/ABIDE_Initiative/CPAC/abide/config/20_process/cluster_temp_files/c-pac_2013_11_05_17_18_17.out', intern=T)
subs.rmdir <- substr(rmdirs.stdout, 39, 39+6)
subs.rmdir %in% no.wd   # these are all true indicating the subject was removed

###
# Subjects with end of workflow information
###
end.stdout <- system('grep "End of subject workflow" cluster_temp_files/c-pac_2013_11_05_17_18_17.out', intern=T)


###
# Subjects with something output
###
init.stdout <- system('grep "Creating detailed dot file" cluster_temp_files/c-pac_2013_11_05_17_18_17.out', intern=T)
