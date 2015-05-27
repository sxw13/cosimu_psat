load('debug\IEEE39BusAttack(withSeLimit)\LoadShapeRatio_2.6_toBus_38_errorRatio_2_.mat');
pwdpath = pwd;
initialPath;
if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
% Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

cd(pwdpath);
Config.SimuEndTime = 3600;

Config.autoOPFLimit = 0;
Config.autoSELimit = 0;
ResultData = simplePSAT(Config);
