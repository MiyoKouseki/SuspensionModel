function [Filt,SW,MTRX] = getCurrentLiveFilt_TypeA(optic, freq, GPStime, varargin)
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
mdlfile = 'typeAsimctrl_NB_upgrade';
liveParts(mdlfile,GPStime,duration,freq);
%%
Filt = containers.Map;
SW = containers.Map;
MTRX = containers.Map;
WS = 'base';
OnlineData = GWData;
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

%% TM SW
switchname = ['K1:VIS-',optic,'_TM_CAS_SW'];
num = OnlineData.fetch(GPStime,1,switchname);
SW('TM_CAS') = num(1);

%% IM TMOLDAMP
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

%% IM PSDAMP
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


%% IM LOCK
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['IM_LOCK_',dof];
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

%% MN TMOLDAMP
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

%% MN LOCK
DOF = ['L','P','Y'];
for dof = DOF
    filtername = ['MN_LOCK_',dof];
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

%% MN PSDAMP
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


%% HIER SWTICH
switchname = ['K1:VIS-',optic,'_HIER_SWITCH'];
num = OnlineData.fetch(GPStime,1,switchname);
SW('HIER_SWITCH') = num(1);

%% BF DAMP
DOF = ['L','T','V','R','P','Y'];
for dof = DOF
    filtername = ['BF_DAMP_',dof];
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

%% GAS DAMP
DOF = {'BF','F3','F2','F1','F0'};
for dof = DOF
    dof = cell2mat(dof);
    filtername = [dof,'_DAMP_GAS'];
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

%% IP DAMP
DOF = ['L','T','Y'];
for dof = DOF
    filtername = ['IP_DAMP_',dof];
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

%% BPCOMB FILTER
DOF = 1:24;
for dof = DOF
    dofstr = num2str(dof,'%02u');
    filtername = ['PAY_OLSERVO_DAMP_P',dofstr];
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

%% BPCOMB MATRIX
matname = ['K1:VIS-',optic,'_PAY_OLSERVO_OL2PK_'];
mat=zeros(24,8);
l = 1:24;
m = 1:8;
for ll = l
    for mm = m
        num = OnlineData.fetch(GPStime,1,[matname,num2str(ll),'_',num2str(mm)]);
        mat(l,m) = num(1);
    end
end
MTRX('PAY_OLSERVO_OL2PK')=mat;


matname = ['K1:VIS-',optic,'_PAY_OLSERVO_PK2EUL_'];
mat=zeros(18,24);
l = 1:18;
m = 1:24;
for ll = l
    for mm = m
        num = OnlineData.fetch(GPStime,1,[matname,num2str(ll),'_',num2str(mm)]);
        mat(l,m) = num(1);
    end
end
MTRX('PAY_OLSERVO_PK2EUL')=mat;
end