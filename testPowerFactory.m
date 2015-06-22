clear all;

startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
% mkdir(['debug\' 'single']);
initialPath;
pwdpath = pwd;

Config = initialConfig;
Config.simuType = 2; %For Power Factory

% Config.loadShapeCsvFile = 'LoadShapeSimple0.csv';
Config.loadShapeCsvFile = 'LoadShape3.csv';
Config.LoadShapeRatio = 1;
Config.caseName = 'd_009ieee_edit.m';
Config.opfCaseName = 'case_ieee9';
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


%use mips solver for opf
Config.opt = mpoption('VERBOSE',0, 'OUT_ALL', 0);
% enable state estimation
Config.seEnable = 1;
Config.maxSEIter = 10;  % the maximum number of se iteration to repair false data
Config.fDthreshold = 0.5; % the threshold for false data detection

% Time
Config.simuEndTime =  3600;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.PFTStep = 10;

Config.autoSELimit = 0;
Config.useBaseResult = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
% %%%%%%%%%%%%define a false attack element

if Config.enableLoadShape
    switch Config.simuType
        case 0
            cd([pwd, '\loadshape\lf']);
        case 1
            cd([pwd, '\loadshape\dyn']);
        case 2
            cd([pwd, '\loadshape\PowerFactory']);
    end
    Config.loadShapeFile = [pwd, '\loadshapeHour'];
    delete *.mat
    createhourloadshape(Config);
    cd(pwdpath);
end

ResultData = MDPattack(Config,['singleTest' startTime],[],'single');
% save(['debug\' startTime '\MultiRunConfig.mat'],'MultiRunConfig');





