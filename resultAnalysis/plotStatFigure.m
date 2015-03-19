close all;
[m,n] = size(statTable);
for jj = 2:4
    x = zeros(1,1:m-1);
    y = zeros(1,1:m-1);
    for ii = 2:m
        if ~isempty(strfind(statTable{ii,1},'maxSEIter'))
            A = sscanf(statTable{ii,1},'Branch_%d_errorRatio_%f_maxSEIter_%d_.mat');
        elseif ~isempty(strfind(statTable{ii,1},'duplicate'))
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_duplicate_%d_.mat');
        elseif ~isempty(strfind(statTable{ii,1},'toBus'))
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
        elseif ~isempty(strfind(statTable{ii,1},'Branch'))
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
        end
        x(ii-1) = A(2);
        y(ii-1) = statTable{ii,jj};
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
