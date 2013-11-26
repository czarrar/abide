Node: resample_u (utility)
==========================

 Hierarchy : wf_test2.resample_u
 Exec ID : resample_u

Original Inputs
---------------

* file_ : /home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/0051565_session_1/scan_rest_1_rest/func/mean_functional_in_mni.nii.gz
* function_str : S'def resample_1mm(file_):\n\n    """\n    Calls make_resample_1mm which resamples file to 1mm space\n\n    Parameters\n    ----------\n\n    file_ : string\n        path to the scan\n\n    Returns\n    -------\n\n    new_fname : string\n        path to 1mm resampled nifti file\n\n    """\n\n    from CPAC.qc.utils import make_resample_1mm\n\n    new_fname = None\n    if isinstance(file_, list):\n        new_fname = []\n\n        for f in file_:\n\n            new_fname.append(make_resample_1mm(f))\n\n    else:\n        new_fname = make_resample_1mm(file_)\n\n    return new_fname\n'
.
* ignore_exception : False

Execution Inputs
----------------

* file_ : /home2/data/Projects/ABIDE_Initiative/CPAC/Output_2013-10-18/sym_links/pipeline_MerrittIsland/_compcor_ncomponents_5_linear1.global1.motion1.quadratic1.compcor1.CSF_0.96_GM_0.7_WM_0.96/0051565_session_1/scan_rest_1_rest/func/mean_functional_in_mni.nii.gz
* function_str : S'def resample_1mm(file_):\n\n    """\n    Calls make_resample_1mm which resamples file to 1mm space\n\n    Parameters\n    ----------\n\n    file_ : string\n        path to the scan\n\n    Returns\n    -------\n\n    new_fname : string\n        path to 1mm resampled nifti file\n\n    """\n\n    from CPAC.qc.utils import make_resample_1mm\n\n    new_fname = None\n    if isinstance(file_, list):\n        new_fname = []\n\n        for f in file_:\n\n            new_fname.append(make_resample_1mm(f))\n\n    else:\n        new_fname = make_resample_1mm(file_)\n\n    return new_fname\n'
.
* ignore_exception : False

Execution Outputs
-----------------

* new_fname : /data/Projects/ABIDE_Initiative/CPAC/abide/qc/test_montage/wf_test2/resample_u/mean_functional_in_mni_1mm.nii.gz

Runtime info
------------

* duration : 0.737234115601
* hostname : rocky

Environment
~~~~~~~~~~~

