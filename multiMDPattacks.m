clear all;
%% initial path
% startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
startTime = 'IEEE39BusNoSEMaxLearn9';
if ~exist(['debug\' startTime],'dir')
    mkdir(['debug\' startTime]);
end
initialPath;
pwdpath = pwd;

%% Import Test case
[Config, MultiRunConfig, cs] = IEEE39BusAttackNoSE;

%% Generate test scenarios
n = length(MultiRunConfig.ConfigValue) ;
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));
[r, c] = size(allM);


%% creat load shape file
if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);
else
    cd([pwd, '\loadshape\dyn']);
end
% Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);
cd(pwdpath);


%% Run Test
isParalell = 1;
if isParalell
    mps = 6;
    matlabpool size;
    if ans>0 matlabpool close;end
    matlabpool(mps);
    spmd
        for i = 1 : r
            %     fileName = dstFilePath;
            if mod(i-1,mps)+1~=labindex continue;end
            runSingleCase(Config,MultiRunConfig,startTime,allM,cs,i);
        end
    end
    matlabpool close;
else
    for i = 1 : r
        runSingleCase(Config,MultiRunConfig,startTime,allM,cs,i);
    end
end

%% deal result and save
opt.path = ['debug\' startTime];
stateFunc(opt);
save(['debug\' startTime '\MultiRunConfig.mat'],'MultiRunConfig');







