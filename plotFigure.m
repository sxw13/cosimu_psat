close all;

filter = {'case'};
path = '.\debug\22-Oct-2014-15-57-34';
%path = '.\debug\15-Oct-2014-23-44-45';
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
        0 0.5 1];
areanames={'ResultData.allPGenHis(1,:)' ...
    'ResultData.allPGenHis(2,:)' ...
    'ResultData.allPGenHis(3,:)' ...
    'ResultData.allBusVHis(1,:)' ...
    'ResultData.allBusVHis(2,:)' ...
    'ResultData.allBusVHis(3,:)' ...
    'ResultData.allBusVHis(4,:)' ...
    'ResultData.allBusVHis(5,:)' ...
    'ResultData.allBusVHis(6,:)' ...
    'ResultData.allBusVHis(7,:)' ...
    'ResultData.allBusVHis(8,:)' ...
    'ResultData.allBusVHis(9,:)' ...
    'ResultData.allPLoadHis(1,:)' ...
    'ResultData.allPLoadHis(2,:)' ...
    'ResultData.allPLoadHis(3,:)' ...
    'ResultData.pLossHis' ...
    'ResultData.minEigValueHis' ...
    'ResultData.pLForCtrlHis(1,:)' ...
    'ResultData.MDPData{1}.ActionHistory' ...
  };

for name=areanames
    j=1;l=cell(0);
    areaname=name{1};
    figure;
    title(areaname);
    xlabel('time/s');
    ylabel(areaname);
    for k=1:length(lists)
        file=lists(k);
        if file.isdir==0
            isShow = 0;
            for idd = 1:length(filter)
                if ~isempty(strfind(file.name,filter{idd})) isShow = 1;end
            end
            if isShow
                S=load([path '\' file.name]);
                ResultData=S.ResultData;
                Config=S.Config;
                % ³¬¹ý10¾ÍÆÁ±Î
                % eval(['f=' areaname '.*(' areaname '<10);']);
                eval(['f=' areaname ';']);
                if isempty(strfind(areaname,'Ctrl')) && isempty(strfind(areaname,'MDPData')) && ~strcmp(areaname,'ResultData.minEigValueHis')
                    t=ResultData.t;
                elseif strcmp(areaname,'ResultData.minEigValueHis') || ~isempty(strfind(areaname,'MDPData'))
                    t=(1:length(f))*Config.controlPeriod;
                else
                    t=ResultData.tCtrlHis;
                end
                hold on;plot(t,f,'Color',lines(j,:));
                l{j}=strrep(file.name,'_','\_');   %in order to display '_' in the legend
                j=j+1;
            end
        end
    end
    legend(l);grid on;
end

for k=1:length(lists)
    file=lists(k);
    if file.isdir==0
        isShow = 0;
            for idd = 1:length(filter)
                if ~isempty(strfind(file.name,filter{idd})) isShow = 1;end
            end
        if isShow
            S=load([path '\' file.name]);
            ResultData=S.ResultData;
            Config=S.Config;
            recordStrategy(Config,ResultData,strrep(file.name,'_','\_'));
        end
    end
end
