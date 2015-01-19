clear all;
%% initial path
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
mkdir(['debug\' startTime]);
initialPath;
pwdpath = pwd;

%% Import Test case
[Config, MultiRunConfig, cs] = IEEE39LineAttack;

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


%% Run Parallel Test
mps = 6;
matlabpool size;
if ans>0 matlabpool close;end
matlabpool(mps);
spmd
    for i = 1 : r
        %     fileName = dstFilePath;
        if mod(i-1,mps)+1~=labindex continue;end
        fileName='';
        for j = 1 : c
            value = allM(i,j);
            switch MultiRunConfig.ConfigName{j}
                % user-defined edit of the Config structure
                case 'toBus'
                    FalseData = Config.falseDataAttacks{1};
                    FalseData.toBus = value;
                    FalseData = defaultFalseData(Config,FalseData);
                    Config.falseDataAttacks = {FalseData};
%                 case 'toBus2'
%                     FalseData = Config.falseDataAttacks{1};
%                     FalseData.toBus = value;
%                     FalseData = defaultFalseData(Config,FalseData);
%                     Config.falseDataAttacks{2} = FalseData;
                case 'Branch'
                    fd = cs.branch(value,1);
                    td = cs.branch(value,2);
                    FalseData1 = Config.falseDataAttacks{1};
                    FalseData1.toBus = fd;
                    FalseData1 = defaultFalseData(Config,FalseData1);
                    Config.falseDataAttacks{1} = FalseData1;
                    FalseData2 = Config.falseDataAttacks{2};
                    FalseData2.toBus = td;
                    FalseData2 = defaultFalseData(Config,FalseData2);
                    Config.falseDataAttacks{2} = FalseData2;
                case 'errorRatio'
                    for k = 1:length(Config.falseDataAttacks)
                        FalseData = Config.falseDataAttacks{k};
                        FalseData.MDPBusFalseDataRatioStep = FalseData.MDPBusFalseDataRatioStep * value;
                        Config.falseDataAttacks{k} = FalseData;
                    end
                % default edit way of Config structure
                otherwise
                    Config.(MultiRunConfig.ConfigName{j}) = value;
            end
            fileName = [fileName,MultiRunConfig.ConfigName{j},'_',num2str(value),'_'];
        end
        MDPattack(Config,fileName,[],startTime);
        disp(fileName);
    end
end

matlabpool close;

%% deal result and save
opt.path = ['debug\' startTime];
stateFunc(opt);
save(['debug\' startTime '\MultiRunConfig.mat'],'MultiRunConfig');







