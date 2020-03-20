%% function for concatenate the data 

function [LFP,struct_data] = Concatenate_data(path,file,HeadStage)

%Inputs
NbFicher = length(file);
LFP = [];

% Processing 
if HeadStage == 1
    for i = 1:NbFicher
        % Load file 
        fileT=fullfile(path,file{1,i});
        load(fileT)

        % Put the data in a single matrix
        CSPK=[CLFP_001;CLFP_002;CLFP_003;CLFP_004;CLFP_005;CLFP_006;CLFP_007;CLFP_008;CLFP_009;CLFP_010;CLFP_011;CLFP_012;CLFP_013;CLFP_014;CLFP_015;CLFP_016];

        % Create the new matrix
        LFP = [LFP CSPK];
    end
    % Put the variable needed into a output structure
    struct_data = struct('ch_KHz',CLFP_001_KHz,'ch_bitResolution',CLFP_001_BitResolution,'ch_gain', CLFP_001_Gain);

elseif HeadStage == 2
    for i = 1:NbFicher
        % Load file 
        fileT=fullfile(path,file{1,i});
        load(fileT)

        % Put the data in a single matrix
        CSPK=[CLFP_017;CLFP_018;CLFP_019;CLFP_020;CLFP_021;CLFP_022;CLFP_023;CLFP_024;CLFP_025;CLFP_026;CLFP_027;CLFP_028;CLFP_029;CLFP_030;CLFP_031;CLFP_032];

        % Create the new matrix
         LFP = [LFP CSPK];
    end 
     % Put the variable needed into a output structure
    struct_data = struct('ch_KHz',CLFP_017_KHz,'ch_bitResolution',CLFP_017_BitResolution,'ch_gain', CLFP_017_Gain);

else 
    disp('There are an issue with the number of the head stage')
end 
end