initialPath;
load('TestSE/IEEE39.mat');
CurrentStatus.plineHeadMeas(44) = CurrentStatus.plineHeadMeas(44)*2;
CurrentStatus.qlineHeadMeas(44) = CurrentStatus.qlineHeadMeas(44)*2;
CurrentStatus.genPMeas(2) = CurrentStatus.genPMeas(2)*2;
CurrentStatus.genQMeas(2) = CurrentStatus.genQMeas(2)*2;

Config.seEnable = 1;
Config.maxSEIter = 10;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 0.5; % the threshold for false data detection
[baseMVA, bus, gen, branch, success, fdSet] = stateEstimate(ResultData, CurrentStatus, Config);