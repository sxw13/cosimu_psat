initialPath;
load('TestSE/IEEE39.mat');
[baseMVA, bus, gen, branch, success] = stateEstimate(ResultData, CurrentStatus)

dPl = bus(ResultData.allLoadIdx,3) - CurrentStatus.bus(ResultData.allLoadIdx,3);
dPg = bus(ResultData.allGenIdx,3) - CurrentStatus.bus(ResultData.allGenIdx,3);