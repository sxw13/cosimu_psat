%1. to run opendss in matlab;
%2. to simulate the voltage control with only local control strategies
clear ;
% clear classes;

addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);
pwdpath = pwd;

Config = initialConfig;

switch Config.simuType
    case 0
        cd([pwd, '\loadshape\lf']);    
    case 1
        cd([pwd, '\loadshape\dyn']);
    case 2
        cd([pwd, '\loadshape\PowerFactory']);
end
Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

cd(pwdpath);

caseName = ['psat_simu_', num2str(Config.simuEndTime)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

ResultData = simplePSAT(Config);

cd(pwdpath);

resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
save(resultFile, 'Config', 'ResultData');

