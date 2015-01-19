function stateFunc(path)
if nargin<1 || ~isfield(opt,'path')
    path = '.';
end

if nargin<1 || ~isfield(opt,'areaNames')
    areaNames={
        'minimalBusVolt' ...
        'minEigValue' ...
        };
end
if nargin<1 || ~isfield(opt,'areaExp')
    areaExp={
        'min(min(ResultData.allBusVHis(:,4:end))'')' ...
        'min(ResultData.minEigValueHis)' ...
        };
end
if nargin<1 || ~isfield(opt,'cmdfilter')
    cmdfilter = '~isempty(strfind(file.name,''Load''))';
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
save([path '\statTable.mat'],statTable);

end