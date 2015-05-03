function stateFunc(opt)
if nargin<1 || ~isfield(opt,'path')
    path = '.';
else
    path = opt.path;
end

if nargin<1 || ~isfield(opt,'areaNames')
    areaNames={
        'minimalBusVolt' ...
        'minBusId' ...
        'minEigValue' ...
        'ActionState' ...
        '电压越限节点数' ...
        '漏检数' ...
        };
else
    areaNames = opt.areaNames;
end
if nargin<1 || ~isfield(opt,'areaExp')
    areaExp={
        'min(min(ResultData.allBusVHis))' ...
        'minIndex(min(ResultData.allBusVHis''))' ...
        'min(ResultData.minEigValueHis)' ...
        'giveoutActionState(ResultData.MDPData{1}.ActionHistory(1:legalActionID(ResultData,Config)))' ...
        'max(sum(ResultData.allBusVHis<0.9 | ResultData.allBusVHis>1.2))' ...
        'stealMeasNum(ResultData)' ...
        };
else
    areaExp = opt.areaExp;
end
if nargin<1 || ~isfield(opt,'cmdfilter')
    cmdfilter = '~isempty(strfind(file.name,''_.mat''))';
else
    cmdfilter = opt.cmdfilter;
end



statTable = [{'caseName'},areaNames];
lists=dir(path);
lineid = 2;
for k=1:length(lists)
    file=lists(k);
    if file.isdir==0
        if length(file.name)>4 && strcmp(file.name(end-3:end),'.mat') && eval(cmdfilter)
            S=load([path '\' file.name]);
            ResultData=S.ResultData;
            Config = S.Config;
            statTable{lineid,1} = file.name;
            for rowid = 1:length(areaExp)
                try
                    statTable{lineid,rowid+1} = eval(areaExp{rowid});
                catch e
                end
            end
            lineid = lineid + 1;
        end
    end
end
save([path '\statTable.mat'],'statTable');

    function y=minIndex(A)
        [~,y]=min(A);
    end
    function y=legalActionID(ResultData,Config)
        y = find(ResultData.minEigValueHis<0.01,1);
        if isempty(y)
            y = Config.simuEndTime/Config.controlPeriod;
        else
            y = y-1;
        end
    end
    function y = stealMeasNum(ResultData)
        inj = [];
        dct = [];
        fd = fieldnames(ResultData.falseDataDctSet);
        for fid = 1:length(fd)
            inj = [inj;ResultData.falseDataInjSet.(fd{fid})];
            dct = [dct;ResultData.falseDataDctSet.(fd{fid})];
        end
        steals = full(sum(inj & (~dct))).*ResultData.isOpfConverged;
        y = max(steals);
    end
    
end
