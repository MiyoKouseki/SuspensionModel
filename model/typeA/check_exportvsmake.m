%% Clear all
clear all;  % Clear workspace
close all;  % Close plot windows

addpath('../../utils');  % Add path to utilities
addpath('./sumcon');
addpath('./param');
addpath('./controlmodel');
%% 
test_180429_20K;   % State-space model converted from SUMCON
% case 1 : 
sys1 = ss(ssA,ssB,ssC,ssD,'InputName',varinput,'OutputName',varoutput);
% case 2 : 
constructsimmodel(...   % CONSTRUCT SIMUKINK BLOCK MODEL
    'test_180429_20K',...         % model name
    sys1,...                   % state-space model
    'sys1',...                  % state-space model name
    varinput,...              % input variables
    varoutput...             % output variables
    );
sys1_exp = sys1;

%% Load hand made model
mdlfile = 'TypeA_siso180515';
TypeA_paramNoCtrl180517
st     =linmod(mdlfile); 
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc_make  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% Load exported model
clear sys1;
sys1 = sys1_exp;
st     =linmod(mdlfile);          % Linearize simulink model
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc_exp  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%% Compare the transfer functions in both models
stages = {'TM','IM','MN','BF','F3','F2','F1','F0','IP'};
dofs = {{'L','P','Y'},{'L','T','V','R','P','Y'},{'L','T','V','R','P','Y'},{'GAS','L','T','V','R','P','Y'},{'GAS'},{'GAS'},{'GAS'},{'GAS'},{'L','T','Y'}};
sensors = {{'OpLev'},{'PS'},{'PS','OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT','GEO'}};

actDOFmap = containers.Map(stages,dofs);
sensormap = containers.Map(stages,sensors);

optic = 'ETMY';
freq = logspace(-2,2,1000);

for i = 1:numel(stages)
    stage = char(stages(i));
    act_port = strcat('inj',stage,actDOFmap(stage));
    sensor = sensormap(stage);
    if length(sensor) >=2
        sensor = sensor(1);
    end
    mon_port = strcat(sensor,'_',stage,actDOFmap(stage));
    
    for k = 1:numel(act_port)
        [mag_m,phase_m]=bodesus(sysc_make,act_port(k),mon_port(k),freq);
        [mag_e,phase_e]=bodesus(sysc_exp,act_port(k),mon_port(k),freq);
        figure;
        subplot(5,1,[1 2 3])
        loglog(freq,mag_m,freq,mag_e)
        hold on;
        grid on;
        legend('make','export')
        title(cell2mat(['TF from ',stage,act_port(k),' to ',stage,mon_port(k)]))
        subplot(5,1,[4 5])
        semilogx(freq,phase_m,freq,phase_e)
        hold on;
        grid on;
    end 
end