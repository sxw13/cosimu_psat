function [CurrentStatus, ResultData, Config] = sampleAllMeasurements(Config, ResultData, CurrentStatus)
%     global MDPData  % TAction
    global DAE Bus

    % perfect measurements without latency
    CurrentStatus.ploadMeas = ResultData.allPLoadHis(:, end);
    CurrentStatus.qloadMeas = ResultData.allQLoadHis(:, end);    
    CurrentStatus.genPMeas = ResultData.allPGenHis(:, end);
    CurrentStatus.genQMeas = ResultData.allQGenHis(:, end);
    CurrentStatus.busVMeasPu = ResultData.allBusVHis(:, end);
    CurrentStatus.plineHeadMeas = ResultData.allLineHeadPHis(:, end);
    CurrentStatus.qlineHeadMeas = ResultData.allLineHeadQHis(:, end);
    CurrentStatus.plineTailMeas = ResultData.allLineTailPHis(:, end);
    CurrentStatus.qlineTailMeas = ResultData.allLineTailQHis(:, end);
    
    try
        CurrentStatus.isOpfConverged = ResultData.isOpfConverged(:,end);
    catch e
        CurrentStatus.isOpfConverged = 1;
    end
    CurrentStatus2 = CurrentStatus;
%     
if Config.measLagSchema == 2
    
    % all tunnel use same latency setting
    iSnapshot = length(ResultData.t) - Config.measAllLatency;
    if iSnapshot < 1
        iSnapshot = 1;
    end
    CurrentStatus.ploadMeas = ResultData.allPLoadHis(:, iSnapshot);
    CurrentStatus.qloadMeas = ResultData.allQLoadHis(:, iSnapshot);
    CurrentStatus.genPMeas = ResultData.allPGenHis(:, iSnapshot);
    CurrentStatus.genQMeas = ResultData.allQGenHis(:, iSnapshot);
    CurrentStatus.busVMeasPu = ResultData.allBusVHis(:, iSnapshot);
    CurrentStatus.plineHeadMeas = ResultData.allLineHeadPHis(:, iSnapshot);
    CurrentStatus.qlineHeadMeas = ResultData.allLineHeadQHis(:, iSnapshot);
    CurrentStatus.plineTailMeas = ResultData.allLineTailPHis(:, iSnapshot);
    CurrentStatus.qlineTailMeas = ResultData.allLineTailQHis(:, iSnapshot);
