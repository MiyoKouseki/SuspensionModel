% ----------------------------------------------------------------------
% Type-Bp for KAGRA
% Coded by A Shoda on 2017/10/27
% ----------------------------------------------------------------------
% Get the actuation efficiency [cnt/m] & [N/cnt]
% Note: gain_act_** is [N/m] obtained from the simulation
% ----------------------------------------------------------------------
%% Add path
clear all;                     % Clear workspace
close all;                     % Close plot windows
addpath('D:\OneDrive\Documents\phys\src\DttData');
addpath('../../utility');      % Add path to utilities
addpath('parameter');        % Add path to servo
addpath('controlmodel');
addpath(genpath('measurement'))
g = 9.81;                      % Gravity constant
freq=logspace(-2,2.5,1001);

%% Load parameter

optic = 'ITMY';
load(strcat(optic,'mdl_0params.mat'));
%load(strcat('TypeAtmp_modmdl_0params.mat'));
%optic = 'ITMX';
measdir = ['./measurement/',optic,'/'];
%mdlfile = 'TypeA_siso180515';
st     =linmod(mdlfile);          % Linearize simulink model
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

%Stages = {'TM','IM','MN','BF','F3','F2','F1','F0','IP'};
%DOFs = {{'L','P','Y'},{'L','P','Y'},{'P','Y'},{'L','T','Y','GAS'},{'GAS'},{'GAS'},{'GAS'},{'GAS'},{'L','T','Y'}};
%Sensors = {{'OpLev'},{},{'OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'}};
%%%%% for ETMY %%%%%
%  Stages = {'TM','IM','MN','BF','F3','F0','IP'};
%  DOFs = {{'L','P','Y'},{'L','P','Y'},{'P','Y'},{'L','T','Y','GAS'},{'GAS'},{'GAS'},{'L','T','Y'}};
%  Sensors = {{'OpLev'},{},{'OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'}};
%%%%%%%%%%%%%%%%%%%%
%%%%% for ITMs %%%%%
 Stages = {'TM','IM','MN','BF','F3','F2','F1','IP'};
 DOFs = {{'L','P','Y'},{'L','P','Y'},{'P','Y'},{'L','T','Y','GAS'},{'GAS'},{'GAS'},{'GAS'},{'L','T','Y'}};
 Sensors = {{'OpLev'},{},{'OpLev'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'}};
%%%%%%%%%%%%%%%%%%%%
actDOFmap = containers.Map(Stages,DOFs);
sensormap = containers.Map(Stages,Sensors);

%% For TM
stage = 'TM';
act_port = strcat('inj',stage,actDOFmap(stage));
mon_port = strcat(sensormap(stage),'_',stage,actDOFmap(stage));
if length(act_port) ~= length(mon_port)
    print('ERROR: SIZE OF THE DICTIONARY MISMATCH')
end
dof = actDOFmap(stage);
%filename = strcat('./measurement/PR3/TF_',stage,actDOFmap(stage),'.xml');

% k=1;
% listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
% filename = [measdir,listing.name];
% data = DttData(char(filename));
% chA = strcat('K1:VIS-',optic,'_',stage,'_TEST_L_EXC');
% %chB = strcat('K1:VIS-',optic,'_',stage,'_OPLEV_LEN_YAW_OUT');
% chB = strcat('K1:VIS-',optic,'_',stage,'_OPLEV_LEN_DIAG');
% [fr,tf] = transferFunction(data, char(chA), char(chB));
% [fr,coh] = coherence(data, char(chA), char(chB));
% 
% [mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);
% 
% A = [];
% for i = 1:length(fr)
%     if coh(i) > 0.95 && fr(i)<1
%        A = [A, mag(i)/abs(tf(i))]; 
%     end
% end
% Aav = mean(A);
% Asig = cov(A);
% 
% 
% titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
% fig=figure;
% subplot(5,1,[1 2 3])
% loglog(fr,mag./Aav,'LineWidth',2)
% ylim([1E-6 1E+2]);
% grid on
% hold on
% loglog(fr,abs(tf),'r.', 'LineWidth',2)
% title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
%     'interpreter','none')
% ylabel('Magnitude[um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% set(gca,'FontSize',12,'FontName','Times New Roman')
% legend('simulation','Measured','Location','southwest')
% 
% subplot(5,1,[4 5])
% semilogx(fr,phs,'LineWidth',2)
% grid on
% ylim([-180 180])
% hold on
% semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
% ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
% set(gca,'FontSize',12,'FontName','Times New Roman')
% set(gca,'YTick',-180:90:180)
% set(fig,'Color','white')
% 
% valname = strcat('gain_act_',actDOFmap(stage),stage);
% B = eval(char(valname(k))); %[N/m]
% Eff = B/Aav/1E+6; %[N/cnt]
% Effsig = B/1E+6*(Asig^2/Aav^2);
% 
% assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);
% 
% X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
% disp(X)

%%
k=2;
listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
filename = [measdir,listing.name];
%%
data = DttData(char(filename));
%%
ChAsuf1 = strcat('K1:VIS-',optic,'_',stage,'_TEST_',char(dof(k)),'_EXC');
ChAsuf2 = strcat('K1:VIS-',optic,'_',stage,'_DAMP_',char(dof(k)),'_EXC');
Is_ChA1 = strfind(data.channels,ChAsuf1);
Is_ChA2 = strfind(data.channels,ChAsuf2);
for chs = 1:length(Is_ChA1)
    if ~isempty(cell2mat(Is_ChA1(chs)))
        Ind_ChA=chs;
        break
    elseif ~isempty(cell2mat(Is_ChA2(chs)))
        Ind_ChA=chs;
        break
    end
end
chA = cell2mat(data.channels(Ind_ChA));

ChBsuf1 = strcat(stage,'_OPLEV_TILT_',char(dof(k)));
ChBsuf2 = strcat(stage,'_DAMP_',char(dof(k)));
Is_ChB1 = strfind(data.channels,ChBsuf1);
Is_ChB2 = strfind(data.channels,ChBsuf2);
for chs = 1:length(Is_ChB1)
    if ~isempty(cell2mat(Is_ChB1(chs)))
        Ind_ChB=chs;
        break
    elseif ~isempty(cell2mat(Is_ChB2(chs)))
        Ind_ChB=chs;
        break
    end
end
chB = cell2mat(data.channels(Ind_ChB));

[fr,tf] = transferFunction(data, char(chA), char(chB));
[fr,coh] = coherence(data, char(chA), char(chB));

[mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);

A = [];
for i = 1:length(fr)
    if coh(i) > 0.95 && fr(i)<1
       A = [A, mag(i)/abs(tf(i))]; 
    end
end
Aav = mean(A);
Asig = cov(A);

titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
fig=figure;
subplot(5,1,[1 2 3])
loglog(fr,mag./Aav,'LineWidth',2)
ylim([1E-6 1E+2]);
grid on
hold on
loglog(fr,abs(tf),'r.', 'LineWidth',2)
title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
    'interpreter','none')
