%state=1:初始化，state=0:不初始化
function [ResultData,Config]=MDPattack(Config,label,MDPData,folder)
pwdpath = pwd;

if nargin<4
    folder = '.';
end

if nargin<3
    Config.MDPData = [];
else
    Config.MDPData = MDPData;
end

% if Config.simuType == 0
%     cd([pwd, '\loadshape\lf']);    
% else
%     cd([pwd, '\loadshape\dyn']);    
% end
% Config.loadShapeFile = [pwd, '\loadshapeHour'];
% delete *.mat
% createhourloadshape(Config);

% cd(pwdpath);

if Config.useBaseResult && Config.autoOPFLimit
    try
        baseResult = load(['baseResult\LoadShapeRatio_' num2str(Config.LoadShapeRatio) '_.mat']);
        baseResult = baseResult.ResultData;
        n = size(baseResult.allPGenHis,1);
        Config.pGenLimit = zeros(n,2);
        Config.pGenLimit(baseResult.allGenIdx,:) = [min(baseResult.allPGenHis,[],2) max(baseResult.allPGenHis,[],2)];
    catch
        Config.autoOPFLimit = 0;
    end
else
    Config.autoOPFLimit = 0;
end

if Config.useBaseResult && Config.autoSELimit
    try
        baseResult = load(['baseResult\LoadShapeRatio_' num2str(Config.LoadShapeRatio) '_.mat']);
        baseResult = baseResult.ResultData;
        n = size(baseResult.allPLoadHis,1);
        Config.pLoadLimit = [min(baseResult.allPLoadHis,[],2) max(baseResult.allPLoadHis,[],2)];
        Config.qLoadLimit = [min(baseResult.allQLoadHis,[],2) max(baseResult.allQLoadHis,[],2)];
    catch
        Config.autoSELimit = 0;
    end
else
    Config.autoSELimit = 0;
end

caseName = [Config.opfCaseName '_MDPattack_genPMeas_', num2str(Config.simuEndTime)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

ResultData = simplePSAT(Config);

cd(pwdpath);

resultFile = [pwdpath, '/debug/',folder,'/',label];
save([resultFile '.mat'], 'Config', 'ResultData');

end