%
% Example 
% 

%% 0. Initialize 
clear all;  % Clear workspace
close all;  % Close plot windows
addpath('../utils');

%% 1. Import susmodel from SUMCON
addpath('./sumcon/matlab');
sc_typeA_wHL;
sys1 = ss(ssA,ssB,ssC,ssD,'InputName',varinput,'OutputName',varoutput);

%% 2. Read controller model
addpath('./controllers');
mdlfile = 'ctrl_typeA_wHL';

%% 3. Read controll parameter
addpath('./parameters');
typeA_safe;
linss = linmod(mdlfile); 
invl = strrep(linss.InputName, [mdlfile,'/'],'');
outvl = strrep(linss.OutputName,[mdlfile,'/'],'');
sys_safe = ss(linss.a,linss.b,linss.c,linss.d,'inputname',invl,'outputname',outvl);

%% 4. Plot Transfer Functions
freq = logspace(-2,2,1001);
omega = freq.*(2.0*pi);

inv = 'accGndL';
outv = 'dispTML';
nin = strcmp(sys_safe.InputName,inv);
nout = strcmp(sys_safe.OutputName,outv);
[mag,phs] = mybode(sys_safe(nout,nin),freq);
mag = mag.*omega.*omega; % because the input was acc.

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
ylim([1e-20 1e2]);
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
export_fig('hoge.png')