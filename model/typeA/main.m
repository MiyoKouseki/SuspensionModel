
%% Initialize 
clear all;  % Clear workspace
%close all;  % Close plot windows
addpath('../../utils');  % Add path to utilities
addpath('./param');  % Add path to utilities


%% Import susmodel
matfile='susmodel';
matfile='ETMXmdl_realparams';
matfile='etmx';
load([matfile,'.mat']);


%% Read and Save the No Control Configurations
param_noctrl; 
mdlfile = 'controlmodel';
linss = linmod(mdlfile);
save('./linmod/noctrl.mat','linss');

%% Read and Save the IP_dcDAMP Configurations
param_ipdcdamp; 
mdlfile = 'controlmodel';
linss = linmod(mdlfile);
save('./linmod/ipdcdamp.mat','linss');
servoIPL_st = struct(servoIPL);
save('./servo/servoIPL.mat','servoIPL_st')
%
gainIPL = 0;
mdlfile = 'controlmodel';
linss = linmod(mdlfile);
save('./linmod/ipdcdamp_oltf.mat','linss');

%%
%% Read and Save the IP_dcDAMP Configurations
param_ipdcbfdamp; 
mdlfile = 'controlmodel';
linss = linmod(mdlfile);
save('./linmod/ipdcbfdamp.mat','linss');
%servoIPL_st = struct(servoIPL);
servoBFL_st = struct(servoBFL);
%save('./servo/servoIPL.mat','servoIPL_st')
save('./servo/servoBFL.mat','servoBFL_st')
%
gainIPL = 0;
gainBFL = 0;
mdlfile = 'controlmodel';
linss = linmod(mdlfile);
save('./linmod/ipdcbfdamp_oltf.mat','linss');

%% Main
in_name = strrep(linss.InputName, [mdlfile,'/'],'');
out_name = strrep(linss.OutputName,[mdlfile,'/'],'');
sys = ss(linss.a,linss.b,linss.c,linss.d,'inputname',in_name,'outputname',out_name);

%% Plot
freq =logspace(-2,1,1001);

% %% PLOT SERVO FILTER ----------------------------------------------------------------
% servo_name = 'IPdcdamp';
% 
% % TRANSFER FUNCTION F0
% % mybodeplot({servoIPL},freq,{'IPL'});
% % export_fig(sprintf('./huge.png'))
% 
% %%
% inv='accGndL';
% outv='dispTML';
% %outv='GEO_IPL';
% %outv='dispGndL';
% inv='accGndL';
% outv='dispTML';
% unit='m';
% ylabelarg=['Magnitude ',unit];
% nin=strcmp(sys.InputName,inv);
% nout=strcmp(sys.OutputName,outv);
% % TRANSFER FUNCTION
% calib=1;
% siso = sys(nout,nin);
% [mag,phs] = mybode(sys(nout,nin)*calib,freq);
% 
% fig=figure;
% subplot(5,1,[1 2 3])
% colorarg={'-k','-b','bo'};
% loglog(freq,mag,colorarg{1},'LineWidth',2)
% grid on
% titlearg=['Transfer Function Bode Plot',' from ',inv,' to ',outv]
% title(titlearg,'FontSize',15,'FontWeight','bold','FontName','Times New Roman','interpreter','none')
% ylabel(ylabelarg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% set(gca,'FontSize',12,'FontName','Times New Roman')
% fg_y=0;
% if fg_y; ylim(ylimarg); end;
% ylim([1e-20 1e2]);
% xlim([freq(1),freq(end)])
% legendarg={'model','measurement'}
% legend(legendarg)
%   
% subplot(5,1,[4 5])
% semilogx(freq,phs,colorarg{1},'LineWidth',2,'MarkerSize',2)
% grid on
% ylim([-180 180])
% xlim([freq(1),freq(end)])
% ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% set(gca,'FontSize',12,'FontName','Times New Roman')
% set(gca,'YTick',-180:90:180)
% positionarg=[50, 50, 850, 650];
% set(fig,'Position', positionarg);
% set(fig,'Color','white');
% export_fig('hoge.png')
% %%
% 
