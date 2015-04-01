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
        };
else
    areaNames = opt.areaNames;
end
if nargin<1 || ~isfield(opt,'areaExp')
    areaExp={
        'min(min(ResultData.allBusVHis(:,4:end)))' ...
        'minIndex(min(ResultData.allBusVHis(:,4:end)''))' ...
        'min(ResultData.minEigValueHis)' ...
        'giveoutActionState(ResultData.MDPData{1}.ActionHistory)' ...
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
                statTable{lineid,rowid+1} = eval(areaExp{rowid});
            end
            lineid = lineid + 1;
        end
    end
end
save([path '\statTable.mat'],'statTable');

    function y=minIndex(A)
        [~,y]=min(A);
    end
end
