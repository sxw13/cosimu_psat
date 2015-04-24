function fd = defaultFalseData(Config,FalseData,opt)
measureNamePattern = {'busVMeasPu','ploadMeas','genPMeas','genQMeas','plineTailMeas','qlineTailMeas','plineHeadMeas','qlineHeadMeas'};
FalseData.MDPStateName = cell(0);
cellid=0;
for i = 1 : length(measureNamePattern )
    addIdxOn = findMeas4Bus(Config, measureNamePattern{i}, FalseData.toBus);
    for ii = 1:length(addIdxOn)
        cellid = cellid+1;
        FalseData.MDPStateName{cellid} = [measureNamePattern{i}, '(', int2str(addIdxOn(ii)), ')'];
    end
end
injectionNameParttern = {'genPMeas','genQMeas','plineTailMeas','qlineTailMeas','plineHeadMeas','qlineHeadMeas'};
FalseData.InjectionName = cell(0);
cellid=0;
for i = 1 : length(injectionNameParttern )
    addIdxOn = findMeas4Bus(Config, injectionNameParttern{i}, FalseData.toBus);
    for ii = 1:length(addIdxOn)
        cellid = cellid+1;
        FalseData.InjectionName{cellid} = [injectionNameParttern{i}, '(', int2str(addIdxOn(ii)), ')'];
    end
end

if ~isfield(FalseData,'LearningEndTime')
    FalseData.LearningEndTime = Config.simuEndTime;
end

if nargin<3
    opt = struct('length',4,'N',3);
elseif ~isfield(opt,'length')
    opt.length = 4;
elseif ~isfield(opt,'N')
    opt.N = 3;    
end




stateNum = length(FalseData.MDPStateName);
actionNum = length(FalseData.InjectionName);
FalseData.MDPBusVStateStep = 0.01;
FalseData.MDPStateLimits = zeros(stateNum,2);
FalseData.Nstate = zeros(1,stateNum);
for idx = 1:stateNum
    if ~isempty(strfind(FalseData.MDPStateName{idx},'busVMeasPu'))
        FalseData.MDPStateLimits(idx,:)=[0.8 1.2];
        FalseData.Nstate(idx)=23;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'ploadMeas'))
        FalseData.MDPStateLimits(idx,:)=[0.7 1.3];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'genPMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'genQMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'plineTailMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'qlineTailMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'plineHeadMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    elseif ~isempty(strfind(FalseData.MDPStateName{idx},'qlineHeadMeas'))
        FalseData.MDPStateLimits(idx,:)=[0 0.6];
        FalseData.Nstate(idx)=5;
    end
end
%     FalseData.MDPStateLimits = [0.8 1.2;0.7 1.3;0 0.6;0 0.6;0 0.6;0 0.6];
%     FalseData.Nstate = [23 5 5 5 5 5];  % total number of state

FalseData.Naction = zeros(1,actionNum);
FalseData.MDPBusFalseDataRatioStep = zeros(1,actionNum);
FalseData.RatioOffset = zeros(1,actionNum);
for idx = 1:actionNum
    if ~isempty(strfind(FalseData.InjectionName{idx},'busVMeasPu'))
        FalseData.Naction(idx) = 3;
        FalseData.MDPBusFalseDataRatioStep(idx) = 0.1;
        FalseData.RatioOffset(idx) = 1;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'ploadMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = opt.length/2;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'genPMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = opt.length/2;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'genQMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = 0;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'plineTailMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = opt.length/2;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'qlineTailMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = 0;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'plineHeadMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = opt.length/2;
    elseif ~isempty(strfind(FalseData.InjectionName{idx},'qlineHeadMeas'))
        FalseData.Naction(idx) = opt.N;
        FalseData.MDPBusFalseDataRatioStep(idx) = opt.length/(opt.N-1);
        FalseData.RatioOffset(idx) = 0;
    end
end
%     FalseData.Naction = [3 3 3 3];   % total number of action
%     FalseData.MDPBusFalseDataRatioStep = [1 1 1 1];  % Step for false data ratio
%     FalseData.RatioOffset = [2 0 2 0];

FalseData.PenalForNotConvergence = 1;  % 1 for penal ; 0 for not penal
%     FalseData.InjectionName = {'plineHeadMeas(8)','qlineHeadMeas(8)','plineTailMeas(6)','qlineTailMeas(6)'};
if ~isfield(FalseData,'MDPDiscountFactor')
    FalseData.MDPDiscountFactor = 0.2;   % discount factor for value function of MDP
end
if ~isfield(FalseData, 'reward')
    FalseData.reward = 'voltage';  % 'voltage' or 'pLoss' or 'minEigValue'
end
if ~isfield(FalseData,'Qlearning')
    FalseData.Qlearning = 1; % 1 for learning; 0 for not learning
end
if ~isfield(FalseData, 'learningRate')
    FalseData.learningRate = '2/(sqrt(Iter+1)+1)';
end
FalseData.fixedAction = [];  %-1 for a
if ~isfield(FalseData,'maxLearnedAction')
    FalseData.maxLearnedAction = 300;
end
if ~isfield(FalseData,'minAttackValue')
    FalseData.minAttackValue = 2.2;
end
if ~isfield(FalseData,'autoOffset')
    FalseData.autoOffset = 1;
end


FalseData.calWARD = 0;
fd = FalseData;
end