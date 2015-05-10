close all;
[m,n] = size(statTable);
lines=[1 0 0
    0 1 0
    0 0 1
    0 0 0
    1 0 1
    0 1 1
    1 0.5 0
    1 0 0.5
    0.5 1 0
    0.5 0 1
    0 1 0.5
    0 0.5 1
    1 0.5 0.5
    0.5 1 0.5
    0.5 0.5 1
    1 1 0.5
    1 0.5 1
    0.5 1 1];
conditionExpVars = {'S.LoadShapeRatio~=2', ...
    'S.LoadShapeRatio~=2.3',...
    'S.LoadShapeRatio~=2.5',...
    'S.LoadShapeRatio~=2.6' ...
    };
legends0 = {'LoadShapeRatio=2', ...
    'LoadShapeRatio=2.3',...
    'LoadShapeRatio=2.5',...
    'LoadShapeRatio=2.6' ...
    };
conditionExp = 'S.LoadShapeRatio~=2.5';
for jj = [2:4 6 7]
    figure('Color',[1 1 1]);
    for cidx = 1:length(conditionExpVars)
        conditionExp = conditionExpVars{cidx};
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
        
        xx = unique(x);
        xx = sort(xx);

        xData = [];
        yData = [];
        for xidx = 1:length(xx)
            x_value = xx(xidx);
            idx = find(x==x_value);
            xData = [xData ones(1,length(idx))*xidx];
            yData = [yData y(idx)];
        end
        plot(xData,yData,'MarkerSize',4,'Marker','square','MarkerSize',6,'LineWidth',2,'Color',lines(cidx,:));
        hold on;
    end
    title(statTable{1,jj});xlabel('受到攻击的支路编号');
    legend(legends0);
%     axesX46;
    axesX39;
%     axesDefault;
end
