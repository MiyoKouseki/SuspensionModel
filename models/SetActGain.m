% ----------------------------------------------------------------------
% Type-B for KAGRA
% Coded by A Shoda on 2018/4/3
% ----------------------------------------------------------------------
% This code is for adjusting the gain_act numbers
% ----------------------------------------------------------------------

%% PRELIMINARY
clear all;                     % Clear workspace
close all;                     % Close plot windows
addpath('../utils');      % Add path to utilities
addpath('./parameters');        % Add path to servo
addpath('./controllers');
g = 9.81;                      % Gravity constant
freq=logspace(-2,2.5,1001);

%% Mapping stages and DOFs in simulink

Stages = {'TM','IM','MN','BF','F3','F2','F1','F0','IP'};
DOFs = {{'L','P','Y'},{'L','T','V','R','P','Y'},{'L','T','V','R','P','Y'},{'GAS','L','T','V','R','P','Y'},{'GAS'},{'GAS'},{'GAS'},{'GAS'},{'L','T','Y'}};
Sensors = {{'OpLev'},{'PS'},{'PS','OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT','GEO'}};
% Stages = {'TM','IM','MN','BF','F3','F0','IP'};
% DOFs = {{'L','P','Y'},{'L','T','V','R','P','Y'},{'L','T','V','R','P','Y'},{'GAS','L','T','V','R','P','Y'},{'GAS'},{'GAS'},{'L','T','Y'}};
% Sensors = {{'OpLev'},{'PS'},{'PS','OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT','GEO'}};

actDOFmap = containers.Map(Stages,DOFs);
sensormap = containers.Map(Stages,Sensors);

%% MODEL IMPORT
addpath('./sumcon/matlab');
sus_typeA;
sys1 = ss(ssA,ssB,ssC,ssD,'InputName',varinput,'OutputName',varoutput);
typeA_safe;    % Import default servo filters
mdlfile='ctrl_typeA';
st     =linmod(mdlfile);          % Linearize simulink model
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% Normalize the actuator gain using local sensors at 0 Hz

for i = 1:numel(Stages)
    stage = char(Stages(i));
    act_port = strcat('exc_',stage,actDOFmap(stage));
    sensor = sensormap(stage);
    if length(sensor) >= 2
        sensor = sensor(1);
    end
    mon_port = strcat(sensor,'_',stage,actDOFmap(stage));
    for k = 1:numel(act_port)
        valname = strcat('gain_act',stage,actDOFmap(stage));
        [mag,~] = bodesus(sysc0,act_port(k),mon_port(k),freq);
        DCgain = mean(mag(:,20));
        currentGain = eval(char(valname(k)));
        NewGain = currentGain/DCgain;
        assignin('base',char(valname(k)),NewGain);
    end
end
optic = 'typeA';
save(strcat(optic,'_safe.mat'));

%% Check TFs

% clear all;                     % Clear workspace
% close all;                     % Close plot windows
% addpath('D:\OneDrive\Documents\phys\src\DttData');
% addpath('../../utility');      % Add path to utilities
% addpath('servofilter');        % Add path to servo
% addpath('measurement')
% g = 9.81;                      % Gravity constant
% freq=logspace(-2,2.5,1001);

%% Load parameter
% optic = 'ETMY';
% load(strcat(optic,'mdl.mat'));
% load(strcat(optic,'mdl_0params.mat'));
% st     =linmod(mdlfile);          % Linearize simulink model
% invl   =strrep(st.InputName, [mdlfile,'/'],'');
% outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
% sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);
% 
% %%
% for i = 1:numel(Stages)
%     stage = char(Stages(i));
%     act_port = strcat('inj',stage,actDOFmap(stage));
%     sensor = sensormap(stage);
%     if length(sensor) >=2
%         sensor = sensor(1);
%     end
%     mon_port = strcat(sensor,'_',stage,actDOFmap(stage));
%     
%     for k = 1:numel(act_port)
%         bodesusplotopt(sysc0,act_port(k),mon_port(k),freq);
%         
%     end
%     
% end
