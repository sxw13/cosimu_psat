load('C:\Users\sxw13\Documents\cosimu_psat\debug\IEEE9BusAttack(dynamicPowerLimitation)\LoadShapeRatio_1.2_toBus_5_errorRatio_2_falseDataSchema_2_.mat');
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
% inj = [];
% dct = [];
% fd = fieldnames(ResultData.falseDataDctSet);
% for fid = 1:length(fd)
%     inj = [inj;ResultData.falseDataInjSet.(fd{fid})];
%     dct = [dct;ResultData.falseDataDctSet.(fd{fid})];
% end
% steals = full(sum(inj & (~dct))).*ResultData.isOpfConverged;
% (find(steals>0)-1)*Config.controlPeriod

% Config.seEnable = 1;
% Config.maxSEIter = 40;  % the maximum number of se iteration to repair false data
% Config.fDthreshold = 0.01; % the threshold for false data detection
% Config.falseDataAttacks{1}.fixedAction = ResultData.MDPData{1}.ActionHistory;
% Config.falseDataAttacks{1,1}.Nstate = 1;
% Config.falseDataAttacks{1,1}.MDPStateLimits = [0.8 1.2];
% Config.falseDataAttacks{1,1}.MDPStateName = {'ploadMeas(1)'};
Config.falseDataAttacks{1}.minAttackValue = 1;
Config.simuEndTime = 3600*3;
Config.falseDataAttacks{1}.Naction = [3 3];
Config.falseDataAttacks{1}.MDPBusFalseDataRatioStep = [2 2];

Re = simplePSAT(Config);
