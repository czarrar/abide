
%Zarrar, please put all the subject files ZZZ_Sub_XXX.nii under a derivative folder, which should be under {DataProcessDir}/Results.
%e.g., /data/Projects/ABIDE_Initiative/DPARSF/ReNormalize/Results/ALFF/Sub_005_ALFF.nii.
%      /data/Projects/ABIDE_Initiative/DPARSF/ReNormalize/Results/ALFF/Sub_006_ALFF.nii.

addpath /home/data/PublicProgram/REST_V1.8_130615
addpath /home/data/PublicProgram/DPARSF_V2.3_130615
rmpath /home/data/Projects/microstate/DPARSF_preprocessed/code/REST_V1.8_121225/rest_spm5_files

load /data/Projects/ABIDE_Initiative/DPARSF/ReNormalize/DPARSF_ReNormalize.mat
AutoDataProcessParameter.SubjectID = Cfg.SubjectID;

AutoDataProcessParameter.DataProcessDir = '/data/Projects/ABIDE_Initiative/DPARSF/ReNormalize'; 




% Register
AutoDataProcessParameter.IsNormalize = 3;
AutoDataProcessParameter.Normalize.Timing = 'OnResults';
AutoDataProcessParameter.Normalize.BoundingBox=[-90 -126 -72; 90 90 108];
AutoDataProcessParameter.Normalize.VoxSize=[3 3 3]; % or [2 2 2] if prefer.

% Apply smoothing
AutoDataProcessParameter.isSmooth = 1;
AutoDataProcessParameter.Smooth.Timing = 'OnResults';
AutoDataProcessParameter.Smooth.FWHM = [6 6 6];


[ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
AutoDataProcessParameter.SubjectNum=length(AutoDataProcessParameter.SubjectID);
Error=[];
addpath([ProgramPath,filesep,'Subfunctions']);

[SPMversion,c]=spm('Ver');
SPMversion=str2double(SPMversion(end));

AutoDataProcessParameter.FunctionalSessionNumber = 1;
% Multiple Sessions Processing 
% YAN Chao-Gan, 111215 added.
FunSessionPrefixSet={''}; %The first session doesn't need a prefix. From the second session, need a prefix such as 'S2_';
for iFunSession=2:AutoDataProcessParameter.FunctionalSessionNumber
    FunSessionPrefixSet=[FunSessionPrefixSet;{['S',num2str(iFunSession),'_']}];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%***Normalize and/or Smooth the results***%%%%%%%%%%%%%%%%

AutoDataProcessParameter.StartingDirName = 'Results_nofilt_noglobal';

%Normalize on Results
if (AutoDataProcessParameter.IsNormalize>0) && strcmpi(AutoDataProcessParameter.Normalize.Timing,'OnResults')

    %Check the measures need to be normalized
    DirMeasure = dir([AutoDataProcessParameter.DataProcessDir,filesep,AutoDataProcessParameter.StartingDirName]);
    if strcmpi(DirMeasure(3).name,'.DS_Store')  %110908 YAN Chao-Gan, for MAC OS compatablie
        StartIndex=4;
    else
        StartIndex=3;
    end
    MeasureSet=[];
    for iDir=StartIndex:length(DirMeasure)
        if DirMeasure(iDir).isdir
            if ~(strcmpi(DirMeasure(iDir).name,'VMHC') || (length(DirMeasure(iDir).name)>10 && strcmpi(DirMeasure(iDir).name(end-10:end),'_ROISignals')))
                MeasureSet = [MeasureSet;{DirMeasure(iDir).name}];
            end
        end
        
    end
    
    fprintf(['Normalizing the resutls into MNI space...\n']);

    
    parfor i=1:AutoDataProcessParameter.SubjectNum
        
        FileList=[];
        for iFunSession=1:AutoDataProcessParameter.FunctionalSessionNumber
            for iMeasure=1:length(MeasureSet)
                cd([AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,filesep,MeasureSet{iMeasure}]);
                DirImg=dir(['*',AutoDataProcessParameter.SubjectID{i},'*.img']);
                for j=1:length(DirImg)
                    FileList=[FileList;{[AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,filesep,MeasureSet{iMeasure},filesep,DirImg(j).name]}];
                end
                
                DirImg=dir(['*',AutoDataProcessParameter.SubjectID{i},'*.nii']);
                for j=1:length(DirImg)
                    FileList=[FileList;{[AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,filesep,MeasureSet{iMeasure},filesep,DirImg(j).name]}];
                end
            end
            
        end
        
        % Set the mean functional image % YAN Chao-Gan, 120826
        DirMean=dir([AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,'mean*.img']);
        if isempty(DirMean)  %YAN Chao-Gan, 111114. Also support .nii files.
            DirMean=dir([AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,'mean*.nii.gz']);% Search .nii.gz and unzip; YAN Chao-Gan, 120806.
            if length(DirMean)==1
                gunzip([AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,DirMean(1).name]);
                delete([AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,DirMean(1).name]);
            end
            DirMean=dir([AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,'mean*.nii']);
        end
        MeanFilename = [AutoDataProcessParameter.DataProcessDir,filesep,'RealignParameter',filesep,AutoDataProcessParameter.SubjectID{i},filesep,DirMean(1).name];
        
        FileList=[FileList;{MeanFilename}]; %YAN Chao-Gan, 120826. Also normalize the mean functional image.
        

        if (AutoDataProcessParameter.IsNormalize==1) %Normalization by using the EPI template directly
            
            SPMJOB = load([ProgramPath,filesep,'Jobmats',filesep,'Normalize.mat']);
            
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.estwrite.subj(1,1).source={MeanFilename};
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.estwrite.subj(1,1).resample=FileList;
            
            [SPMPath, fileN, extn] = fileparts(which('spm.m'));
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.estwrite.eoptions.template={[SPMPath,filesep,'templates',filesep,'EPI.nii,1']};
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.estwrite.roptions.bb=AutoDataProcessParameter.Normalize.BoundingBox;
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.estwrite.roptions.vox=AutoDataProcessParameter.Normalize.VoxSize;

            if SPMversion==5
                spm_jobman('run',SPMJOB.jobs);
            elseif SPMversion==8  %YAN Chao-Gan, 090925. SPM8 compatible.
                SPMJOB.jobs = spm_jobman('spm5tospm8',{SPMJOB.jobs});
                spm_jobman('run',SPMJOB.jobs{1});
            else
                uiwait(msgbox('The current SPM version is not supported by DPARSF. Please install SPM5 or SPM8 first.','Invalid SPM Version.'));
                Error=[Error;{['Error in Normalize: The current SPM version is not supported by DPARSF. Please install SPM5 or SPM8 first.']}];
            end
        end
        
        if (AutoDataProcessParameter.IsNormalize==2) %Normalization by using the T1 image segment information
            %Normalize-Write: Using the segment information
            SPMJOB = load([ProgramPath,filesep,'Jobmats',filesep,'Normalize_Write.mat']);
            
            MatFileDir=dir([AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgSegment',filesep,AutoDataProcessParameter.SubjectID{i},filesep,'*seg_sn.mat']);
            MatFilename=[AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgSegment',filesep,AutoDataProcessParameter.SubjectID{i},filesep,MatFileDir(1).name];
            
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.write.subj.matname={MatFilename};
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.write.subj.resample=FileList;
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.write.roptions.bb=AutoDataProcessParameter.Normalize.BoundingBox;
            SPMJOB.jobs{1,1}.spatial{1,1}.normalise{1,1}.write.roptions.vox=AutoDataProcessParameter.Normalize.VoxSize;
            
            if SPMversion==5
                spm_jobman('run',SPMJOB.jobs);
            elseif SPMversion==8  %YAN Chao-Gan, 090925. SPM8 compatible.
                SPMJOB.jobs = spm_jobman('spm5tospm8',{SPMJOB.jobs});
                spm_jobman('run',SPMJOB.jobs{1});
            else
                uiwait(msgbox('The current SPM version is not supported by DPARSF. Please install SPM5 or SPM8 first.','Invalid SPM Version.'));
                Error=[Error;{['Error in Normalize: The current SPM version is not supported by DPARSF. Please install SPM5 or SPM8 first.']}];
            end
            
        end
        
        if (AutoDataProcessParameter.IsNormalize==3) %Normalization by using DARTEL %YAN Chao-Gan, 111111.
            
            SPMJOB = load([ProgramPath,filesep,'Jobmats',filesep,'Dartel_NormaliseToMNI_FewSubjects.mat']);
            
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.fwhm=[0 0 0];
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.preserve=0;
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.bb=AutoDataProcessParameter.Normalize.BoundingBox;
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.vox=AutoDataProcessParameter.Normalize.VoxSize;
            
            DirImg=dir([AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgNewSegment',filesep,AutoDataProcessParameter.SubjectID{1},filesep,'Template_6.*']);
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.template={[AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgNewSegment',filesep,AutoDataProcessParameter.SubjectID{1},filesep,DirImg(1).name]};
            
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subj(1,1).images=FileList;
            
            DirImg=dir([AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgNewSegment',filesep,AutoDataProcessParameter.SubjectID{i},filesep,'u_*']);
            SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subj(1,1).flowfield={[AutoDataProcessParameter.DataProcessDir,filesep,'T1ImgNewSegment',filesep,AutoDataProcessParameter.SubjectID{i},filesep,DirImg(1).name]};

            spm_jobman('run',SPMJOB.matlabbatch);
        end
    end
    

    %Copy the Normalized results to ResultsW
    for iFunSession=1:AutoDataProcessParameter.FunctionalSessionNumber
        parfor iMeasure=1:length(MeasureSet)
            mkdir([AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,'W',filesep,MeasureSet{iMeasure}])
            movefile([AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,filesep,MeasureSet{iMeasure},filesep,'w*'],[AutoDataProcessParameter.DataProcessDir,filesep,FunSessionPrefixSet{iFunSession},AutoDataProcessParameter.StartingDirName,'W',filesep,MeasureSet{iMeasure}])
            fprintf(['Moving Normalized Files:',MeasureSet{iMeasure},' OK']);
        end
        fprintf('\n');
    end
    AutoDataProcessParameter.StartingDirName=[AutoDataProcessParameter.StartingDirName,'W']; %Now StartingDirName is with new suffix 'W'
    
    
end
if ~isempty(Error)
    disp(Error);
    return;
end