ylabel('Magnitude[um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
legend('simulation','Measured','Location','southwest')

subplot(5,1,[4 5])
semilogx(fr,phs,'LineWidth',2)
grid on
ylim([-180 180])
hold on
semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
set(gca,'YTick',-180:90:180)
set(fig,'Color','white')

figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
saveas(fig,cell2mat(figname))

valname = strcat('gain_act',stage,actDOFmap(stage));
B = eval(char(valname(k))); %[N/m]
Eff = B/Aav/1E+6; %[N/cnt]
Effsig = B/1E+6*(Asig^2/Aav^2);

assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);

X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
disp(X)

%%
k=3;
listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
filename = [measdir,listing.name];
data = DttData(char(filename));
chA = strcat('K1:VIS-',optic,'_',stage,'_TEST_Y_EXC');

ChBsuf1 = strcat(stage,'_OPLEV_TILT_',char(dof(k)));
ChBsuf2 = strcat(stage,'_DAMP_',char(dof(k)));
Is_ChB1 = strfind(data.channels,ChBsuf1);
Is_ChB2 = strfind(data.channels,ChBsuf2);
for chs = 1:length(Is_ChB1)
    if ~isempty(cell2mat(Is_ChB1(chs)))
        Ind_ChB=chs;
        break
    elseif ~isempty(cell2mat(Is_ChB2(chs)))
        Ind_ChB=chs;
        break
    end
