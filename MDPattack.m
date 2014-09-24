%state=1:初始化，state=0:不初始化
function [ResultData,Config]=MDPattack(Config,label,MDPData,folder)
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);
pwdpath = pwd;

if nargin<4
    folder = '.';
end

if nargin<3
    Config.MDPData = [];
else
    Config.MDPData = MDPData;
end

if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

cd(pwdpath);

caseName = [Config.opfCaseName '_MDPattack_genPMeas_', num2str(Config.simuEndTime)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

ResultData = simplePSAT(Config);

cd(pwdpath);

resultFile = [pwdpath, '/debug/',folder,'/',caseName,'_',label,'_', startTime];
save(resultFile, 'Config', 'ResultData');

end