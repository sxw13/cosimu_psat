% this is a part of multi-run mdp attack
function runSingleCase(Config,MultiRunConfig,startTime,allM,cs,i)
fileName='';
c = size(allM,2);
for j = 1 : c
    value = allM(i,j);
    switch MultiRunConfig.ConfigName{j}
        % user-defined edit of the Config structure
        case 'toBus'
            FalseData = Config.falseDataAttacks{1};
            FalseData.toBus = value;
            if Config.seEnable
                FalseData = defaultFalseData(Config,FalseData);
            else
                FalseData = defaultFalseDataNoSE(Config,FalseData);
            end
            Config.falseDataAttacks = {FalseData};
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
                opt.length = value*4;
                opt.N = 5;
                FalseData = defaultFalseData(Config,FalseData,opt);
                Config.falseDataAttacks{k} = FalseData;
            end
        case 'duplicate'
            % default edit way of Config structure
        otherwise
            Config.(MultiRunConfig.ConfigName{j}) = value;
    end
    fileName = [fileName,MultiRunConfig.ConfigName{j},'_',num2str(value),'_'];
end
if exist(['debug\' startTime '\' fileName '.mat'],'file') return;end
MDPattack(Config,fileName,[],startTime);
disp(fileName);
end