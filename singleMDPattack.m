clear all;

startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
% mkdir(['debug\' 'single']);
initialPath;
pwdpath = pwd;

Config = initialConfig;

% Config.loadShapeCsvFile = 'LoadShapeSimple0.csv';
Config.loadShapeCsvFile = 'LoadShape3.csv';
Config.LoadShapeRatio = 2.4;
Config.caseName = 'd_039ieee_edit.m';
Config.opfCaseName = 'case_ieee39';
Config.hasOpf = 1;
Config.enableLoadShape = 1;
Config.measLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.measAllLatency = 1; % for latency of Config.measAllLatency*Config.DSSStepsize
Config.measLatencyChagePeriod = [0, Config.simuEndTime];
Config.measLaggedTunnel = 1 : 1 : 30;
Config.measTunnelLatency = zeros(size(Config.measLaggedTunnel));
Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.ctrlAllLatency = 1; % for latency of Config.ctrlAllLatency
Config.ctrlTGap = 0.1; % control time within current time +/- ctrlTGap => ctrl operation
Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks
Config.attackedBus = []; % bus list been attacked
Config.attackTime = [];  % attacked time in seconds

Config.distrsw = 1; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 1; % 1 for calculate the eigent values of the Jaccobi matrix

% enable state estimation
Config.seEnable = 1;
Config.maxSEIter = 10;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 0.5; % the threshold for false data detection

% Time
Config.simuEndTime =  3600 * 24;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.lfTStep = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
%%%%%%%%%%%%define a false attack element
FalseData.toBus = 31;
FalseData.strategy = 6; % for MDP attack on pl and ql;
opt = struct('N',5,'length',8);
FalseData = defaultFalseData(Config,FalseData,opt);
% load('ActionHistory.mat');
% FalseData.fixedAction = ActionHistory;
%%%%%%%%%%%%%put a false attack element into config structure
FalseData.maxLearnedAction = 300;
Config.falseDataAttacks = {FalseData};

% value = 2;
% for k = 1:length(Config.falseDataAttacks)
%     FalseData = Config.falseDataAttacks{k};
%     FalseData.MDPBusFalseDataRatioStep = FalseData.MDPBusFalseDataRatioStep * value;
%     Config.falseDataAttacks{k} = FalseData;
% end
% %%%%%%%%%%%%define a false attack element
% FalseData.toBus = 38;
% FalseData.strategy = 6; % for MDP attack on pl and ql;
% FalseData = defaultFalseData(Config,FalseData);
% %%%%%%%%%%%%%put a false attack element into config structure
% Config.falseDataAttacks{2} = FalseData;

% falseDataAttacks2 = Config.falseDataAttacks;

% MultiRunConfig.ConfigName = {'LoadShapeRatio','toBus','errorRatio'};
% MultiRunConfig.ConfigValue = {[0.3 0.45 0.6],1:39,linspace(0.5,2,6)};
% % MultiRunConfig.ConfigName = {'LoadShapeRatio','toBus1','toBus2','errorRatio'};
% % MultiRunConfig.ConfigValue = {[0.3 0.45 0.6],1:39,1:39,linspace(0.5,2,6)};
% 
% 
% n = length(MultiRunConfig.ConfigValue) ;
% [allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
% allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));
% [r, c] = size(allM);


if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);
else
    cd([pwd, '\loadshape\dyn']);
end
% Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);
cd(pwdpath);

% mps = 6;




% matlabpool size;
% if ans>0 matlabpool close;end
% matlabpool(mps);
% spmd
%     for i = 1 : r
%         %     fileName = dstFilePath;
%         if mod(i-1,mps)+1~=labindex continue;end
%         fileName='';
%         for j = 1 : c
%             value = allM(i,j);
%             switch MultiRunConfig.ConfigName{j}
%                 % user-defined edit of the Config structure
%                 case 'toBus'
%                     FalseData = Config.falseDataAttacks{1};
%                     FalseData.toBus = value;
%                     FalseData = defaultFalseData(Config,FalseData);
%                     Config.falseDataAttacks = {FalseData};
% %                 case 'toBus2'
% %                     FalseData = Config.falseDataAttacks{1};
% %                     FalseData.toBus = value;
% %                     FalseData = defaultFalseData(Config,FalseData);
% %                     Config.falseDataAttacks{2} = FalseData;
%                 case 'errorRatio'
%                     FalseData = Config.falseDataAttacks{1};
%                     FalseData.MDPBusFalseDataRatioStep = FalseData.MDPBusFalseDataRatioStep * value;
%                     Config.falseDataAttacks = {FalseData};
% %                     FalseData = Config.falseDataAttacks{2};
% %                     FalseData.MDPBusFalseDataRatioStep = FalseData.MDPBusFalseDataRatioStep * value;
% %                     Config.falseDataAttacks = {FalseData};
%                 otherwise
%                     Config.(MultiRunConfig.ConfigName{j}) = value;
%                     %                     eval(['Config.', MultiRunConfig.ConfigName{j}, '=',value]);
%             end
%             fileName = [fileName,MultiRunConfig.ConfigName{j},'_',num2str(value),'_'];
%         end
%         MDPattack(Config,fileName,[],startTime);
%         disp(fileName);
%     end
% end
% 
% matlabpool close;
ResultData = MDPattack(Config,['singleTest' startTime],[],'single');
% save(['debug\' startTime '\MultiRunConfig.mat'],'MultiRunConfig');



% mps = 6;
% matlabpool(mps);
%
% matlabpool close;




