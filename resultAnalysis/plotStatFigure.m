close all;
[m,n] = size(statTable);
conditionExp = 'S.LoadShapeRatio~=2.5';
for jj = 2:4
    x = [];
    y = [];
    for ii = 2:m
        ss = regexp(statTable{ii,1},'_','split');
        S = struct;
        for sid = 2:2:length(ss)
            S.(ss{sid-1})=str2num(ss{sid});
        end
        if eval(conditionExp) continue; end
        if ~isempty(strfind(statTable{ii,1},'toBus'))
            x = [x S.toBus];
        else
            x = [x S.Branch];
        end
        y = [y statTable{ii,jj}];
    end
    figure('Color',[1 1 1]);
    xx = unique(x);
    xx = sort(xx);
    for xidx = 1:length(xx)
        x_value = xx(xidx);
        idx = find(x==x_value);
        plot(ones(1,length(idx))*xidx,y(idx),'MarkerSize',4,'Marker','square','MarkerSize',6,'LineWidth',2);
        hold on;
    end
    title(statTable{1,jj});xlabel('Bus Number');
%     axesX46;
    axesX39;
%     axesDefault;
end
