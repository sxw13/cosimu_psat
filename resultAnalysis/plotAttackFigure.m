close all;
TestCaseNumber = 39;   %需要针对不同的结果重新设定
[m,n] = size(statTable);
defaultParameters = struct('LoadShapeRatio',1, ...
                            'errorRatio',2);
fd = fieldnames(defaultParameters);

ActionNum = Config.simuEndTime/Config.controlPeriod;
for jj = 5
    x = [];
    y = [];
    S = struct;
    ss = regexp(statTable{2,1},'_','split');
    for sid = 2:2:length(ss)
        S.(ss{sid-1})=[];
    end
    for ii = 2:m
        ss = regexp(statTable{ii,1},'_','split');
        
        for sid = 2:2:length(ss)
            S.(ss{sid-1})=[S.(ss{sid-1}) str2num(ss{sid})];
        end
        if ~isempty(strfind(statTable{ii,1},'toBus'))
            x = [x S.toBus(end)];
        else
            x = [x S.Branch(end)];
        end
        tempy = ones(ActionNum,1)*(-1);
        tempy(1:length(statTable{ii,jj})) =  statTable{ii,jj}';
        y = [y tempy];
    end
    figure('Color',[1 1 1]);
%     xx = ResultData.allLoadIdx';
    xx = 1:39;
    MM = zeros(ActionNum,length(xx));
    if isfield(S,'duplicate')
        for dps = 1:max(S.duplicate)
            M = [];
            for x_value = xx
                cache = (x==x_value);
                for fd_id = 1:length(fd)
                    if isfield(S,fd{fd_id})
                        cache = (cache & (S.(fd{fd_id})==defaultParameters.(fd{fd_id})));
                    end
                    cache = ( cache & (S.duplicate==dps) );
                end
                idx = find(cache);
                M = [M y(:,idx)];
            end
            MM = MM + M;
        end
    else
        M = [];
        for x_value = xx
            cache = (x==x_value);
            for fd_id = 1:length(fd)
                if isfield(S,fd{fd_id})
                    cache = (cache & (S.(fd{fd_id})==defaultParameters.(fd{fd_id})));
                end
            end
            idx = find(cache);
            M = [M y(:,idx)];
        end
        MM = MM + M;
    end
    yy = (1:ActionNum)/ActionNum*86400;%Config.simuEndTime;
    plotTimeFigure(yy,xx,MM');
    ylabel('攻击的变电站的位置');
    xlabel('时间/s');
    title('攻击者的行动状态');
    axesY39;
end