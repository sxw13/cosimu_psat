close all;

path = '.\debug\29-Oct-2014-17-47-52';
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
    'ResultData.minEigValueHis(960)' ...
};
cmdfilters={'~isempty(strfind(file.name,''Optimal__1'')) && ~isempty(strfind(file.name,''distr_1_''))',...
    '~isempty(strfind(file.name,''Optimal__2'')) && ~isempty(strfind(file.name,''distr_1_''))',...
    '~isempty(strfind(file.name,''Optimal__3'')) && ~isempty(strfind(file.name,''distr_1_''))',...
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

for yid=1:length(ynames)
    yname=ynames{yid};
    xname=xnames{yid};
    figure;
    title(yname);
    xlabel(xlabels{yid});
    for ff=1:length(cmdfilters)
        cmdfilter=cmdfilters{ff};
        y=[];
        x=[];
        for k=1:length(lists)
            file=lists(k);
            if file.isdir==0
                if eval(cmdfilter)
                    S=load([path '\' file.name]);
                    ResultData=S.ResultData;
                    Config=S.Config;
                    eval(['y=[y ' yname '];']);
                    eval(['x=[x ' xname '];']);
                end
            end
        end
        hold on;
        plot(x,y,'Color',lines(ff,:),'LineStyle','o');
    end
    legend(legends);
    grid on;
end
