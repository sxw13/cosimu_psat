function createhourloadshape(Config)
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
switch Config.simuType
    case 0
        tStep = Config.lfTStep;
    case 1
        tStep = Config.dynTStep;
    case 2
        tStep = Config.PFTStep;
end
nHour = 24;%Config.simuEndTime/3600;
allData = interp1(linspace(0,Config.simuEndTime,length(allDay)),allDay,0:tStep:Config.simuEndTime-tStep,'spline');
nData = length(allData);

if isfield(Config,'LoadShapeRatio')
    allData = allData/max(abs(allData));
end

for iHour = 1 : nHour
    hourDataNew = allData(1+(iHour-1)*nData/nHour:iHour*nData/nHour);
    save(['loadshapeHour',num2str(iHour)], 'hourDataNew');
end