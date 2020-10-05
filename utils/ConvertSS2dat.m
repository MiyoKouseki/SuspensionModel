function ConvertSS2dat(opt,type,sysc0,tardir)
% export SS for python

txtfileA = strcat(opt,'A.dat');
txtfileB = strcat(opt,'B.dat');
txtfileC = strcat(opt,'C.dat');
txtfileD = strcat(opt,'D.dat');
dlmwrite(fullfile(tardir,txtfileA),sysc0.A);
dlmwrite(fullfile(tardir,txtfileB),sysc0.B);
dlmwrite(fullfile(tardir,txtfileC),sysc0.C);
dlmwrite(fullfile(tardir,txtfileD),sysc0.D);

%% Input and Output

outfile = strcat('Type',type,'Output.dat');
fileID = fopen(fullfile(tardir,outfile),'w');
for i = 1:length(sysc0.OutputName)
    fprintf(fileID,'%s\n',cell2mat(sysc0.OutputName(i)));
end
fclose(fileID);

infile = strcat('Type',type,'Input.dat');
fileID = fopen(fullfile(tardir,infile),'w');
for i = 1:length(sysc0.InputName)
    fprintf(fileID,'%s\n',cell2mat(sysc0.InputName(i)));
end
fclose(fileID);

end
