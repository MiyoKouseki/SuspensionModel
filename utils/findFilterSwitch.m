function val = findFilterSwitch(filterbank, GPStime)
% Coded by A.Shoda updated on 2018.6.1
% Get the filter bank on/off information using 'GWdata.fetch' at the specified GPS time.
% Give the name of the filterbank, such as 'K1:VIS-PR3_IM_DAMP_L'
% The return value is a matrix with 10 columns.
% The numbers of each colums represent on or off of the each filters.
% On is 1, off is 0.

%% Load GWdata
addpath(genpath('/kagra/kagranoisebudget/Common/Utils'));
addpath(genpath('/kagra/kagranoisebudget/Dev/Utils'));

duration = 1;
OnlineData = GWData;

%%
val = [0,0,0,0,0,0,0,0,0,0]; %Filter bank config

%% get filters
PVname = [filterbank,'_SWSTAT'];
[data,~] = OnlineData.fetch(GPStime,duration,PVname);
bit = dec2bin(data(1));
n = length(bit);

for target=1:10
    if bit(n-target+1) == '1'
        val(target)=1;
    end
end

% % get filter 1-6
% PVname = [filterbank,'_SW1R'];
% [~,cmdout] = system(['caget -t -lb ',PVname]);
% bit = fliplr(cmdout);
% n = length(bit)-1;
% 
% for target=1:(n-4)/2
%     if (bit(target*2+4)=='1') && (bit(target*2+5)=='1')
%         val(target)=1;
%     end
% end
% 
% % get filter 7-10
% PVname2 = [filterbank,'_SW2R'];
% [~,cmdout] = system(['caget -t -lb ',PVname2]);
% bit = fliplr(cmdout);
% n = length(bit)-1;
% 
% if n > 0
%     for target=1:n/2
%         if (bit(target*2)=='1') && (bit(target*2+1)=='1')
%             val(target+6)=1;
%         end
%     end
% end

    
end