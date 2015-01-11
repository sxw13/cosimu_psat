% �ı为�ɵ������µĹ���
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
Config.enableLoadShape = 0;
Config.distrsw = 0; % 0 for single slack bus model, 1 for distributed slack bus model.
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
FalseData.MDPStateName = {'busVMeasPu(5)','ploadMeas(1)','plineTailMeas(6)','qlineTailMeas(6)','plineHeadMeas(8)','qlineHeadMeas(8)'};
FalseData.MDPStateLimits = [0.9 1.1;0.7 1.3;0 0.6;0 0.6;0 0.6;0 0.6];
FalseData.Nstate = [7 5 5 5 5 5];  % total number of state
FalseData.Naction = [5 5 5 5];   % total number of action
FalseData.MDPBusFalseDataRatioStep = [2 2 2 2];  % Step for false data ratio
FalseData.PenalForNotConvergence = 1;  % 1 for penal ; 0 for not penal
FalseData.InjectionName = {'plineHeadMeas(8)','qlineHeadMeas(8)','plineTailMeas(6)','qlineTailMeas(6)'};
FalseData.MDPDiscountFactor = 0.75;   % discount factor for value function of MDP
FalseData.RatioOffset = [2 0 2 0];
FalseData.reward = 'voltage';  % 'voltage' or 'pLoss' or 'minEigValue' or 'discrate'
FalseData.Qlearning = 1; % 1 for learning; 0 for not learning
FalseData.LearningEndTime = Config.simuEndTime;
FalseData.learningRate = '2/(sqrt(Iter+1)+1)';
FalseData.fixedAction = [];  %-1 for a 
FalseData.calWARD = 0;
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

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineHeadMeas(1)','qlineHeadMeas(1)','plineTailMeas(8)','qlineTailMeas(8)','plineTailMeas(9)','qlineTailMeas(9)'};
FalseData.Naction = [5 5 5 5 5 5];   % total number of action
FalseData.MDPBusFalseDataRatioStep = [2 2 2 2 2 2];  % Step for false data ratio
FalseData.RatioOffset = [2 0 2 0 2 0];
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineHeadMeas(2)','qlineHeadMeas(2)','plineHeadMeas(4)','qlineHeadMeas(4)','plineHeadMeas(6)','qlineHeadMeas(6)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

%%%%%%%%%%%%%define a false attack element
FalseData.InjectionName = {'plineHeadMeas(3)','qlineHeadMeas(3)','plineHeadMeas(5)','qlineHeadMeas(5)','plineHeadMeas(7)','qlineHeadMeas(7)'};
Config.falseDataAttacks{length(Config.falseDataAttacks)+1} = FalseData;
%%%%%%%%%%%%%put a false attack element into config structure

falseDataAttacks2 = Config.falseDataAttacks;

tests = 1:9;

if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);
cd(pwdpath);

% tests = {[1],[2],[3],[4],[5],[6],[7],[8],[9]};
tests =  {[1 2 3 4]};
mps = 6;
matlabpool(mps);
taskId = 0;
Config.falseDataAttacks = falseDataAttacks2(1);
spmd
    for testid = 1:length(tests)
        for ratio = 1:6
%             for nstate = 3:2:7
                taskId = taskId + 1;
                if mod(taskId,mps)+1~=labindex , continue;end
                for idd = 1:length(Config.falseDataAttacks)
                    Config.falseDataAttacks{idd}.MDPStateName = falseDataAttacks2{idd}.MDPStateName(tests{testid});
                    Config.falseDataAttacks{idd}.MDPStateLimits = falseDataAttacks2{idd}.MDPStateLimits(tests{testid},:);
                    Config.falseDataAttacks{idd}.Nstate = falseDataAttacks2{idd}.Nstate(tests{testid}); %/5*nstate;
                    Config.falseDataAttacks{idd}.MDPBusFalseDataRatioStep = ratio * 2 * ones(1,length(Config.falseDataAttacks{idd}.MDPBusFalseDataRatioStep));
                end
                [ResultData, Config2] = MDPattack(Config,['StateTestChangeLoad_testId_' num2str(testid) 'ratio_' num2str(ratio)],[],startTime);
    %             disp(['SEAttack_Busid' num2str(AttackBus(testid)) 'ratio_' num2str(ratio) '    id=' num2str(taskId)]);

                Config2.simuEndTime = 6 * 3600;
                for idd = 1:length(Config2.falseDataAttacks)
                    Config2.falseDataAttacks{idd}.Qlearning = 0;
                end
                MDPattack(Config2,['OptimalChangeLoad_testId_' num2str(testid) 'ratio_' num2str(ratio)],ResultData.MDPData,startTime);
%             end
        end
    end
end
matlabpool close;