end    
% elseif Config.measLagSchema == 3
%     
%     % all tunnel use same latency setting
%     for iBus = 1 : length(ResultData.allBusIdx)
%         iTun = ResultData.allBusIdx(iBus);
%         iSnapshot = round(length(ResultData.t) - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%         CurrentStatus.busVMeasPu(iBus) = ResultData.allBusVHis(iBus, iSnapshot);          
%     end
%     
%     nSample = length(ResultData.t);
%     for iTransf = 1 : ResultData.nTransf
%         iTun = ResultData.allTransfHeadBusIdx(iTransf);
%         iSnapshot = round(nSample - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%         CurrentStatus.transfTMeas(iTransf) = ResultData.allTransfTHis(iTransf, iSnapshot);
%         CurrentStatus.ptransfHeadMeas = ResultData.allTransfHeadPHis(iTransf, iSnapshot);
%         CurrentStatus.qtransfHeadMeas = ResultData.allTransfHeadQHis(iTransf, iSnapshot);
%         CurrentStatus.ptransfTailMeas = ResultData.allTransfTailPHis(iTransf, iSnapshot);
%         CurrentStatus.qtransfTailMeas = ResultData.allTransfTailQHis(iTransf, iSnapshot);       
%     end
%     
%     for iLine = 1 : ResultData.nLines
%         iTun = ResultData.allLineHeadBusIdx(iLine);
%         iSnapshot = round(nSample - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%         CurrentStatus.plineHeadMeas(iLine) = ResultData.allLineHeadPHis(iLine, iSnapshot);
%         CurrentStatus.qlineHeadMeas(iLine) = ResultData.allLineHeadQHis(iLine, iSnapshot);
%         
%         iTun = ResultData.allLineTailBusIdx(iLine);
%         iSnapshot = round(nSample - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%         CurrentStatus.plineTailMeas(iLine) = ResultData.allLineTailPHis(iLine, iSnapshot);
%         CurrentStatus.qlineTailMeas(iLine) = ResultData.allLineTailQHis(iLine, iSnapshot);
%     end
%     
%     for iGen = 1 : ResultData.nGens
%         iTun = ResultData.allGenIdx(iGen);
%         iSnapshot = round(nSample - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%         CurrentStatus.genPMeasKw(iGen) = ResultData.allPGenHis(iGen, iSnapshot);
%         CurrentStatus.genQMeasKva(iGen) = ResultData.allQGenHis(iGen, iSnapshot);
%     end
%     
%     for iLoad = 1 : ResultData.nLoad
%         iTun = ResultData.allLoadIdx(iLoad);
%         iSnapshot = round(nSample - Config.measTunnelLatency(iTun));
%         if iSnapshot < 1
%             iSnapshot = 1;
%         end
%        CurrentStatus.ploadMeas(iLoad) = ResultData.allPLoadHis(iLoad, iSnapshot);
%        CurrentStatus.qloadMeas(iLoad) = ResultData.allQLoadHis(iLoad, iSnapshot);
%     end
% 
% end
% 
% 
if Config.falseDataSchema == 1
    % false data schema 1    
    CurrentStatus.ploadMeas = CurrentStatus.ploadMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.ploadMeas));
    CurrentStatus.qloadMeas = CurrentStatus.qloadMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.qloadMeas));    
    CurrentStatus.genPMeas =  CurrentStatus.genPMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.genPMeas));
    CurrentStatus.genQMeas = CurrentStatus.genQMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.genQMeas));

    CurrentStatus.plineHeadMeas = CurrentStatus.plineHeadMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.plineHeadMeas));
    CurrentStatus.qlineHeadMeas = CurrentStatus.qlineHeadMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.qlineHeadMeas));
    CurrentStatus.plineTailMeas = CurrentStatus.plineTailMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.plineTailMeas));
    CurrentStatus.qlineTailMeas = CurrentStatus.qlineTailMeas - Config.measErroRatio + Config.measErroRatio * rand(size(CurrentStatus.qlineTailMeas));
    
