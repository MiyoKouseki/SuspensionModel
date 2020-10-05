function [Filt,SW] = getCurrentLiveFilt_payload(optic, freq, GPStime, varargin)
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

load([optic,'mdl_realparams.mat'],'Stages','actDOFmap','mdlfile');

% [~,cmdout] = system(['caget -t -f1 K1:FEC-20_TIME_DIAG']);
% GPStime = str2double(cmdout)-35;   % time to get data
duration = 1;  % data get time duration

%%
mdlfile = 'typeAsimctrl_payload';
liveParts(mdlfile,GPStime,duration,freq);
%%
Filt = containers.Map;
SW = containers.Map;
WS = 'base';
%% Load filter parameters

%% TM
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['TM_DAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end

%% TM SERVO
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['TM_SERVO_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end

%% TM LOCK
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['TM_LOCK_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end

%% IM
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['IM_TMOLDAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end


%% MN
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['MN_TMOLDAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end


%% MNOL
DOF = ['P','Y'];
for dof = DOF
    filtername = ['MN_MNOLDAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end

%% IMPS
DOF = ['L','T','V','R','P','Y'];
for dof = DOF
    filtername = ['IM_PSDAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end

%% MNPS
DOF = ['L','T','V','R','P','Y'];
for dof = DOF
    filtername = ['MN_PSDAMP_',dof];
    filterswitch = findFilterSwitch(['K1:VIS-',optic,'_',filtername],GPStime);
    filtinfo = evalin('base',['Filt_',filtername]);
    Filt(filtername) = filtinfo.gain;
    for l = 1:10
        if filterswitch(l) == 1
            filt_tmp = eval(['filtinfo.fm',num2str(l)]);
            Filt(filtername) = Filt(filtername)*filt_tmp;
        end
    end
end


%% SWITCH
%CAS
OnlineData = GWData;
PVname = ['K1:VIS-',optic,'_TM_CAS_SW'];
[data,~] = OnlineData.fetch(GPStime,duration,PVname);
SW('TM_CAS') = data(1);


end