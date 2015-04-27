clear all;

startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
% mkdir(['debug\' 'single']);
initialPath;
pwdpath = pwd;

Config = initialConfig;

% Config.loadShapeCsvFile = 'LoadShapeSimple0.csv';
Config.loadShapeCsvFile = 'LoadShape3.csv';
Config.LoadShapeRatio = 1;
Config.caseName = 'd_039ieee_edit.m';
Config.opfCaseName = 'case_ieee39';
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

Config.distrsw = 0; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 1; % 1 for calculate the eigent values of the Jaccobi matrix

% enable state estimation
Config.seEnable = 0;
Config.maxSEIter = 1;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 100; % the threshold for false data detection

% Time
Config.simuEndTime =  3600;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.lfTStep = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
%%%%%%%%%%%%define a false attack element
FalseData.toBus = 3;
FalseData.strategy = 6; % for MDP attack on pl and ql;
FalseData = defaultFalseDataNoSE(Config,FalseData);
%%%%%%%%%%%%%put a false attack element into config structure
Config.falseDataAttacks = {FalseData};


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


ResultData = MDPattack(Config,['singleTest' startTime],[],'single');
% save(['debug\' startTime '\MultiRunConfig.mat'],'MultiRunConfig');



% mps = 6;
% matlabpool(mps);
%
% matlabpool close;




