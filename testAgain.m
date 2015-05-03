load('C:\Users\sxw13\Documents\cosimu_psat\debug\IEEE39BusAttackNew(dynamicPowerLimitation)\LoadShapeRatio_2_seEnable_1_toBus_38_errorRatio_2_.mat');
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
Config.falseDataAttacks{1,1}.fixedAction = ResultData.MDPData{1,1}.ActionHistory;

simplePSAT(Config);