end
chB = cell2mat(data.channels(Ind_ChB));

[fr,tf] = transferFunction(data, char(chA), char(chB));
[fr,coh] = coherence(data, char(chA), char(chB));

[mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);

A = [];
for i = 1:length(fr)
    if coh(i) > 0.95 && fr(i)<6 && fr(i)>1
       A = [A, mag(i)/abs(tf(i))]; 
    end
end
Aav = mean(A);
Asig = cov(A);


titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
fig=figure;
subplot(5,1,[1 2 3])
loglog(fr,mag./Aav,'LineWidth',2)
ylim([1E-6 1E+2]);
grid on
hold on
loglog(fr,abs(tf),'r.', 'LineWidth',2)
title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
    'interpreter','none')
ylabel('Magnitude [um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
legend('simulation','Measured','Location','southwest')

subplot(5,1,[4 5])
semilogx(fr,phs,'LineWidth',2)
grid on
ylim([-180 180])
hold on
semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
set(gca,'YTick',-180:90:180)
set(fig,'Color','white')

figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
saveas(fig,cell2mat(figname))

valname = strcat('gain_act',stage,actDOFmap(stage));
B = eval(char(valname(k))); %[N/m]
Eff = B/Aav/1E+6; %[N/cnt]
Effsig = B/1E+6*(Asig^2/Aav^2);

assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);

X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
disp(X)

%% For IM and above
%Sensors = {{'OpLev'},{'OSEM'},{'LVDT'},{'LVDT'},{'LVDT'},{'LVDT'}};
%sensormap = containers.Map(Stages,Sensors);

%% For IM
i=2;
stage = char(Stages(i));
act_port = strcat('inj',stage,actDOFmap(stage));
mon_port = strcat('OpLev_TM',actDOFmap(stage));
if length(act_port) ~= length(mon_port)
    print('ERROR: SIZE OF THE DICTIONARY MISMATCH')
end

dof = actDOFmap(stage);

