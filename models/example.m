%
% Example 
% 

%% 0. Initialize 
clear all;  % Clear workspace
close all;  % Close plot windows
addpath('../utils');
%optic = 'ETMX';
optic = 'BS';
%optic = 'PR2';

%% 1. Import susmodel from SUMCON
addpath('./sumcon/matlab');
run(strcat('sus_',optic,'.m'))
sys1 = ss(ssA,ssB,ssC,ssD,'InputName',varinput,'OutputName',varoutput);

%% 2. Read controller model
addpath('./controllers');
addpath('./parameters');

if contains(['PRM','PR3','PR2'],optic)
    mdlfile = 'ctrl_typeBp';
    run('typeBp_safe.m');
elseif contains(['BS','SRM','SR3','SR2'],optic)
    mdlfile = 'ctrl_typeB';
    run('typeB_safe.m');
elseif contains(['ETMX','ETMY','ITMX','ITMY'],optic)
    mdlfile = 'ctrl_typeA';
    run('typeA_safe.m');
end

%% 3. Read controll parameter
linss = linmod(mdlfile);
invl = strrep(linss.InputName, [mdlfile,'/'],'');
outvl = strrep(linss.OutputName,[mdlfile,'/'],'');
sys_safe = ss(linss.a,linss.b,linss.c,linss.d,'inputname',invl,'outputname',outvl);
save(strcat('./abcd/',optic,'_safe.mat'),'linss')

%% 4. Plot Transfer Functions
freq = logspace(-2,2,1001);
omega = freq.*(2.0*pi);

inv = 'exc_IML'
%inv = 'accGndL';

stage = 'IM';
dof = 'L';
if contains(['IM','MN'],stage)
    if contains(['ETMX','ETMY','ITMX','ITMY'],optic)
        sensor = 'PS';
    else
        sensor = 'OSEM';
    end
end
outv = strcat(sensor,'_',stage,dof);
%outv = 'dispTML'

nin = strcmp(sys_safe.InputName,inv);
nout = strcmp(sys_safe.OutputName,outv);
[mag,phs] = mybode(sys_safe(nout,nin),freq);
%mag = mag.*omega.*omega; % because the input was acc.
%phs = rad2deg(wrapToPi(deg2rad(phs) - pi));

fig = figure;
subplot(5,1,[1 2 3]);
colorarg={'-k','-b','bo'};
loglog(freq,mag,colorarg{1},'LineWidth',2)
grid on
titlearg=['Transfer Function Bode Plot',' from ',inv,' to ',outv];
title(titlearg,'FontSize',15,'FontWeight','bold','FontName','Times New Roman','interpreter','none')
ylabelarg = ['Magnitude ','m'];
ylabel(ylabelarg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
fg_y=0;
if fg_y; ylim(ylimarg); end;
ylim([1e-10 1e2]);
xlim([freq(1),freq(end)])
legendarg={'safe'};
legend(legendarg)
  
subplot(5,1,[4 5])
semilogx(freq,phs,colorarg{1},'LineWidth',2,'MarkerSize',2)
grid on
ylim([-180 180])
xlim([freq(1),freq(end)])
ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
set(gca,'YTick',-180:90:180)
positionarg=[50, 50, 850, 650];
set(fig,'Position', positionarg);
set(fig,'Color','white');
export_fig('example.png')