elseif Config.falseDataSchema == 2
    % this is a special bad data injection attack 
    nAttacks = length(Config.falseDataAttacks);
    
    if Config.seEnable
        for injCell = fieldnames(ResultData.falseDataInjSet)'
            injc = injCell{1};
            dataLen = size(CurrentStatus.(injc),1);
            ResultData.falseDataInjSet.(injc) = [ResultData.falseDataInjSet.(injc) sparse(dataLen,1)];
        end
    end
    for iAttack = 1 : nAttacks
        fa = Config.falseDataAttacks{iAttack};
        nBus = length(fa.toBus);
        for iBus = 1 : nBus
            % find the bus be attacked ; here only attack on substation is
            % modelled. therefore, only buses are used as targets
            busIdx = fa.toBus(iBus);
            switch fa.strategy
                case 1 
                    % for random erro injected into all measurements on this bus, such as v, theta, pl, ql, pg, qg
                    % for v of this bus, using v = v*(1-erroRatio)+random(v*erroRatio)
                    v = CurrentStatus.busVMeasPu(busIdx);
                    CurrentStatus.busVMeasPu(busIdx) = v *(1 - fa.erroRatio/2) + v * fa.erroRatio * rand(1);
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl * (1 - fa.erroRatio/2) + pl * fa.erroRatio * rand(1);
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql * (1 - fa.erroRatio/2) + ql * fa.erroRatio * rand(1);
                    end
                    % for qg and pg on this bus, bus the same random signal
                    % ratio method as v
                    idxGen = find(ResultData.allGenIdx==busIdx);
                    if ~isempty(idxGen)
                        pg = CurrentStatus.genPMeasKw(idxGen) ;
                        CurrentStatus.genPMeasKw(idxGen) = pg * (1 - fa.erroRatio/2) + pg * fa.erroRatio * rand(1);
                        qg = CurrentStatus.genQMeasKva(idxGen) ;
                        CurrentStatus.genQMeasKva(idxGen) = qg * (1 - fa.erroRatio/2) + qg * fa.erroRatio * rand(1);
                    end
                    
                case 1.1 
                    % for random erro augment injected into all measurements on this bus, only on pl, ql
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl *(1 + fa.erroRatio * rand(1));
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql + ql * fa.erroRatio * rand(1);
                    end
                    
                case 1.2 % for random erro decrease injected into all measurements on this bus, only on pl, ql
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl *(1 - fa.erroRatio * rand(1));
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql *(1 - fa.erroRatio * rand(1));
                    end
                    
                case 2 
                    % for augment random erro data injected into all measurements on this bus                   
                    % for v of this bus, using v = v*(1-erroRatio)+random(v*erroRatio)
                    v = CurrentStatus.busVMeasPu(busIdx);
                    CurrentStatus.busVMeasPu(busIdx) = v *(1 - fa.erroRatio/2) + v * fa.erroRatio * rand(1);
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl * (1 - fa.erroRatio/2) + pl * fa.erroRatio * rand(1);
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql * (1 - fa.erroRatio/2) + ql * fa.erroRatio * rand(1);
                    end
                    % for qg and pg on this bus, bus the same random signal
                    % ratio method as v
                    idxGen = find(ResultData.allGenIdx==busIdx);
                    if ~isempty(idxGen)
                        pg = CurrentStatus.genPMeasKw(idxGen) ;
                        CurrentStatus.genPMeasKw(idxGen) = pg * (1 - fa.erroRatio/2) + pg * fa.erroRatio * rand(1);
                        qg = CurrentStatus.genQMeasKva(idxGen) ;
                        CurrentStatus.genQMeasKva(idxGen) = qg * (1 - fa.erroRatio/2) + qg * fa.erroRatio * rand(1);
                    end
                    % change the augDir and erroRatio periodicaly                     
                    if fa.erroRatio >= fa.maxErroRatio
                        fa.augDir = -1;
                    elseif fa.erroRatio <= 0
                        fa.augDir = 1;
                    end
                    fa.erroRatio = fa.erroRatio + fa.augDir*fa.erroRatioStep;
                    Config.falseDataAttacks{iAttack} = fa;
                    
                case 3 % for the conversary voltage control bad data injection on all the measurement on the bus based on currrent v
                     v = CurrentStatus.busVMeasPu(busIdx);
                     vRandDir = 1;
                     loadRandDir = 1;
                     if v > fa.highV
                         vRandDir = -1;
                         loadRandDir = 1;
                     elseif v < fa.lowV
                         vRandDir = 1;
                         loadRandDir = -1;
                     else
                         seed = rand(1);
                         if seed > 0.5
                              vRandDir = 1;                              
                         else
                              vRandDir = -1;
                         end
                         seed = rand(1);
                         if seed > 0.5
                             loadRandDir = 1;                              
                         else
                             loadRandDir = -1;
                         end
                     end
                    CurrentStatus.busVMeasPu(busIdx) = v *(1 + vRandDir * fa.erroRatio);
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl * (1 + loadRandDir* fa.erroRatio);
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql * (1 + loadRandDir * fa.erroRatio);
                    end
                    % for qg and pg on this bus, bus the same random signal
                    % ratio method as v
                    idxGen = find(ResultData.allGenIdx==busIdx);
                    if ~isempty(idxGen)
                        pg = CurrentStatus.genPMeasKw(idxGen) ;
                        CurrentStatus.genPMeasKw(idxGen) = pg * (1 + loadRandDir*fa.erroRatio);
                        qg = CurrentStatus.genQMeasKva(idxGen) ;
                        CurrentStatus.genQMeasKva(idxGen) = qg * (1 + loadRandDir*fa.erroRatio);
                    end
                    
                case 4 % fix rate change of load
                    vRandDir = 1;
                    loadRandDir = -1;
                    v = CurrentStatus.busVMeasPu(busIdx);
                    CurrentStatus.busVMeasPu(busIdx) = v *(1 + vRandDir * fa.erroRatio);
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl * (1 + loadRandDir* fa.erroRatio);
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql * (1 + loadRandDir * fa.erroRatio);
                    end
                    
                    idxLine = find(ResultData.allLineHeadBusIdx == busIdx);
                    if ~isempty(idxLine)
                        ph = CurrentStatus.plineHeadMeas(idxLine) ;
                        CurrentStatus.plineHeadMeas(idxLine) = ph * (1 + loadRandDir* fa.erroRatio);
                        qh = CurrentStatus.qlineHeadMeas(idxLine) ;
                        CurrentStatus.qlineHeadMeas(idxLine) = qh * (1 + loadRandDir * fa.erroRatio);
                    end
                    
                    idxLine = find(ResultData.allLineTailBusIdx == busIdx);
                    if ~isempty(idxLine)
                        pt = CurrentStatus.plineTailMeas(idxLine) ;
                        CurrentStatus.plineTailMeas(idxLine) = pt * (1 + loadRandDir* fa.erroRatio);
                        qt = CurrentStatus.qlineTailMeas(idxLine) ;
                        CurrentStatus.qlineTailMeas(idxLine) = qt * (1 + loadRandDir * fa.erroRatio);
                    end
                    
                    
                case 5 % voltage change rate (trend) is used to generate bad data (converse trend)
                    vHis = ResultData.allBusVHis(busIdx, [end-2:end]);
                    p = polyfit([1:3], vHis, 1);
                    vTrend = p(1);
                    vRandDir = 1;
                    loadRandDir = -1;
                    if vTrend > 0
                        vRandDir = -1;
                        loadRandDir = 1;
                    end
                    v = CurrentStatus.busVMeasPu(busIdx);
                    CurrentStatus.busVMeasPu(busIdx) = v *(1 + vRandDir * fa.erroRatio);
                    % for ql and pl on this bus, bus the same random signal
                    % ratio method as v
                    idxLoad = find(ResultData.allLoadIdx==busIdx);
                    if ~isempty(idxLoad)
                        pl = CurrentStatus.ploadMeas(idxLoad) ;
                        CurrentStatus.ploadMeas(idxLoad) = pl * (1 + loadRandDir* fa.erroRatio);
                        ql = CurrentStatus.qloadMeas(idxLoad) ;
                        CurrentStatus.qloadMeas(idxLoad) = ql * (1 + loadRandDir * fa.erroRatio);
                    end 
                case 6    %MDP attack for false data injection to substations
                    
                    n = length(ResultData.t);
                    MDPData_k = ResultData.MDPData{iAttack};
                    if fa.calWARD
                        V = DAE.y(Bus.v);
                        a = DAE.y(Bus.a);
                        U = V.*exp(1i*a);
                        CurrentStatus2.SB = U(MDPData_k.BusB).*conj(MDPData_k.YBBp*U(MDPData_k.BusB) + MDPData_k.YBI*U(MDPData_k.BusI));
                        CurrentStatus2.PB = real(CurrentStatus2.SB);
                        CurrentStatus2.QB = imag(CurrentStatus2.SB);
                    end
                    %initialization
                    if n == 1 && fa.Qlearning == 1
                        if fa.autoOffset
                            MDPData_k.stateOffset = [];
                            for stateNameIndex = 1:length(fa.MDPStateName)
                                offset = eval(['(fa.MDPStateLimits(stateNameIndex,2)+fa.MDPStateLimits(stateNameIndex,1))/2' ...
                                    '-CurrentStatus2.' fa.MDPStateName{stateNameIndex}]);
                                MDPData_k.stateOffset = [MDPData_k.stateOffset;offset];
                            end
                        else
                            MDPData_k.stateOffset = zeros(length(fa.MDPStateName),1);
                        end
                    end
                    
                    
                    %get new state from simulation
                    states = ones(length(fa.MDPStateName),1);
                    s_new = 0;
                    ds_new = zeros(1,length(fa.MDPStateName));
                    for stateNameIndex = 1:length(fa.MDPStateName)
                        eval(['S = CurrentStatus2.' fa.MDPStateName{stateNameIndex} ';']);
                        statemin = fa.MDPStateLimits(stateNameIndex,1) - MDPData_k.stateOffset(stateNameIndex);
                        statemax = fa.MDPStateLimits(stateNameIndex,2) - MDPData_k.stateOffset(stateNameIndex);
                        statestep = (statemax-statemin)/(fa.Nstate(stateNameIndex)-2);
                        states(stateNameIndex) = ceil((S-statemin)/statestep)+1;
                        % consider the limits
                        if states(stateNameIndex) < 1 , states(stateNameIndex) = 1;
                        elseif states(stateNameIndex) > fa.Nstate(stateNameIndex) , states(stateNameIndex) = fa.Nstate(stateNameIndex);
                        end
                        ds_new(stateNameIndex) = states(stateNameIndex)-1;
                        s_new = s_new*fa.Nstate(stateNameIndex)+states(stateNameIndex)-1;
                    end
                    s_new = s_new + 1;
                    MDPData_k.s_new = s_new;
                    MDPData_k.ds_new = ds_new;
                    
                    %initialization
                    if n == 1 && fa.Qlearning == 1 % && fa.Continouslearning == 0
                        MDPData_k.s = MDPData_k.s_new;
                        MDPData_k.ds = MDPData_k.ds_new;
                    end

                    %get reward
                    switch fa.reward
                        case 'voltage'
                            v = CurrentStatus.busVMeasPu(fa.toBus);
                            if abs(v-1+MDPData_k.stateOffset(1))<0.1
                                MDPData_k.r = - MDPData_k.stateOffset(1) + 2 - v ;
                            elseif v-1+MDPData_k.stateOffset(1)-0.1>=0
                                MDPData_k.r = 0.1 + 1;
                            elseif v-1+MDPData_k.stateOffset(1)+0.1<=0
                                MDPData_k.r = -3*(v-1+MDPData_k.stateOffset(1)+0.1) + 0.1 + 1;
                            end
                            % penal for OPF not converged
                            if fa.PenalForNotConvergence && ~CurrentStatus.isOpfConverged && MDPData_k.r<2.3
                                MDPData_k.r = 0;
                            end
                        case 'pLoss'
                            MDPData_k.r = ResultData.pLossHis(end);
                        case 'minEigValue'
                            MDPData_k.r = - ResultData.minEigValueHis(end);
                            % penal for OPF not converged
                            if fa.PenalForNotConvergence && ~CurrentStatus.isOpfConverged
                                MDPData_k.r = -5;
                            end
                        case 'discrate'
                            MDPData_k.r = -MDPData_k.ds_new(1)+0.5*fa.Nstate(1)+0.5;
                            % penal for OPF not converged
                            if fa.PenalForNotConvergence && ~CurrentStatus.isOpfConverged
                                MDPData_k.r = 0;
                            end
                    end
                    

                    
                    if MDPData_k.a>0
                        Iter =  MDPData_k.Iters(MDPData_k.s,MDPData_k.a);
                    else
                        Iter = 0;
                    end
                    
                    % Record history
                    if MDPData_k.a>0
                        MDPData_k.Iters(MDPData_k.s,MDPData_k.a) = Iter+1;
                    end
                    MDPData_k.ActionHistory = [MDPData_k.ActionHistory MDPData_k.a];
                    MDPData_k.StatesHistory = [MDPData_k.StatesHistory MDPData_k.s];
                    MDPData_k.rHistory = [MDPData_k.rHistory MDPData_k.r];
                    MDPData_k.VHistory = [MDPData_k.VHistory CurrentStatus.busVMeasPu(fa.toBus)];
                    
                    % record S_B
                    if fa.calWARD
                        MDPData_k.SBHistory = [MDPData_k.SBHistory CurrentStatus2.SB];
                    end
                    if fa.Qlearning && ResultData.t(end)<=fa.LearningEndTime && MDPData_k.a>0
                        % Updating the value of Q   
                        % Decaying update coefficient (1/sqrt(Iter+2)) can be changed
                        delta = MDPData_k.r + fa.MDPDiscountFactor*max(MDPData_k.Q(MDPData_k.s_new,:)) - MDPData_k.Q(MDPData_k.s,MDPData_k.a);
                        dQ = eval(fa.learningRate)*delta;
                        MDPData_k.Q(MDPData_k.s,MDPData_k.a) = MDPData_k.Q(MDPData_k.s,MDPData_k.a) + dQ;
                    end

                    % Current state is updated
                    MDPData_k.s = MDPData_k.s_new;
                    MDPData_k.ds = MDPData_k.ds_new;

                    % Action choice : greedy with increasing probability
                    % probability 1-(1/log(Iter+2)) can be changed
                    % pn = rand(1); %(pn < (1-(1/log(Iter+2))))
                    if  fa.Qlearning == 0 || ResultData.t(end)>fa.LearningEndTime || nnz(MDPData_k.Q(MDPData_k.s,:))>=fa.maxLearnedAction
                      [Value,MDPData_k.a] = max(MDPData_k.Q(MDPData_k.s,:));
                      if isfield(fa,'minAttackValue') && Value<fa.minAttackValue
                        MDPData_k.a = -1;
                      end
                    else
                      MDPData_k.a = randi([1,prod(fa.Naction)]);
                    end