for k = 2:3

    listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
    filename = [measdir,listing.name];
    data = DttData(char(filename));
    
    ChAsuf1 = strcat('K1:VIS-',optic,'_',stage,'_TEST_',char(dof(k)),'_EXC');
    ChAsuf2 = strcat('K1:VIS-',optic,'_',stage,'_DAMP_',char(dof(k)),'_EXC');
    Is_ChA1 = strfind(data.channels,ChAsuf1);
    Is_ChA2 = strfind(data.channels,ChAsuf2);
    for chs = 1:length(Is_ChA1)
        if ~isempty(cell2mat(Is_ChA1(chs)))
            Ind_ChA=chs;
            break
        elseif ~isempty(cell2mat(Is_ChA2(chs)))
            Ind_ChA=chs;
            break
        end
    end
    chA = cell2mat(data.channels(Ind_ChA));
    
    %chB = strcat('K1:VIS-',optic,'_',stage,'_OPLEV_TILT_YAW_OUT_DQ');
    chB = strcat('K1:VIS-',optic,'_TM_DAMP_',char(dof(k)),'_IN1_DQ');
    %chB = strcat('K1:VIS-',optic,'_',stage,'_OPLEV_YAW_DIAG');
    
    ChBsuf1 = strcat(optic,'_TM_DAMP_',char(dof(k)));
    ChBsuf2 = strcat(optic,'_TM_OPLEV_TILT_',char(dof(k)));
    Is_ChB1 = strfind(data.channels,ChBsuf1);
    Is_ChB2 = strfind(data.channels,ChBsuf2);
    for chs = 1:length(Is_ChB1)
        if ~isempty(cell2mat(Is_ChB1(chs)))
            Ind_ChB=chs;
            break
        elseif ~isempty(cell2mat(Is_ChB2(chs)))
            Ind_ChB=chs;
            break
        end
    end
    chB = cell2mat(data.channels(Ind_ChB));
    
    
    [fr,tf] = transferFunction(data, char(chA), char(chB));
    [fr,coh] = coherence(data, char(chA), char(chB));

    [mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);

    A = [];
    for i = 1:length(fr)
        if coh(i) > 0.95 && fr(i)<1
           A = [A, mag(i)/abs(tf(i))]; 
        end
    end
    Aav = mean(A);
    Asig = cov(A);


    titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
    fig=figure;
    subplot(5,1,[1 2 3])
    loglog(fr,mag./Aav,'LineWidth',2)
    ylim([1E-6 1E+2]);
    grid on
    hold on
    loglog(fr,abs(tf),'r.', 'LineWidth',2)
    title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
        'interpreter','none')
    ylabel('Magnitude [um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
    set(gca,'FontSize',12,'FontName','Times New Roman')
    legend('simulation','Measured','Location','southwest')

    subplot(5,1,[4 5])
    semilogx(fr,phs,'LineWidth',2)
    grid on
    ylim([-180 180])
    hold on
    semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
    ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
    xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
    set(gca,'FontSize',12,'FontName','Times New Roman')
    set(gca,'YTick',-180:90:180)
    set(fig,'Color','white')
    
    figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
    saveas(fig,cell2mat(figname))

    valname = strcat('gain_act',stage,actDOFmap(stage));
    B = eval(char(valname(k))); %[N/m]
    Eff = B/Aav/1E+6; %[N/cnt]
    Effsig = B/1E+6*(Asig^2/Aav^2);

    assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);

    X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
    disp(X)
end

%% For MN
i=3;
stage = char(Stages(i));
act_port = strcat('inj',stage,actDOFmap(stage));
mon_port = strcat(sensormap(stage),'_',stage,actDOFmap(stage));
if length(act_port) ~= length(mon_port)
    print('ERROR: SIZE OF THE DICTIONARY MISMATCH')
end
%% MNP
    %%
k=1;
dof = actDOFmap(stage);
listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
filename = [measdir,listing.name];
data = DttData(char(filename));

ChAsuf = '_EXC';
Is_ChA = strfind(data.channels,ChAsuf);
for chs = 1:length(Is_ChA)
    if ~isempty(cell2mat(Is_ChA(chs)))
        Ind_ChA=chs;
        break
    end
end
chA = cell2mat(data.channels(Ind_ChA));

ChBsuf1 = strcat(stage,'_OPLEV_TILT_',char(dof(k)));
ChBsuf2 = strcat(stage,'_MNOLDAMP_',char(dof(k)));
Is_ChB1 = strfind(data.channels,ChBsuf1);
Is_ChB2 = strfind(data.channels,ChBsuf2);
for chs = 1:length(Is_ChB1)
    if ~isempty(cell2mat(Is_ChB1(chs)))
        Ind_ChB=chs;
        break
    elseif ~isempty(cell2mat(Is_ChB2(chs)))
        Ind_ChB=chs;
        break
    end
end
chB = cell2mat(data.channels(Ind_ChB));
%%
[fr,tf] = transferFunction(data, char(chA), char(chB));
[fr,coh] = coherence(data, char(chA), char(chB));
%%
[mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);
%%
A = [];
for i = 1:length(fr)
    if coh(i) > 0.95 && fr(i)<10 && fr(i)>3
       A = [A, mag(i)/abs(tf(i))]; 
    end
end
Aav = mean(A);
Asig = cov(A);


titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
fig=figure;
subplot(5,1,[1 2 3])
loglog(fr,mag./Aav,'LineWidth',2)
ylim([1E-6 1E+2]);
grid on
hold on
loglog(fr,abs(tf),'r.', 'LineWidth',2)
title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
    'interpreter','none')
ylabel('Magnitude[um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
legend('simulation','Measured','Location','southwest')

subplot(5,1,[4 5])
semilogx(fr,phs,'LineWidth',2)
grid on
ylim([-180 180])
hold on
semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
set(gca,'YTick',-180:90:180)
set(fig,'Color','white')

figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
saveas(fig,cell2mat(figname))

valname = strcat('gain_act',stage,actDOFmap(stage));
B = eval(char(valname(k))); %[N/m]
Eff = B/Aav/1E+6; %[N/cnt]
Effsig = B/1E+6*(Asig^2/Aav^2);

assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);

X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
disp(X)
%% MNY

k=2;
dof = actDOFmap(stage);
listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
filename = [measdir,listing.name];
data = DttData(char(filename));

ChAsuf = '_EXC';
Is_ChA = strfind(data.channels,ChAsuf);
for chs = 1:length(Is_ChA)
    if ~isempty(cell2mat(Is_ChA(chs)))
        Ind_ChA=chs;
        break
    end
end
chA = cell2mat(data.channels(Ind_ChA));

ChBsuf = strcat(stage,'_OPLEV_TILT_',char(dof(k)));
Is_ChB = strfind(data.channels,ChBsuf);
for chs = 1:length(Is_ChB)
    if ~isempty(cell2mat(Is_ChB(chs)))
        Ind_ChB=chs;
        break
    end
end
chB = cell2mat(data.channels(Ind_ChB));
%%
[fr,tf] = transferFunction(data, char(chA), char(chB));
[fr,coh] = coherence(data, char(chA), char(chB));
%%
[mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);
%%
A = [];
for i = 1:length(fr)
    if coh(i) > 0.95 && fr(i)<10 && fr(i)>3
       A = [A, mag(i)/abs(tf(i))]; 
    end
end
Aav = mean(A);
Asig = cov(A);

titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
fig=figure;
subplot(5,1,[1 2 3])
loglog(fr,mag./Aav,'LineWidth',2)
ylim([1E-6 1E+2]);
grid on
hold on
loglog(fr,abs(tf),'r.', 'LineWidth',2)
title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
    'interpreter','none')
ylabel('Magnitude[um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
legend('simulation','Measured','Location','southwest')

subplot(5,1,[4 5])
semilogx(fr,phs,'LineWidth',2)
grid on
ylim([-180 180])
hold on
semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
set(gca,'FontSize',12,'FontName','Times New Roman')
set(gca,'YTick',-180:90:180)
set(fig,'Color','white')

figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
saveas(fig,cell2mat(figname))

valname = strcat('gain_act',stage,actDOFmap(stage));
B = eval(char(valname(k))); %[N/m]
Eff = B/Aav/1E+6; %[N/cnt]
Effsig = B/1E+6*(Asig^2/Aav^2);

assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);

X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
disp(X)

%% TOWER

