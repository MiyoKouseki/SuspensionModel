function Filt = getCurrentLiveFilt(optic, freq, GPStime, varargin)
% getCurrentLiveFilt gives you the Filter map of the local controls.
% Currently only available for Type-B and Type-Bp
% Filt = getCurrentLiveFilt(optic, freq, varagin)
% optic: optic to be loaded (i.e., 'BS')
% freq: any frequency array
% GPStime: specify the GPStime to get the data.

addpath(genpath('/kagra/kagranoisebudget/Common/Utils'));
addpath(genpath('/kagra/kagranoisebudget/Dev/Utils'));
addpath(genpath('/kagra/Dropbox/Subsystems/VIS/Scripts/SuspensionControlModel/script/SUS'))
addpath(genpath('/kagra/Dropbox/Subsystems/VIS/Scripts/SuspensionControlModel/utility'));
%%

load([optic,'mdl_realparams_damped.mat'],'Stages','actDOFmap','mdlfile');

% [~,cmdout] = system(['caget -t -f1 K1:FEC-20_TIME_DIAG']);
% GPStime = str2double(cmdout)-35;   % time to get data
duration = 1;  % data get time duration

%%

liveParts(mdlfile,GPStime,duration,freq);

Filt = containers.Map;
WS = 'base';
%% Load filter parameters
% for local damping
for i = 1:numel(Stages)
    stage = char(Stages(i));
    DOF = actDOFmap(stage);
    FiltName = strcat(stage,'_DAMP_',char(DOF));
    for k = 1:length(DOF)
        FName_k = strtrim(FiltName(k,:));
        filterswitch = findFilterSwitch(strcat('K1:VIS-',optic,'_',FName_k),GPStime);
        Filtcont_tmp = evalin('base',['Filt_',FName_k]);
        Filt(FName_k) = Filtcont_tmp.gain;
        for l = 1:10
            if filterswitch(l) == 1
                 filt_tmp = eval(['Filtcont_tmp.fm',num2str(l)]);
                 Filt(FName_k) = Filt(FName_k)*filt_tmp;
            end
        end
    end
end

%% IP BLEND
if strncmp(optic, 'PR', 2) == 0
    stage = 'IP';
    DOF = actDOFmap(stage);
    FiltNameLVDT = strcat(stage,'_BLEND_LVDT',char(DOF));
    FiltNameACC = strcat(stage,'_BLEND_ACC',char(DOF));
    for k = 1:length(DOF)
        FnameLVDT_k = strtrim(FiltNameLVDT(k,:));
        FnameACC_k = strtrim(FiltNameACC(k,:));
        filterswLVDT = findFilterSwitch(strcat('K1:VIS-',optic,'_',FnameLVDT_k),GPStime);
        filterswACC = findFilterSwitch(strcat('K1:VIS-',optic,'_',FnameACC_k),GPStime);
        FiltcontLVDT_tmp = evalin('base',['Filt_',FnameLVDT_k]);
        FiltcontACC_tmp = evalin('base',['Filt_',FnameACC_k]);
        Filt(FnameLVDT_k) = FiltcontLVDT_tmp.gain;
        Filt(FnameACC_k) = FiltcontACC_tmp.gain;
        for l = 1:10
            if filterswLVDT(l) == 1
                filt_tmp = eval(['FiltcontLVDT_tmp.fm',num2str(l)]);
                Filt(FnameLVDT_k) = Filt(FnameLVDT_k)*filt_tmp;
            end
            if filterswACC(l) == 1
                filt_tmp = eval(['FiltcontACC_tmp.fm',num2str(l)]);
                Filt(FnameACC_k) = Filt(FnameACC_k)*filt_tmp;
            end
        end
    end
end

%% OL
filterswitch = findFilterSwitch(['K1:VIS-',optic,'_IM_OLDAMP_P'],GPStime);
Filt_IM_OLDAMP_P = evalin('base','Filt_IM_OLDAMP_P');
Filt('IM_OLDAMP_P') = Filt_IM_OLDAMP_P.gain;
for l = 1:10
    if filterswitch(l) == 1
        filt_tmp = eval(['Filt_IM_OLDAMP_P.fm',num2str(l)]);
        Filt('IM_OLDAMP_P') = Filt('IM_OLDAMP_P')*filt_tmp;
    end
end

filterswitch = findFilterSwitch(['K1:VIS-',optic,'_IM_OLDAMP_Y'],GPStime);
Filt_IM_OLDAMP_Y = evalin('base','Filt_IM_OLDAMP_Y');
Filt('IM_OLDAMP_Y') = Filt_IM_OLDAMP_Y.gain;
for l = 1:10
    if filterswitch(l) == 1
        filt_tmp = eval(['Filt_IM_OLDAMP_Y.fm',num2str(l)]);
        Filt('IM_OLDAMP_Y') = Filt('IM_OLDAMP_Y')*filt_tmp;
    end
end

filterswitch = findFilterSwitch(['K1:VIS-',optic,'_TM_OPLEV_SERVO_LEN'],GPStime);
Filt_OL_SERVO_L = evalin('base','Filt_OL_SERVO_L');
Filt('TM_OPLEV_SERVO_L') = Filt_OL_SERVO_L.gain;
for l = 1:10
    if filterswitch(l) == 1
        filt_tmp = eval(['Filt_OL_SERVO_L.fm',num2str(l)]);
        Filt('TM_OPLEV_SERVO_L') = Filt('TM_OPLEV_SERVO_L')*filt_tmp;
    end
end

filterswitch = findFilterSwitch(['K1:VIS-',optic,'_TM_OPLEV_SERVO_PIT'],GPStime);
Filt_OL_SERVO_P = evalin('base','Filt_OL_SERVO_P');
Filt('TM_OPLEV_SERVO_P') = Filt_OL_SERVO_P.gain;
for l = 1:10
    if filterswitch(l) == 1
        filt_tmp = eval(['Filt_OL_SERVO_P.fm',num2str(l)]);
        Filt('TM_OPLEV_SERVO_P') = Filt('TM_OPLEV_SERVO_P')*filt_tmp;
    end
end

filterswitch = findFilterSwitch(['K1:VIS-',optic,'_TM_OPLEV_SERVO_YAW'],GPStime);
Filt_OL_SERVO_Y = evalin('base','Filt_OL_SERVO_Y');
Filt('TM_OPLEV_SERVO_Y') = Filt_OL_SERVO_Y.gain;
for l = 1:10
    if filterswitch(l) == 1
        filt_tmp = eval(['Filt_OL_SERVO_Y.fm',num2str(l)]);
        Filt('TM_OPLEV_SERVO_Y') = Filt('TM_OPLEV_SERVO_Y')*filt_tmp;
    end
end


end