%                     MDPData_k.id = MDPData_k.id + 1;
%                     if mod(length(MDPData_k.rHistory),15)<5
%                         MDPData_k.a = 8627;
%                     else
%                         MDPData_k.a = 1626;
%                     end
%                    MDPData_k.a = 5;
                    try
                        MDPData_k.a = fa.fixedAction(length(MDPData_k.ActionHistory)+1);
                    catch e
                    end

                    %take action
                    if MDPData_k.a > -0.5
                        Ratios = action2Ratio(MDPData_k.a,fa.Naction,fa.MDPBusFalseDataRatioStep,fa.RatioOffset);

                        for k = 1:length(Ratios)
                            eval(['CurrentStatus.' fa.InjectionName{k}  ...
                                ' = CurrentStatus2.' fa.InjectionName{k} ' * Ratios(k);']);
                            if Config.seEnable && Ratios(k)~=1
                                injc = fa.InjectionName{k};
                                id1 = strfind(injc,'(');
                                id2 = strfind(injc,')');
                                injcName = injc(1:id1-1);
                                injcID = str2num(injc(id1+1:id2-1));
                                temp = ResultData.falseDataInjSet.(injcName);
                                temp(injcID,end)=1;
                                ResultData.falseDataInjSet.(injcName)=temp;
                            end
                        end
                    end
                    
                    %record MDP data
                    ResultData.MDPData{iAttack} = MDPData_k;
                otherwise  
            end               
        end
    end
    
end


end