for i = 4:numel(Stages)
    
    %i=9;
    stage = char(Stages(i));
    act_port = strcat('inj',stage,actDOFmap(stage));
    mon_port = strcat(sensormap(stage),'_',stage,actDOFmap(stage));
    
    if length(act_port) ~= length(mon_port)
        print('ERROR: SIZE OF THE DICTIONARY MISMATCH')
    end
    
    for k = 1:numel(act_port)
        
        %k=3;
        dof = actDOFmap(stage);
        listing  = dir([measdir,optic,'_',stage,char(dof(k)),'*.xml']);
        filename = [measdir,listing.name];
        data = DttData(char(filename));
        chA = strcat('K1:VIS-',optic,'_',stage,'_TEST_',char(dof(k)),'_EXC');
        
        ChBsuf2 = strcat('LVDT',char(dof(k)));
        ChBsuf3 = strcat('LVDTINF_',char(dof(k)),'_OUT');
        ChBsuf1 = strcat(stage,'_DAMP_',char(dof(k)));
        Is_ChB1 = strfind(data.channels,ChBsuf1);
        Is_ChB2 = strfind(data.channels,ChBsuf2);
        Is_ChB3 = strfind(data.channels,ChBsuf3);
        Is_stage = strfind(data.channels,stage);
        clear Ind_ChB
        for chs = 1:length(Is_ChB1)
            if ~isempty(cell2mat(Is_ChB1(chs))) && ~isempty(cell2mat(Is_stage(chs)))
                Ind_ChB=chs;
                break
            elseif ~isempty(cell2mat(Is_ChB2(chs))) && ~isempty(cell2mat(Is_stage(chs)))
                Ind_ChB=chs;
                break
            elseif ~isempty(cell2mat(Is_ChB3(chs))) && ~isempty(cell2mat(Is_stage(chs)))
                Ind_ChB=chs;
                break
            end
        end
        chB = cell2mat(data.channels(Ind_ChB));
        
        [fr,tf] = transferFunction(data, char(chA), char(chB));
        [fr,coh] = coherence(data, char(chA), char(chB));

        [mag,phs]=bodesus(sysc0,act_port(k),mon_port(k),fr);

        A = [];
        for ii = 1:length(fr)
            if coh(ii) > 0.95 && fr(ii)<10 && fr(ii)<3
               A = [A, mag(ii)/abs(tf(ii))]; 
            end
        end
        Aav = mean(A);
        Asig = cov(A);
        

        titlearg=['Transfer Function',' from ',char(act_port(k)),' to ',char(mon_port(k))];
        fig=figure;
        subplot(5,1,[1 2 3])
        loglog(fr,mag./Aav,'LineWidth',2)
        ylim([1E-6 1E+2]);
        grid on
        hold on
        loglog(fr,abs(tf),'r.', 'LineWidth',2)
        title(titlearg,'FontSize',12,'FontWeight','bold','FontName','Times New Roman',...
            'interpreter','none')
        ylabel('Magnitude[um or urad/cnt]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
        set(gca,'FontSize',12,'FontName','Times New Roman')
        legend('simulation','Measured','Location','southwest')

        subplot(5,1,[4 5])
        semilogx(fr,phs,'LineWidth',2)
        grid on
        ylim([-180 180])
        hold on
        semilogx(fr,180/pi*angle(tf),'r.', 'LineWidth',2)
        ylabel('Phase [deg]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
        xlabel('Frequency [Hz]','FontSize',12,'FontWeight','bold','FontName','Times New Roman')
        set(gca,'FontSize',12,'FontName','Times New Roman')
        set(gca,'YTick',-180:90:180)
        set(fig,'Color','white')
        
        figname = strcat('./fig/',optic,'/',optic,'_',act_port(k),'.png');
        saveas(fig,cell2mat(figname))
       
        valname = strcat('gain_act',stage,actDOFmap(stage));
        if ~isnan(B)
            B = eval(char(valname(k))); %[N/m]
        end
        Eff = B/Aav/1E+6; %[N/cnt]
        Effsig = B/1E+6*(Asig^2/Aav^2);
        
        assignin('base',char(valname(k)),eval(char(valname(k)))/Aav);
        
        X = ['Actuation efficiency of ', char(act_port(k)),': ', num2str(Eff),'(+/- ',num2str(Effsig),') [N/cnt]'];
        disp(X)
    end
end


%%
st     =linmod(mdlfile);          % Linearize simulink model
invl   =strrep(st.InputName, [mdlfile,'/'],'');
outvl  =strrep(st.OutputName,[mdlfile,'/'],'');
sysc0  =ss(st.a,st.b,st.c,st.d,'inputname',invl,'outputname',outvl);

save([optic,'mdl_realparams.mat'])
