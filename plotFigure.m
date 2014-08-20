close all;

filter = 'case_ieee9_MDPattack_genPMeas_172800_20-Aug-2014-08-52-25';
lists=dir('.\debug');
lines={'b-','r-','k-','y-'};
areanames={'ResultData.allPGenHis(1,:)' ...
    'ResultData.allPGenHis(2,:)' ...
    'ResultData.allPGenHis(3,:)' ...
    'ResultData.allBusVHis(4,:)' ...
    'ResultData.allBusVHis(5,:)' ...
    'ResultData.allBusVHis(6,:)' ...
    'ResultData.pLForCtrlHis(1,:)' ...
    'sum(ResultData.pGenCtrlHis)' ...
    'ResultData.pGenCtrlHis(1,:)'  ...
    'ResultData.pGenCtrlHis(2,:)'  ...
    'sum(ResultData.allPGenHis)' ...
    'ResultData.pLossHis'};

nfig=0;
for name=areanames
    j=1;l=cell(0);
    areaname=name{1};
    nfig=nfig+1;figure(nfig);
    title(areaname);
    for k=1:length(lists)
        file=lists(k);
        if file.isdir==0 && ~isempty(strfind(file.name,filter))
            S=load(['.\debug\' file.name],'ResultData');
            ResultData=S.ResultData;
            eval(['f=' areaname ';']);
            if isempty(strfind(areaname,'Ctrl'))
                t=ResultData.t;
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
