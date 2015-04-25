function [Config, MultiRunConfig, cs] = IEEE39RandomAttack
Config = initialConfig;

Config.loadShapeCsvFile = 'LoadShape3.csv';
Config.LoadShapeRatio = 1;
Config.caseName = 'd_039ieee_edit.m';
Config.opfCaseName = 'case_ieee39';
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
Config.enableLoadShape = 1;
Config.distrsw = 0; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 1; % 1 for calculate the eigent values of the Jaccobi matrix

% enable state estimation
Config.seEnable = 1;
Config.maxSEIter = 20;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 0.5; % the threshold for false data detection

% Time
Config.simuEndTime =  24 * 3600;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.lfTStep = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
%%%%%%%%%%%%%define a false attack element
FalseData.toBus = 5;
FalseData.strategy = 6; % for MDP attack on pl and ql;
% FalseData = defaultFalseData(Config,FalseData);
%%%%%%%%%%%%%put a false attack element into config structure
FalseData.maxLearnedAction = 50;
Config.falseDataAttacks = {FalseData};


cs = eval(Config.opfCaseName);

MultiRunConfig.ConfigName = {'attackNumber','rand','errorRatio','duplicate'};
MultiRunConfig.ConfigValue = {3:5,1,2,1:40};
% MultiRunConfig.ConfigName = {'LoadShapeRatio','toBus1','toBus2','errorRatio'};
% MultiRunConfig.ConfigValue = {[0.3 0.45 0.6],1:39,1:39,linspace(0.5,2,6)};

end