function Config = initialConfig

Config.verbose = 0;

Config.simuType = 0; % 0 for pf based , 1 for transient based

% Config.simuTime = 60*60/0.05;
Config.simuEndTime = 6*3600;
Config.basedir = [pwd, '\'];
Config.debugdir = [pwd, '\debug\'];
Config.caseFileDir = [pwd, '\psat\tests'];
Config.caseName = 'd_009ieee.m';
Config.sampleRate  = 1;
Config.controlPeriod = 60;
Config.opfCaseName = 'case_ieee9';
Config.hasOpf = 1;
Config.limitControlled = 0;
Config.loadShapeFile = 'loadshapeHour';
Config.loadShapeCsvFile = 'LoadShapeSimple.csv';
Config.enableOPFCtrl = 1;
Config.enableLoadShape = 1;
Config.distrsw = 0; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 0;


Config.lfTStep = 1;
Config.dynTStep = 0.05;

% Config.opt = mpoption('VERBOSE',0, 'OUT_ALL', 0);
Config.opt = mpoption('VERBOSE',0, 'OUT_ALL', 0, 'OPF_ALG', 580);


%% for state estimation
Config.seEnable = 1;
Config.maxSEIter = 1;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 20; % the threshold for false data detection

%% for communications and controls
Config.measLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize 
Config.measLaggedTunnel = 1 : 1 : 30;
Config.measTunnelLatency = zeros(size(Config.measLaggedTunnel));
Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.ctrlAllLatency = 1; % for latency of Config.ctrlAllLatency
Config.ctrlTGap = 0.1; % control time within current time +/- ctrlTGap => ctrl operation  
Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks
Config.attackedBus = []; % bus list been attacked
Config.attackTime = [];  % attacked time in seconds


Config.genSetpointType = 2; % 1 for v ; 2 for q

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
Config.measErroRatio = 0.3; % for the random erro 
%%%%%%%%%%%%%define a false attack element
FalseData.toBus = 2:3;
FalseData.strategy = 4; % for random erro on the pl and ql; 
FalseData.erroRatio = 1; 
FalseData.maxErroRatio = 1.5; 
FalseData.erroRatioStep = 0.05; 
FalseData.augDir = 1;
FalseData.highV = 1.05;
FalseData.lowV = 0.98;

% Configurations for WARD calulation
FalseData.calWARD = 0;
FalseData.internalBus = [5];
%%%%%%%%%%%%%put a false attack element into config structure
Config.falseDataAttacks = {FalseData}; % target buses


%% for load shedding
Config.vLow4Normal = 0.95;
Config.vHigh4Normal = 1.07;
Config.vLow4LoadShed = 0.85;
Config.vHigh4LoadShed = 1.5;
Config.vLow4LoadBack = 0.9;
Config.vHigh4LoadBack = 1.5;
Config.vShedSample = 4;
Config.vRecoverSample = 4;

%%for testing opf
Config.gen2 = 1145.11;


%% for performance evaluation

Config.normalEPrice = 0.5;
Config.badQosPenaltyPrice = 0.8;
Config.loadShedPenaltyPrice = 2.5;

%% for MDP studies
Config.MDPData = [];

%% for the load shape data location
if Config.simuType == 0
    Config.loadShapeFile = [pwd, '\loadshape\lf\loadshapeHour'];    
else
    Config.loadShapeFile = [pwd, '\loadshape\dyn\loadshapeHour'];
end



