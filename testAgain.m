load('D:\sxw13\oldData\IEEE39BusAttack(withSeLimit)\LoadShapeRatio_2.6_toBus_20_errorRatio_2_.mat');
pwdpath = pwd;
initialPath;
if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
% Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

% cd(pwdpath);
% inj = [];
% dct = [];
% fd = fieldnames(ResultData.falseDataDctSet);
% for fid = 1:length(fd)
%     inj = [inj;ResultData.falseDataInjSet.(fd{fid})];
%     dct = [dct;ResultData.falseDataDctSet.(fd{fid})];
% end
% Config.falseDataAttacks{1,1}.fixedAction = ResultData.MDPData{1,1}.ActionHistory;
% steals = full(sum(inj & (~dct))).*ResultData.isOpfConverged;
% (find(steals>0)-1)*Config.controlPeriod
Re = simplePSAT(Config);
