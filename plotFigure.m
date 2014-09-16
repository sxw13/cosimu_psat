close all;

filter = 'reverseQ';
path = '.\debug\12-Sep-2014-00-12-14';
lists=dir(path);
lines={'b-','r-','k-','y-'};
areanames={'ResultData.allPGenHis(1,:)' ...
    'ResultData.allPGenHis(2,:)' ...
    'ResultData.allPGenHis(3,:)' ...
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
        if file.isdir==0 && ~isempty(strfind(file.name,filter))
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
            hold on;plot(t,f,lines{j});
            l{j}=strrep(file.name,'_','\_');   %in order to display '_' in the legend
            j=j+1;
        end
    end
    legend(l);grid on;
end

for k=1:length(lists)
    file=lists(k);
    if file.isdir==0 && ~isempty(strfind(file.name,filter))
        S=load([path '\' file.name]);
        ResultData=S.ResultData;
        Config=S.Config;
        recordStrategy(Config,ResultData);
    end
end
