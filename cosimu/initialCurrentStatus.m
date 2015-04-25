function CurrentStatus = initialCurrentStatus(Config)

CurrentStatus = eval(Config.opfCaseName);
    CurrentStatus.gen(i,[4,5]) = [9999, -9999];
end
% CurrentStatus.gen(:, [9,10,4,5]) = Config.loadmult * CurrentStatus.gen(:, [9,10,4,5]); % deal with load mult
CurrentStatus.genControllabilty = CurrentStatus.gen(:, [9,10,4,5]);

CurrentStatus.loadBase = CurrentStatus.bus(:,[3, 4]);

