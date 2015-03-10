close all;
TestCaseNumber = 46;   %需要针对不同的结果重新设定
[m,n] = size(statTable);
ActionNum = length(statTable{2,5});
for jj = 5
    x = zeros(1,1:m-1);
    y = zeros(ActionNum,1:m-1);
    AA = [];
    for ii = 2:m
        if ~isempty(strfind(statTable{ii,1},'duplicate'))
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_duplicate_%d_.mat');
        elseif ~isempty(strfind(statTable{ii,1},'toBus'))
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
        elseif ~isempty(strfind(statTable{ii,1},'Branch'))
            A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
        end
        x(ii-1) = A(2);
        y(:,ii-1) = statTable{ii,jj}';
        AA = [AA A];
    end
    figure('Color',[1 1 1]);
    xx = 1:TestCaseNumber;
    MM = zeros(ActionNum,length(xx));
    if ~isempty(strfind(statTable{ii,1},'duplicate'))
        for dps = 1:max(AA(end,:))
            M = [];
            for x_value = xx
                idx = find(x==x_value & AA(1,:)==1 & AA(3,:)==2 & AA(4,:)==dps);
                M = [M y(:,idx)];
            end
            MM = MM + M;
        end
    else
        M = [];
        for x_value = xx
            idx = find(x==x_value & AA(1,:)==1 & AA(3,:)==2);
            M = [M y(:,idx)];
        end
        MM = MM + M;
    end
    yy = (1:ActionNum)/ActionNum*Config.simuEndTime;
    plotTimeFigure(yy,xx,MM');
    ylabel({'Attacked Bus Number'});
    xlabel({'Time/s'});
    title(statTable{1,jj});
end