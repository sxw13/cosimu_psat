initialPath;
load('TestSE/IEEE39.mat');
CurrentStatus.plineHeadMeas(45) = CurrentStatus.plineHeadMeas(45)*2;
CurrentStatus.qlineHeadMeas(45) = CurrentStatus.qlineHeadMeas(45)*2;
[baseMVA, bus, gen, branch, success] = stateEstimate(ResultData, CurrentStatus)

dPl = bus(ResultData.allLoadIdx,3) - ResultData.allPLoadHis*100;
dPg = gen([2 1 3:end],2) - ResultData.allPGenHis*100;