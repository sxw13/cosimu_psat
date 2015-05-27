load('C:\Users\sxw13\Documents\cosimu_psat\ResultIEEE9');
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
Config.falseDataAttacks{1}.fixedAction = [];
Config.falseDataAttacks{1}.PenalForNotConvergence = 1;
Config.falseDataAttacks{1}.LearningEndTime = Config.simuEndTime;
% Config.falseDataAttacks{1,1}.Nstate = 1;
% Config.falseDataAttacks{1,1}.MDPStateLimits = [0.8 1.2];
% Config.falseDataAttacks{1,1}.MDPStateName = {'ploadMeas(1)'};

% Config.falseDataAttacks{1}.minAttackValue = 0;
% Config.simuEndTime = 3600*3;
% Config.falseDataAttacks{1}.Naction = [3 3];
% Config.falseDataAttacks{1}.MDPBusFalseDataRatioStep = [2 2];
% Config.falseDataAttacks{1,1}.MDPStateName = Config.falseDataAttacks{1,1}.MDPStateName(1);
% Config.falseDataAttacks{1,1}.MDPStateLimits = Config.falseDataAttacks{1,1}.MDPStateLimits(1,:);
% Config.falseDataAttacks{1,1}.Nstate = 23;
% Config.falseDataAttacks{1,1}.reward = 'discrate';

Re = simplePSAT(Config);
