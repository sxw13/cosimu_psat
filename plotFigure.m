close all;

filter = {'SEAttack0','SEAttack1','SEAttack2','SEAttack3','SEAttack4','SEAttack5'};
path = '.\debug';
lists=dir(path);
lines=[1 0 0
        0 1 0
        0 0 1
        1 1 0
        1 0 1
        0 1 1];
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
  };

nfig=0;
for name=areanames
    j=1;l=cell(0);
    areaname=name{1};
    nfig=nfig+1;figure(nfig);
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
                eval(['f=' areaname '.*(' areaname '<10);']);
                if isempty(strfind(areaname,'Ctrl')) && ~strcmp(areaname,'ResultData.minEigValueHis')
                    t=ResultData.t;
                elseif strcmp(areaname,'ResultData.minEigValueHis')
                    t=(0:length(f)-1)*Config.controlPeriod;
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
            recordStrategy(Config,ResultData);
        end
    end
end
