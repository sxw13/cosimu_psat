close all;
[m,n] = size(statTable);
for jj = 2:4
    x = zeros(1,1:m-1);
    y = zeros(1,1:m-1);
    for ii = 2:m
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
        A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_duplicate_%d_.mat');
        x(ii-1) = A(2);
        y(ii-1) = statTable{ii,jj};
    end
    figure('Color',[1 1 1]);
    xx = unique(x);
    for x_value = xx
        idx = find(x==x_value);
        plot(x(idx),y(idx),'MarkerSize',4,'Marker','square','LineWidth',2);
        hold on;
    end
    title(statTable{1,jj});
end
