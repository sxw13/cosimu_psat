initialPath;
load('TestSE/IEEE39.mat');
toBus = 1;

% idx_head = find(CurrentStatus.branch(:,1)==toBus);
% len = length(idx_head);
% CurrentStatus.plineHeadMeas(idx_head) = CurrentStatus.plineHeadMeas(idx_head)*2.*rand(len,1);
% CurrentStatus.qlineHeadMeas(idx_head) = CurrentStatus.qlineHeadMeas(idx_head)*4.*(rand(len,1)-0.5);
% 
% idx_tail = find(CurrentStatus.branch(:,2)==toBus);
% len = length(idx_tail);
% CurrentStatus.plineTailMeas(idx_tail) = CurrentStatus.plineTailMeas(idx_tail)*2.*rand(len,1);
% CurrentStatus.qlineTailMeas(idx_tail) = CurrentStatus.qlineTailMeas(idx_tail)*4.*(rand(len,1)-0.5);
% 
% idx_gen = find(CurrentStatus.gen(:,1)==toBus);
% len = length(idx_gen);
% CurrentStatus.genPMeas(idx_gen) = CurrentStatus.genPMeas(idx_gen)*2.*rand(len,1);
% CurrentStatus.genQMeas(idx_gen) = CurrentStatus.genQMeas(idx_gen)*4.*(rand(len,1)-0.5);

idx_tail=1:2;
CurrentStatus.plineTailMeas(idx_tail) = CurrentStatus.plineTailMeas(idx_tail).*[2;0];
CurrentStatus.qlineTailMeas(idx_tail) = CurrentStatus.qlineTailMeas(idx_tail).*[0;-2];

Config.seEnable = 1;
Config.maxSEIter = 10;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 0.5; % the threshold for false data detection
[baseMVA, bus, gen, branch, success, fdSet] = stateEstimate(ResultData, CurrentStatus, Config);