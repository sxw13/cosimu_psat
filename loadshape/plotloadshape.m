function plotloadshape(Config)
%% Initialize variables.
filename = Config.loadShapeCsvFile;
delimiter = '';

%% Format string for each line of text:
%   column1: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
allDay = dataArray{:, 1};

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

nPoint = 0;
tStep = 0;
if Config.simuType == 0
    tStep = Config.lfTStep;
else
    tStep = Config.dynTStep;
end
nHour = Config.simuEndTime/3600;
allData = interp1(linspace(0,Config.simuEndTime,length(allDay)),allDay,0:tStep:Config.simuEndTime-tStep,'spline');
nData = length(allData);

if isfield(Config,'LoadShapeRatio')
    allData = allData/max(abs(allData))*Config.LoadShapeRatio;
end

close all;
plot(0:tStep:Config.simuEndTime-tStep,allData);
grid on;
xlabel('time/s');ylabel('loadRatio');