* ANTSPATH : /home/milham/Downloads/ANTs-1.9.x-Linux/bin/
* BYOBU_ACCENT : #75507B
* BYOBU_BACKEND : tmux
* BYOBU_CHARMAP : UTF-8
* BYOBU_CONFIG_DIR : /home/milham/.byobu
* BYOBU_DARK : black
* BYOBU_HIGHLIGHT : #DD4814
* BYOBU_LIGHT : white
* BYOBU_PAGER : sensible-pager
* BYOBU_PREFIX : /usr/local
* BYOBU_READLINK : readlink
* BYOBU_RUN_DIR : /dev/shm/byobu-milham-6o9MLgAf
* BYOBU_SED : sed --follow-symlinks
* DISPLAY : localhost:15.0
* DSI_PATH : /usr/share/dtk/matrices
* DTDIR : /usr/share/dtk
* FIX_VERTEX_AREA : 
* FMRI_ANALYSIS_DIR : /usr/share/freesurfer/5.0/fsfast
* FREESURFER_HOME : /usr/share/freesurfer/5.0
* FSFAST_HOME : /usr/share/freesurfer/5.0/fsfast
* FSF_OUTPUT_FORMAT : nii
* FSLCONFDIR : /usr/share/fsl/5.0/config
* FSLCONVERT : /usr/bin/convert
* FSLDIR : /usr/share/fsl/5.0
* FSLDISPLAY : /usr/bin/display
* FSLLOCKDIR : 
* FSLMACHINELIST : 
* FSLMACHTYPE : gnu_64-gcc4.4
* FSLMULTIFILEQUIT : TRUE
* FSLOUTPUTTYPE : NIFTI_GZ
* FSLREMOTECALL : 
* FSLTCLSH : /usr/share/fsl/5.0/bin/fsltclsh
* FSLWISH : /usr/share/fsl/5.0/bin/fslwish
* FSL_BIN : /usr/share/fsl/5.0/bin
* FSL_DIR : /usr/share/fsl/5.0
* FS_OVERRIDE : 0
* FUNCTIONALS_DIR : /usr/share/freesurfer/5.0/sessions
* GEM_HOME : /home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194
* GEM_PATH : /home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194:/home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194@global
* HOME : /home/milham
* IRBRC : /home2/data/PublicProgram/rvm/rubies/ruby-1.9.3-p194/.irbrc
* LANG : en_US.UTF-8
* LC_CTYPE : en_US.UTF-8
* LIBGL_ALWAYS_INDIRECT : 1
* LOADEDMODULES : 
* LOCAL_DIR : /usr/share/freesurfer/5.0/local
* LOGNAME : milham
* LS_COLORS : rs=0:di=01;34:ln=01;36:hl=44;37:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:
* MAIL : /var/mail/milham
* MANPATH : :/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/usr/X11R6/man
* MINC_BIN_DIR : /usr/share/freesurfer/5.0/mni/bin
* MINC_LIB_DIR : /usr/share/freesurfer/5.0/mni/lib
* MNI_DATAPATH : /usr/share/freesurfer/5.0/mni/data
* MNI_DIR : /usr/share/freesurfer/5.0/mni
* MNI_PERL5LIB : /usr/share/freesurfer/5.0/mni/lib/perl5/5.8.5
* MODULEPATH : /usr/local/Modules/versions:/usr/local/Modules/$MODULE_VERSION/modulefiles:/usr/local/Modules/modulefiles
* MODULESHOME : /usr/local/Modules/3.2.9
* MODULE_VERSION : 3.2.9
* MODULE_VERSION_STACK : 3.2.9
* MY_RUBY_HOME : /home2/data/PublicProgram/rvm/rubies/ruby-1.9.3-p194
* OLDPWD : /home2/data/Projects/ABIDE_Initiative/CPAC/abide/qc
* OS : Linux
* PATH : /home2/dlurie/Enthought/Canopy_64bit/User/bin:/home2/data/PublicProgram/R/bin:/home/milham/Downloads/c3d-0.8.2-Linux-x86_64/bin/:/home/milham/Downloads/ANTs-1.9.x-Linux/bin/:/home/data/PublicProgram/R/bin:/home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194/bin:/home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194@global/bin:/home2/data/PublicProgram/rvm/rubies/ruby-1.9.3-p194/bin:/home2/data/PublicProgram/rvm/bin:/usr/share/camino/bin:/home2/data/PublicProgram/AFNI:/usr/share/fsl/5.0/bin:/usr/share/dtk:/usr/share/freesurfer/5.0/bin:/usr/share/freesurfer/5.0/fsfast/bin:/usr/share/fsl/5.0/bin:/usr/share/freesurfer/5.0/mni/bin:/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/bin:/home/milham/bin:/home2/dlurie/Enthought/Canopy_64bit/User/bin:/home2/data/PublicProgram/R/bin:/home/milham/Downloads/c3d-0.8.2-Linux-x86_64/bin/:/home/milham/Downloads/ANTs-1.9.x-Linux/bin/:/home/data/PublicProgram/R/bin:/home/data/PublicProgram/rvm/bin:/home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194/bin:/home2/data/PublicProgram/rvm/gems/ruby-1.9.3-p194@global/bin:/home2/data/PublicProgram/rvm/rubies/ruby-1.9.3-p194/bin:/home2/data/PublicProgram/rvm/bin:/usr/share/camino/bin:/home2/data/PublicProgram/AFNI:/usr/share/fsl/5.0/bin:/usr/share/dtk:/usr/share/freesurfer/5.0/bin:/usr/share/freesurfer/5.0/fsfast/bin:/usr/share/freesurfer/5.0/mni/bin:/home/data/PublicProgram/epd-7.2-2-rh5-x86_64/bin:/home/milham/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/MATLAB/R2012a/bin:/home/milham/.rvm/bin:/home/milham/bin:/usr/local/MATLAB/R2012a/bin:/home/milham/.rvm/bin
* PERL5LIB : /usr/share/freesurfer/5.0/mni/lib/perl5/5.8.5
* PWD : /home2/data/Projects/ABIDE_Initiative/CPAC/abide/qc/test_montage
* PYTHONPATH : /home2/data/Projects/CPAC_Regression_Test/2013-05-30_cwas/C-PAC
* RUBY_VERSION : ruby-1.9.3-p194
* SHELL : /bin/bash
* SHLVL : 3
* SSH_CLIENT : 172.16.254.104 50546 22
* SSH_CONNECTION : 172.16.254.104 50546 10.76.253.22 22
* SSH_TTY : /dev/pts/27
* SUBJECTS_DIR : /usr/share/freesurfer/5.0/subjects
* TERM : screen
* TMUX : /tmp/tmux-774/default,24383,0
* TMUX_PANE : %0
* USER : milham
* VIRTUAL_ENV : /home2/dlurie/Enthought/Canopy_64bit/User
* XDG_SESSION_COOKIE : d749c5b149de78a4cc5bcc444f038a86-1380561254.418095-1430047090
* _ : /home/data/PublicProgram/epd-7.2-2-rh5-x86_64/bin/ipython
* __array_start : 0
* _first : 0
* _second : 1
* escape_flag : 1
* rvm_bin_path : /home/data/PublicProgram/rvm/bin
* rvm_path : /home2/data/PublicProgram/rvm
* rvm_prefix : /home/data/PublicProgram
* rvm_version : 1.16.6 (stable)

