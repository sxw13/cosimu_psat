function ResultData = initialResultData(Config, CurrentStatus)

global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind Syn
global Varout Breaker Line Path clpsat

ResultData.allPLoadHis = [];
ResultData.allQLoadHis = [];
ResultData.allLineHeadPHis = [];
ResultData.allLineHeadQHis = [];
ResultData.allLineTailPHis = [];
ResultData.allLineTailQHis = [];

% record all p q of gens
ResultData.allPGenHis = [];
ResultData.allQGenHis = [];

% p loss & all bus V
ResultData.allBusVHis = [];
ResultData.pLossHis = [];

ResultData.pLForCtrlHis = [];
ResultData.qLForCtrlHis = [];
ResultData.pGenCtrlHis = [];
ResultData.qGenCtrlHis = [];
ResultData.vGenCtrlHis = [];
ResultData.tCtrlHis = [];
ResultData.t = [];
ResultData.ctrlQueue = [];
ResultData.nSample = 0;
ResultData.nOpf = 0;

ResultData.minEigValueHis = [];

ResultData.isOpfConverged = [];

ResultData.allLoadIdx = [];
busIdx = PQ.bus;
for iBus = 1 : PQ.n
    idx = find(CurrentStatus.bus(:,1) == busIdx(iBus));
    ResultData.allLoadIdx = [ResultData.allLoadIdx; idx];
end

ResultData.loadBase = CurrentStatus.loadBase(ResultData.allLoadIdx, :)/100;

ResultData.allBusIdx = Bus.int;

ResultData.allGenIdx = [];
synIdx = [];
if Config.simuType == 0
    synIdx = [SW.bus; PV.bus];
else
    synIdx = Syn.bus;
end
for iGen = 1 : length(synIdx)
    idx = find(CurrentStatus.gen(:,1) == synIdx(iGen));
    ResultData.allGenIdx = [ResultData.allGenIdx; idx];
end


ResultData.allLineIdx = [];
ResultData.allLineHeadBusIdx = [];
ResultData.allLineTailBusIdx = [];

for iLine = 1 : Line.n            
    fromBus = Line.con(iLine, 1);
    endBus = Line.con(iLine, 2);
    idx = find(CurrentStatus.branch(:,1)==fromBus & CurrentStatus.branch(:,2) == endBus);
    if isempty(idx)
        idx = find(CurrentStatus.branch(:,1)==endBus & CurrentStatus.branch(:,2) == fromBus);
    end
    ResultData.allLineIdx = [ResultData.allLineIdx; idx];
    ResultData.allLineHeadBusIdx = [ResultData.allLineHeadBusIdx; find(CurrentStatus.bus(:,1)==fromBus)];
    ResultData.allLineTailBusIdx = [ResultData.allLineTailBusIdx; find(CurrentStatus.bus(:,1)==endBus)];
end

if ~isempty(Config.falseDataAttacks) && Config.falseDataAttacks{1}.strategy==6
    ResultData.MDPData = cell(length(Config.falseDataAttacks),1);
    for id = 1:length(Config.falseDataAttacks)
        fa = Config.falseDataAttacks{id};
        
        MDPData_k.r = 0;
        MDPData_k.Q = - 5 * ones(fa.Nstate,prod(fa.Naction));
        switch fa.reward
        case 'voltage'
            MDPData_k.Q = zeros(fa.Nstate,prod(fa.Naction));
        case 'pLoss'
            MDPData_k.Q = zeros(fa.Nstate,prod(fa.Naction));
        case 'minEigValue'
            MDPData_k.Q = - 5 * ones(fa.Nstate,prod(fa.Naction));
        end
%         MDPData_k.s = MDPData_k.s_new;
        MDPData_k.a = 1;
        MDPData_k.Iters = zeros(prod(fa.Nstate),prod(fa.Naction));
        MDPData_k.ActionHistory = [];
        MDPData_k.StatesHistory = [];
        MDPData_k.rHistory = [];
        MDPData_k.VHistory = [];
        ResultData.MDPData{id} = MDPData_k;
    end
end



