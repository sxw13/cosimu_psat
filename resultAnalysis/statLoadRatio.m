close all;
[m,n] = size(statTable);
conditionExp = '0';
for jj = 2
    x = [];
    y = [];
    for ii = 2:m
        ss = regexp(statTable{ii,1},'_','split');
        S = struct;
        for sid = 2:2:length(ss)
            S.(ss{sid-1})=str2num(ss{sid});
        end
        if eval(conditionExp) continue; end
        x = [x S.LoadShapeRatio];
        y = [y statTable{ii,jj}];
    end
end

xx = unique(x);
xx = sort(xx);
n = length(xx);
ratioStat = zeros(n,3);
ratioStat(:,1) = xx';
for idx = 1:n
    ratioStat(idx,3) = sum(x==xx(idx));
    ratioStat(idx,2) = sum(x==xx(idx) & y<=0.05);
end