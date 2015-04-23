function [ ResultData, isConverged ] = obtainOpfControlCommand( CurrentStatus, ResultData, Config)

%% using latest meas
CurrentStatus.bus(ResultData.allLoadIdx, 3) = CurrentStatus.ploadMeas * 100;
CurrentStatus.bus(ResultData.allLoadIdx, 4) = CurrentStatus.qloadMeas * 100;
CurrentStatus.bus(ResultData.allBusIdx, 8) = CurrentStatus.busVMeasPu;
CurrentStatus.gen(ResultData.allGenIdx,2) = CurrentStatus.genPMeas * 100;
CurrentStatus.gen(ResultData.allGenIdx,3) = CurrentStatus.genQMeas * 100;


% %% limit the controllablity of the gens
if Config.limitControlled == 1
    CurrentStatus.gen(ResultData.allGenIdx,9) = min(CurrentStatus.genPMeas*1.2*100, CurrentStatus.genControllabilty(ResultData.allGenIdx, 1));
    CurrentStatus.gen(ResultData.allGenIdx,10) = max(CurrentStatus.genPMeas*0.8*100, CurrentStatus.genControllabilty(ResultData.allGenIdx, 2));
end

%% remove all isolated bus
CurrentStatus2 = CurrentStatus;
CurrentStatus2.branch = [];
for i = 1 : length(CurrentStatus.branch(:,1))
    if CurrentStatus.branch(i, 11)
        CurrentStatus2.branch = [CurrentStatus2.branch; CurrentStatus.branch(i, :)];
    end
end


for i = 1 : length(CurrentStatus.branch(:,1))
    if CurrentStatus.branch(i, 11) == 0
        fBus = CurrentStatus.branch(i, 1);
        tBus = CurrentStatus.branch(i, 2);
        CurrentStatus2 = removeIsolatedBus(fBus,CurrentStatus2);
        CurrentStatus2 = removeIsolatedBus(tBus,CurrentStatus2);
    end
end
        
% %% run state estimation
% % flat start
if Config.seEnable == 1
    % deal with the possible exceptions during the state estimation
    try
        [baseMVA, bus, gen, branch, se_success,error_sqrsum, fdSet] = stateEstimate(ResultData, CurrentStatus2, Config);
        ResultData.seErrorHis = [ResultData.seErrorHis error_sqrsum];
    catch e
        se_success = 0;
        ResultData.seErrorHis = [ResultData.seErrorHis +inf];
    end
    if se_success == 1
        
        for fdName = fieldnames(fdSet)'
            ResultData.falseDataDctSet.(fdName{1}) = [ResultData.falseDataDctSet.(fdName{1}) fdSet.(fdName{1})];
        end
        
        CurrentStatus2.bus = bus;
%         CurrentStatus2.bus(:,[3 4]) = 0;
%         CurrentStatus2.bus(ResultData.allLoadIdx,[3 4]) = bus(ResultData.allLoadIdx, [3 4]);
        CurrentStatus2.branch = branch;
        CurrentStatus2.gen = gen;
        ResultData.bus = bus;
       %% run opf
        optresult = runopf(CurrentStatus2, Config.opt);

       %% set opf result back to PSAT as control set point
        if optresult.success == 1
            ResultData.pLForCtrlHis = [ResultData.pLForCtrlHis, CurrentStatus.ploadMeas];
            ResultData.qLForCtrlHis = [ResultData.qLForCtrlHis, CurrentStatus.qloadMeas];
            ResultData.pLForOPF = [ResultData.pLForOPF, bus(ResultData.allLoadIdx,3)];
            ResultData.qLForOPF = [ResultData.qLForOPF, bus(ResultData.allLoadIdx,4)];
            ResultData.pGenCtrlHis = [ResultData.pGenCtrlHis, optresult.gen(:, 2)/100];
            ResultData.qGenCtrlHis = [ResultData.qGenCtrlHis, optresult.gen(:, 3)/100];
            ResultData.vGenCtrlHis = [ResultData.vGenCtrlHis, optresult.gen(:, 6)];
            ResultData.tCtrlHis = [ResultData.tCtrlHis, ResultData.t(end)];
        else
            disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> opf failed']);
        end
        isConverged = optresult.success;
    else
        for fdName = fieldnames(ResultData.falseDataDctSet)'
            dataLen = size(CurrentStatus.(fdName{1}),1);
            ResultData.falseDataDctSet.(fdName{1}) = [ResultData.falseDataDctSet.(fdName{1}) sparse(dataLen,1)];
        end
        disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> se failed']);
        isConverged = 0;
    end
else
    %% run opf
    optresult = runopf(CurrentStatus2, Config.opt);

    %% set opf result back to PSAT as control set point
    if optresult.success == 1
        ResultData.pLForCtrlHis = [ResultData.pLForCtrlHis, CurrentStatus.ploadMeas];
        ResultData.qLForCtrlHis = [ResultData.qLForCtrlHis, CurrentStatus.qloadMeas];
        ResultData.pGenCtrlHis = [ResultData.pGenCtrlHis, optresult.gen(:, 2)/100];
        ResultData.qGenCtrlHis = [ResultData.qGenCtrlHis, optresult.gen(:, 3)/100];
        ResultData.vGenCtrlHis = [ResultData.vGenCtrlHis, optresult.gen(:, 6)];
        ResultData.tCtrlHis = [ResultData.tCtrlHis, ResultData.t(end)];
    else
        disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> opf failed']);
    end
    isConverged = optresult.success;
end


end

function CurrentStatus2 = removeIsolatedBus(fBus,CurrentStatus2)
hasFBus = [ find(CurrentStatus2.branch(:,1)==fBus); ...
    find(CurrentStatus2.branch(:,2)==fBus)];
if isempty(hasFBus)
    disp(['remove isolated bus', num2str(fBus)]);
    idxBus = find(CurrentStatus2.bus(:, 1) == fBus);
    if ~isempty(idxBus)
        CurrentStatus2.bus(idxBus, :) = [];
    end
    idxBus = find(CurrentStatus2.gen(:, 1) == fBus);
    if ~isempty(idxBus)
        CurrentStatus2.gen(idxBus, :) = [];
    end
end

end