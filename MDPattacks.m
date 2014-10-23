
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
mkdir(['debug\' startTime]);
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);
pwdpath = pwd;

Config = initialConfig;

Config.loadShapeCsvFile = 'LoadShape2.csv';
Config.caseName = 'd_009ieee_edit.m';
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
Config.distrsw = 1; % 0 for single slack bus model, 1 for distributed slack bus model.
Config.calEigs = 1; % 1 for calculate the eigent values of the Jaccobi matrix

% enable state estimation
Config.seEnable = 1;

%Time 
Config.simuEndTime =  24 * 3600;
Config.controlPeriod = 60;
Config.sampleRate  = 10;
Config.lfTStep = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
%%%%%%%%%%%%%define a false attack element
FalseData.toBus = 5;
FalseData.strategy = 6; % for MDP attack on pl and ql; 
FalseData.MDPBusVStateStep = 0.01;
FalseData.MDPStateName = {'ploadMeas(1)'};
FalseData.MDPStateLimits = [0.7 1.3];
FalseData.Nstate = [5];  % total number of state
FalseData.Naction = [3 3 3 3];   % total number of action
FalseData.MDPBusFalseDataRatioStep = [2 2 2 2];  % Step for false data ratio
FalseData.PenalForNotConvergence = 1;  % 1 for penal ; 0 for not penal
FalseData.InjectionName = {'plineHeadMeas(8)','qlineHeadMeas(8)','plineTailMeas(6)','qlineTailMeas(6)'};
FalseData.MDPDiscountFactor = 0;   % discount factor for value function of MDP
FalseData.RatioOffset = [2 0 2 0];
FalseData.reward = 'voltage';  % 'voltage' or 'pLoss' or 'minEigValue'
FalseData.Qlearning = 1; % 1 for learning; 0 for not learning
FalseData.LearningEndTime = 24 * 3600;
FalseData.learningRate = '2/(sqrt(Iter+1)+1)';
FalseData.fixedAction = [];  %-1 for a 
% FalseData.Continouslearning = 1-state; % 0 for setting all state iteration to zero;
%%%%%%%%%%%%%put a false attack element into config structure
Config.falseDataAttacks = {FalseData};

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineHeadMeas(9)','qlineHeadMeas(9)','plineTailMeas(7)','qlineTailMeas(7)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure
% 
%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineTailMeas(5)','qlineTailMeas(5)','plineTailMeas(4)','qlineTailMeas(4)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineTailMeas(1)','qlineTailMeas(1)','genPMeas(1)','genQMeas(1)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineTailMeas(2)','qlineTailMeas(2)','genPMeas(2)','genQMeas(2)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineTailMeas(3)','qlineTailMeas(3)','genPMeas(3)','genQMeas(3)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

falseDataAttacks2 = Config.falseDataAttacks;

tests = {[1 4],[1 2 4 5],[1 2 3 4 5 6]};
for testid = 1:length(tests)
    Config.falseDataAttacks = falseDataAttacks2(tests{testid});
    idd = 0;
    for ratio = 1
        for id = 1:length(Config.falseDataAttacks)
            Config.falseDataAttacks{id}.MDPBusFalseDataRatioStep = ratio * [2 2 2 2];
        end
        ResultData = MDPattack(Config,['SEAttack' num2str(idd) 'testid' num2str(testid)],[],startTime);
        idd = idd + 1;
    end
end

% tests = [1 2];
% Config.falseDataAttacks = falseDataAttacks2(tests);
% idd = 0;
% for ratio = linspace(0.3,1,5)
%     for id = 1:length(Config.falseDataAttacks)
%         Config.falseDataAttacks{id}.MDPBusFalseDataRatioStep = ratio * [1 1 1 1];
%     end
%     [ResultData,Config2] = MDPattack(Config,['SEAttack' num2str(idd)],[],startTime);
%     for id = 1:length(Config2.falseDataAttacks)
%         Config2.falseDataAttacks{id}.Qlearning = 0;
%     end
%     MDPattack(Config2,['SEAttack' num2str(idd) 'impl'],ResultData.MDPData,startTime);
%     idd = idd + 1;
% end