% ----------------------------------------------------------------------
% Type-B for KAGRA
% Coded by A Shoda on 2018/4/3
% ----------------------------------------------------------------------
% This code is for adjusting the gain_act numbers
% ----------------------------------------------------------------------

%% PRELIMINARY
clear all;                     % Clear workspace
close all;                     % Close plot windows
addpath('../../utility');      % Add path to utilities
addpath('parameter');        % Add path to servo
addpath('controlmodel');
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
optic = 'ITMY';
load(strcat(optic,'mdl.mat'));  % Import ss model
TypeA_paramNoCtrl180517;    % Import default servo filters
%load(strcat(optic,'mdl_0params.mat'));
mdlfile='TypeA_siso180515';   % typeA ver.180515
st     =linmod(mdlfile);          % Linearize simulink model
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% test

for i = 1:numel(Stages)
    %%
    %i=4;
    stage = char(Stages(i));
    act_port = strcat('inj',stage,actDOFmap(stage));
    sensor = sensormap(stage);
    if length(sensor) >=2
        sensor = sensor(1);
    end
    mon_port = strcat(sensor,'_',stage,actDOFmap(stage));
    %%
    for k = 1:numel(act_port)
        %%
        %k=1;
        valname = strcat('gain_act',stage,actDOFmap(stage));
        [mag,~]=bodesus(sysc0,act_port(k),mon_port(k),freq);
        DCgain = mean(mag(:,20));
        currentGain = eval(char(valname(k)));
        NewGain = currentGain/DCgain;
        assignin('base',char(valname(k)),NewGain);
        
    end
    
end

save(strcat(optic,'mdl_0params.mat'));

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
