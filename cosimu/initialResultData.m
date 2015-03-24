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
ResultData.allBusAHis = [];
ResultData.pLossHis = [];

ResultData.pLForCtrlHis = [];
ResultData.qLForCtrlHis = [];
ResultData.pLForOPF = [];
ResultData.qLForOPF = [];
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

% for false data detection 
ResultData.falseDataDctSet = struct('ploadMeas',sparse(0,0),...
                         'qloadMeas',sparse(0,0),...
                         'genPMeas',sparse(0,0),...
                         'genQMeas',sparse(0,0),...
                         'busVMeasPu',sparse(0,0),...
                         'plineHeadMeas',sparse(0,0),...
                         'qlineHeadMeas',sparse(0,0),...
                         'plineTailMeas',sparse(0,0),...
                         'qlineTailMeas',sparse(0,0));
                     
ResultData.falseDataInjSet = struct('ploadMeas',[],...
                                     'qloadMeas',[],...
                                     'genPMeas',[],...
                                     'genQMeas',[],...
                                     'busVMeasPu',[],...
                                     'plineHeadMeas',[],...
                                     'qlineHeadMeas',[],...
                                     'plineTailMeas',[],...
                                     'qlineTailMeas',[]);

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

if ~isempty(Config.MDPData)
    ResultData.MDPData = Config.MDPData;
    for id = 1:length(Config.falseDataAttacks)
        MDPData_k.ActionHistory = [];
        MDPData_k.StatesHistory = [];
        MDPData_k.rHistory = [];
        MDPData_k.VHistory = [];
        if Config.falseDataAttacks{id}.calWARD
            MDPData_k.SBHistory = [];
        end
    end
elseif ~isempty(Config.falseDataAttacks) && Config.falseDataAttacks{1}.strategy==6
    ResultData.MDPData = cell(length(Config.falseDataAttacks),1);
    for id = 1:length(Config.falseDataAttacks)
        fa = Config.falseDataAttacks{id};
        
        for injCell = fa.InjectionName
            injc = injCell{1};
            id1 = strfind(injc,'(');
            id2 = strfind(injc,')');
            injcName = injc(1:id1-1);
            injcID = str2num(injc(id1+1:id2-1));
            ResultData.falseDataInjSet.(injcName) = [ResultData.falseDataInjSet.(injcName) injcID];
        end
            
        MDPData_k.r = 0;
        MDPData_k.Q = sparse(prod(fa.Nstate),prod(fa.Naction));
        switch fa.reward
        case 'voltage'
            MDPData_k.Q = sparse(prod(fa.Nstate),prod(fa.Naction));
        case 'pLoss'
            MDPData_k.Q = sparse(prod(fa.Nstate),prod(fa.Naction));
        case 'minEigValue'
            MDPData_k.Q = - 5 * ones(prod(fa.Nstate),prod(fa.Naction));
        end
%         MDPData_k.s = MDPData_k.s_new;
        MDPData_k.a = 1;
        MDPData_k.Iters = sparse(prod(fa.Nstate),prod(fa.Naction));
        MDPData_k.ActionHistory = [];
        MDPData_k.StatesHistory = [];
        MDPData_k.rHistory = [];
        MDPData_k.VHistory = [];
        
        
        % WARD caculation
        if fa.calWARD
            MDPData_k.SBHistory = [];
            Y = Line.Y;
            fr = Line.fr;
            to = Line.to;
            MDPData_k.BusI = fa.internalBus;
            MDPData_k.BusB = [];
            MDPData_k.BusE = [];
            BMap = containers.Map('KeyType','int32','ValueType','int32');
            allBus = Bus.int;
            for busi = MDPData_k.BusI
                for lineid = 1:length(fr)
                    if busi==fr(lineid)
                        BMap(to(lineid))=0;
                    elseif busi==to(lineid)
                        BMap(fr(lineid))=0;
                    end
                end
            end
            for bus = allBus'
                if isempty(find(MDPData_k.BusI==bus, 1))
                    if isKey(BMap,bus)
                        MDPData_k.BusB = [MDPData_k.BusB;bus];
                    else
                        MDPData_k.BusE = [MDPData_k.BusE;bus];
                    end
                end
            end
            YEE = Y(MDPData_k.BusE,MDPData_k.BusE);
            YEB = Y(MDPData_k.BusE,MDPData_k.BusB);
            YBE = Y(MDPData_k.BusB,MDPData_k.BusE);
            YBB = Y(MDPData_k.BusB,MDPData_k.BusB);
            MDPData_k.YBI = Y(MDPData_k.BusB,MDPData_k.BusI);
            MDPData_k.YIB = Y(MDPData_k.BusI,MDPData_k.BusB);
            MDPData_k.YII = Y(MDPData_k.BusI,MDPData_k.BusI);
            MDPData_k.YBBp = YBB - YBE*(YEE\YEB);
        end
        ResultData.MDPData{id} = MDPData_k;
    end
    
end

ResultData.messages = cell(0);

