close all;

filter = 'case';
dataDir = '.\debug\28-Aug-2014-19-50-32';
lists=dir(dataDir);
lines={'b-','r-','k-','y-'};
areanames={'ResultData.allQGenHis(1,:)' ...
    'ResultData.allQGenHis(2,:)' ...
    'ResultData.allQGenHis(3,:)' ...
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

x = [];
ys = cell(length(areanames),1);
for y=ys
    y{1}=[];
end

for k=1:length(lists)
    file=lists(k);
    if file.isdir==0 && ~isempty(strfind(file.name,filter))
        S=load([dataDir '\' file.name]);
        ResultData=S.ResultData;
        Config=S.Config;
        x = [x Config.falseDataAttacks{1}.Naction(1)*Config.falseDataAttacks{1}.MDPBusFalseDataRatioStep(1)];
        for id=1:length(areanames)
            j=1;l=cell(0);
            areaname=areanames{id};
            temp = eval(areaname);
            ys{id}=[ys{id} temp(end)];
        end
    end
end

for id=1:length(ys)
    figure(id);
    plot(x,ys{id},'x');
    title(areanames{id});
end
