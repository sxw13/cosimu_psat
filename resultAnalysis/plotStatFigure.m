close all;
[m,n] = size(statTable);
conditionExp = 'S.maxSEIter~=20';
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
    for x_value = xx
        idx = find(x==x_value);
        plot(x(idx),y(idx),'MarkerSize',4,'Marker','square','MarkerSize',6,'LineWidth',2);
        hold on;
    end
    title(statTable{1,jj});xlabel('Bus Number');
    set(gca,'XTick',[0 xx xx(end)+1]);
    xlim(gca,[0 xx(end)+1]);
    grid on;
end
