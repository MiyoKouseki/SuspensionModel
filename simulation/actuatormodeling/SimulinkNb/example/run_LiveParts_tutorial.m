% Tutorial for Noise Budget LiveParts
%         By Masayuki Nakano

%% Add paths
clear all
close all
findNbSVNroot;  % find the root of Simulink NB
addpath(genpath([NbSVNroot 'Common/Utils']));
addpath(genpath([NbSVNroot 'Dev/Utils/']));

%%
% Get the parameters of liveparts (LiveFilter, LiveMatrix, LiveConstant)
liveParts('LiveParts_tutorial',1144558290,10,logspace(1,3)); 

% Display result
disp('Live Filter');
disp(k1imc_mcl_servo);
disp('LiveMatrix')
disp(k1imc_mcl_output_mtrx)
disp('Live Constant')
disp(Live_Constant);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can get great GUI to modify a Live Filter parameters if you click
% the check box of 'Click to view/edit config' in the Block Parameters
% window which open when you double click a Live Filter Box