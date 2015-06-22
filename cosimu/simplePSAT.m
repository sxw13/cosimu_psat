function ResultData = simplePSAT(Config)
initpsat
clpsat.mesg = Config.verbose; 
% Time domain simulation
disp('Time domain simulation.')
Settings.freq = 60;
clpsat.readfile = 1;
Settings.fixt = 1;
Settings.distrsw = Config.distrsw;
% Settings.static = Config.simuType;

runpsat(Config.caseName,Config.caseFileDir,'data');

CurrentStatus = initialCurrentStatus(Config);

simplePF(Config, CurrentStatus);


switch Config.simuType
    case 0
        Settings.tstep = Config.lfTStep;
    case 1
        Settings.tstep = Config.dynTStep;
    case 2
        Settings.tstep = Config.PFTStep;
end

Settings.tf = Config.simuEndTime;
clpsat.pq2z = 0;
ResultData = initialResultData(Config, CurrentStatus);
switch Config.simuType
    case 0
        ResultData = cosimu_lf(Config, CurrentStatus, ResultData);
    case 1
        ResultData = cosimu_dyn(Config, CurrentStatus, ResultData);
    case 2
        ResultData = cosimu_PowerFactory(Config, CurrentStatus, ResultData);
end
