function tf = ltspiceFrd(fileName)
%ltspiceFRD  Imports TF data from a ltspice .txt file. 
%The format should be freq real,imag

fileID = fopen(fileName, 'r');
data = textscan(fileID, '%f%f,%f', 'Delimiter', ' ', 'HeaderLines', 1,...
    'MultipleDelimsAsOne', 1, 'CommentStyle', '#');

fclose(fileID);

data = cell2mat(data);

tf = frd(data(:,2)+1i*data(:,3), data(:,1), 'Units', 'Hz');

end