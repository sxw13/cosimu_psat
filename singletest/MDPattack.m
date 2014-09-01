function MDPattack(commands,path,label)

% global MDPData TAction;
% global MDPData;

% SSS = load('Action.mat');
% TAction = SSS.Action;
cd ..
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);
pwdpath = pwd;

Config = initialConfig;

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
Config.enableLoadShape = 0;
Config.distrsw = 0; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 1; % 1 for calculate the eigent values of the Jaccobi matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
%%%%%%%%%%%%%define a false attack element
FalseData.toBus = 5;
FalseData.strategy = 6; % for MDP attack on pl and ql; 
FalseData.MDPBusVStateStep = 0.01;
FalseData.MDPStateName = {'ploadMeas(1)'};
FalseData.MDPStateLimits = [0.7 2];
FalseData.Nstate = [3];  % total number of state
FalseData.Naction = [5 5 5 5 5 5];   % total number of action
FalseData.MDPBusFalseDataRatioStep = [1 1 1 1 1 1];  % Step for false data ratio
FalseData.PenalForNotConvergence = 1;  % 1 for penal ; 0 for not penal
FalseData.InjectionName = {'ploadMeas(1)','qloadMeas(1)','ploadMeas(2)','qloadMeas(2)','ploadMeas(3)','qloadMeas(3)'};
FalseData.MDPDiscountFactor = 0;   % discount factor for value function of MDP
FalseData.RatioOffset = [2 2 2 2 2 2];
FalseData.reward = 'voltage';  % 'voltage' or 'pLoss' or 'minEigValue'
FalseData.Qlearning = 1; % 1 for learning; 0 for not learning
FalseData.LearningEndTime = 22 * 3600;
FalseData.learningRate = '2/(sqrt(Iter+1)+1)';
% FalseData.Continouslearning = 1-state; % 0 for setting all state iteration to zero;
%%%%%%%%%%%%%put a false attack element into config structure

% %%%%%%%%%%%%%define a false attack element
% FalseData2 = FalseData;
% FalseData2.InjectionName = {'ploadMeas(2)','qloadMeas(2)'};
% %%%%%%%%%%%%%put a false attack element into config structure
% 
% %%%%%%%%%%%%%define a false attack element
% FalseData3 = FalseData;
% FalseData3.InjectionName = {'ploadMeas(3)','qloadMeas(3)'};
% %%%%%%%%%%%%%put a false attack element into config structure


% Config.falseDataAttacks = {FalseData,FalseData2,FalseData3}; % target buses
Config.falseDataAttacks = {FalseData};

% if state
%     MDPData = cell(1,length(Config.falseDataAttacks));
% end

for id = 1:length(commands)
    eval(commands{id});
end


% enable state estimation
Config.seEnable = 0;

%Time 
Config.simuEndTime =  24 * 3600;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.lfTStep = 10;


if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

cd(pwdpath);

caseName = [Config.opfCaseName '_MDPattack_' label '_', num2str(Config.simuEndTime)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

ResultData = simplePSAT(Config);

cd(pwdpath);

resultFile = [pwdpath, '/debug/',path ,'/',caseName,'_', startTime];
save(resultFile, 'Config', 'ResultData');

cd singletest;

end