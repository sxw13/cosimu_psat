close all;

path = '.\debug\CompareBetweenSSBandDSB';
%path = '.\debug\28-Oct-2014-00-27-30';
lists=dir(path);
lines=[1 0 0
        0 1 0
        0 0 1
        1 1 0
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
ynames={
    'min(ResultData.minEigValueHis)' ...
};
cmdfilters={'~isempty(strfind(file.name,''Optimal__1'')) && ~isempty(strfind(file.name,''distr_0_''))',...
    '~isempty(strfind(file.name,''Optimal__2'')) && ~isempty(strfind(file.name,''distr_0_''))',...
    '~isempty(strfind(file.name,''Optimal__3'')) && ~isempty(strfind(file.name,''distr_0_''))',...
    };
xnames={
    '4*Config.falseDataAttacks{1,1}.MDPBusFalseDataRatioStep(1)' ...
};
xlabels = {
    'Error ratio range' ...
};
legends = {
    '2-bus attack' ...
    '3-bus attack' ...
    '4-bus attack' ...
};
titles={
    'minimal Eigenvalue' ...
    };
Xtrick = {
    '2-bus' ...
    '3-bus' ...
    '4-bus' ...
};


for yid=1:length(ynames)
    yname=ynames{yid};
    xname=xnames{yid};
    figure('Color',[1 1 1]);
    title(titles{yid});
    xlabel(xlabels{yid});
    bardata = [];
    for ff=1:length(cmdfilters)
        cmdfilter=cmdfilters{ff};
        y=[];
        x=[];
        for k=1:length(lists)
            file=lists(k);
            if file.isdir==0
                if length(file.name)>4 && strcmp(file.name(end-3:end),'.mat') && eval(cmdfilter)
                    S=load([path '\' file.name]);
                    ResultData=S.ResultData;
                    Config=S.Config;
                    eval(['y=[y ' yname '];']);
                    eval(['x=[x ' xname '];']);
                end
            end
        end
        hold on;
        XY = [x' y'];
        XY = sortrows(XY,1);
        plot(XY(:,1),XY(:,2),'Color',lines(ff,:),'Marker','v');
            %'Marker','v'
        bardata = [bardata min(y')];
        
    end
    legend(legends);
    grid on;
    
    figure('Color',[1 1 1]);
    b = bar(bardata);
    get(b,'children');
    set(gca,'XTickLabel',Xtrick);
    ylabel(titles{yid});
    grid on;
end
